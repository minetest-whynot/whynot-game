local function check_protection(pos, name)
	if minetest.is_protected(pos, name) then
		minetest.log("action", name
			.. " tried to place a PAPI"
			.. " at protected position "
			.. minetest.pos_to_string(pos)
        )
		minetest.record_protection_violation(pos, name)
		return true
	end
	return false
end

function airutils.PAPIplace(player,pos)
    if not player then
        return
    end

	local dir = minetest.dir_to_facedir(player:get_look_dir())
	local pos1 = vector.new(pos)

    local player_name = player:get_player_name()
	if check_protection(pos, player_name) then
		return
	end

	core.set_node(pos, {name="airutils:papi", param2=dir})
	local meta = core.get_meta(pos)
	meta:set_string("infotext", "PAPI\rOwned by: "..player_name)
	meta:set_string("owner", player_name)
	meta:set_string("dont_destroy", "false")
	return true
end

function airutils.togglePapiSide(pos, node, clicker, itemstack)
	local player_name = clicker:get_player_name()
	local meta = core.get_meta(pos)

    if player_name ~= meta:get_string("owner") then
	    return
    end

    local dir=node.param2
    if node.name == "airutils:papi_right" then
        core.set_node(pos, {name="airutils:papi", param2=dir})
    	meta:set_string("infotext", "PAPI - left side\rOwned by: "..player_name)
    elseif node.name == "airutils:papi" then
        core.set_node(pos, {name="airutils:papi_right", param2=dir})
        meta:set_string("infotext", "PAPI - right side\rOwned by: "..player_name)
    end

	meta:set_string("owner", player_name)
	meta:set_string("dont_destroy", "false")
end

airutils.papi_collision_box = {
	type = "fixed",
	fixed={{-0.5,-0.5,-0.5,0.5,-0.42,0.5},},
}

airutils.papi_selection_box = {
	type = "fixed",
	fixed={{-0.5,-0.5,-0.5,0.5,1.5,0.5},},
}

airutils.groups_right = {snappy=2,choppy=2,oddly_breakable_by_hand=2,not_in_creative_inventory=1}
airutils.groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2}

-- PAPI node (default left)
minetest.register_node("airutils:papi",{
	description = "PAPI",
	--inventory_image = "papi.png",
	--wield_image = "papi.png",
	tiles = {"airutils_black.png", "airutils_u_black.png", "airutils_white.png",
	"airutils_metal.png", {name = "airutils_red.png", backface_culling = true},},
	groups = airutils.groups,
	paramtype2 = "facedir",
	paramtype = "light",
	drawtype = "mesh",
	mesh = "papi.b3d",
	visual_scale = 1.0,
	light_source = 13,
    backface_culling = true,
	selection_box = airutils.papi_selection_box,
	collision_box = airutils.papi_collision_box,
	can_dig = airutils.canDig,
    _color = "",
	on_destruct = airutils.remove,
	on_place = function(itemstack, placer, pointed_thing)
		local pos = pointed_thing.above
		if airutils.PAPIplace(placer,pos)==true then
			itemstack:take_item(1)
			return itemstack
		else
			return
		end
	end,
	on_rightclick=airutils.togglePapiSide,
    on_punch = function(pos, node, puncher, pointed_thing)
	    local player_name = puncher:get_player_name()
        local meta = core.get_meta(pos)
	    if player_name ~= meta:get_string("owner") then
            local privs = minetest.get_player_privs(player_name)
            if privs.server == false then
		        return
            end
	    end

        local itmstck=puncher:get_wielded_item()
        local item_name = ""
        if itmstck then item_name = itmstck:get_name() end

    end,
})

function airutils.remove_papi(pos)
    --[[
	local meta = core.get_meta(pos)
    local node = minetest.get_node(pos)
    if node and meta then
        local dir=node.param2
        if node.name == "airutils:papi_right" then
            core.set_node(pos, {name="airutils:papi", param2=dir})
        	meta:set_string("infotext", "PAPI - left side\rOwned by: "..player_name)
        end

	    meta:set_string("owner", player_name)
	    meta:set_string("dont_destroy", "false")

	    if meta:get_string("dont_destroy") == "true" then
		    -- when swapping it
		    return
	    end
    end]]--
end

-- PAPI right node
minetest.register_node("airutils:papi_right",{
    description = "PAPI_right_side",
	tiles = {"airutils_black.png", "airutils_u_black.png", "airutils_white.png",
	"airutils_metal.png", {name = "airutils_red.png", backface_culling = true},},
	groups = airutils.groups_right,
	paramtype2 = "facedir",
	paramtype = "light",
	drawtype = "mesh",
	mesh = "papi_right.b3d",
	visual_scale = 1.0,
	light_source = 13,
    backface_culling = true,
	selection_box = airutils.papi_selection_box,
	collision_box = airutils.papi_collision_box,
	can_dig = airutils.canDig,
    _color = "",
	on_destruct = airutils.remove_papi,
	on_rightclick=airutils.togglePapiSide,
    on_punch = function(pos, node, puncher, pointed_thing)
	    local player_name = puncher:get_player_name()
        local meta = core.get_meta(pos)
	    if player_name ~= meta:get_string("owner") then
		    return
	    end

        local itmstck=puncher:get_wielded_item()
        local item_name = ""
        if itmstck then item_name = itmstck:get_name() end

    end,
})


-- PAPI craft
minetest.register_craft({
	output = 'airutils:papi',
	recipe = {
		{'default:glass', 'default:mese_crystal', 'default:glass'},
		{'default:glass', 'default:steel_ingot' , 'default:glass'},
		{''             , 'default:steel_ingot' , ''},
	}
})
