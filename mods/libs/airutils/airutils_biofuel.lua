----------
--biofuel
----------
local S = airutils.S
local module_name = "airutils"

if core.get_modpath("technic") then
    if technic then
	    technic.register_extractor_recipe({input = {"farming:wheat 33"}, output = "biofuel:biofuel 1"})
	    technic.register_extractor_recipe({input = {"farming:corn 33"}, output = "biofuel:biofuel 1"})
	    technic.register_extractor_recipe({input = {"farming:potato 33"}, output = "biofuel:biofuel 1"})
	    technic.register_extractor_recipe({input = {"default:papyrus 99"}, output = "biofuel:biofuel 1"})
    end
end


if core.get_modpath("basic_machines") then
    if basic_machines then
	    basic_machines.grinder_recipes["farming:wheat"] = {50,"biofuel:biofuel",1}
	    basic_machines.grinder_recipes["farming:corn"] = {50,"biofuel:biofuel",1}
	    basic_machines.grinder_recipes["farming:potato"] = {50,"biofuel:biofuel",1}
	    basic_machines.grinder_recipes["default:papyrus"] = {70,"biofuel:biofuel",1}
    end
end

if core.get_modpath("default") then
	core.register_craft({
		output = module_name .. ":biofuel_distiller",
		recipe = {
			{"default:copper_ingot", "default:copper_ingot", "default:copper_ingot"},
			{"default:steel_ingot" , "",                     "default:steel_ingot"},
			{"default:steel_ingot" , "default:steel_ingot",  "default:steel_ingot"},
		},
	})
end
if core.get_modpath("mcl_core") then
	core.register_craft({
		output = module_name .. ":biofuel_distiller",
		recipe = {
			{"mcl_copper:copper_ingot", "mcl_copper:copper_ingot", "mcl_copper:copper_ingot"},
			{"mcl_core:iron_ingot" , "",                     "mcl_core:iron_ingot"},
			{"mcl_core:iron_ingot" , "mcl_core:iron_ingot",  "mcl_core:iron_ingot"},
		},
	})
end


-- biofuel
local new_gallon_id = "airutils:biofuel"
core.register_craftitem(new_gallon_id,{
	description = S("Bio Fuel"),
	inventory_image = "airutils_biofuel_inv.png",
})

core.register_craft({
	type = "fuel",
	recipe = new_gallon_id,
	burntime = 50,
})

core.register_alias("biofuel:biofuel", new_gallon_id) --for the old biofuel

local ferment = {
	{"default:papyrus", new_gallon_id},
	{"farming:wheat", new_gallon_id},
	{"farming:corn", new_gallon_id},
	{"farming:baked_potato", new_gallon_id},
    {"farming:potato", new_gallon_id}
}

local ferment_groups = {'flora', 'leaves', 'flower', 'sapling', 'tree', 'wood', 'stick', 'plant', 'seed',
 'leafdecay', 'leafdecay_drop', 'mushroom', 'vines' }

-- distiller
local biofueldistiller_formspec = "size[8,9]"
	.. "list[current_name;src;2,1;1,1;]" .. airutils.get_itemslot_bg(2, 1, 1, 1)
	.. "list[current_name;dst;5,1;1,1;]" .. airutils.get_itemslot_bg(5, 1, 1, 1)
	.. "list[current_player;main;0,5;8,4;]" .. airutils.get_itemslot_bg(0, 5, 8, 4)
	.. "listring[current_name;dst]"
	.. "listring[current_player;main]"
	.. "listring[current_name;src]"
	.. "listring[current_player;main]"
	.. "image[3.5,1;1,1;gui_furnace_arrow_bg.png^[transformR270]"

core.register_node( module_name .. ":biofuel_distiller", {
	description = S("Biofuel Distiller"),
	tiles = {"airutils_black.png", "airutils_aluminum.png", "airutils_copper.png" },
	drawtype = "mesh",
	mesh = "airutils_biofuel_distiller.b3d",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {
		choppy = 2, oddly_breakable_by_hand = 1, flammable = 2
	},
	legacy_facedir_simple = true,

	on_place = core.rotate_node,

	on_construct = function(pos)

		local meta = core.get_meta(pos)

		meta:set_string("formspec", biofueldistiller_formspec)
		meta:set_string("infotext", S("Biofuel Distiller"))
		meta:set_float("status", 0.0)

		local inv = meta:get_inventory()

		inv:set_size("src", 1)
		inv:set_size("dst", 1)
	end,

	can_dig = function(pos,player)

		local meta = core.get_meta(pos)
		local inv = meta:get_inventory()

		if not inv:is_empty("dst")
		or not inv:is_empty("src") then
			return false
		end

		return true
	end,

	allow_metadata_inventory_take = function(pos, listname, index, stack, player)

		if core.is_protected(pos, player:get_player_name()) then
			return 0
		end

		return stack:get_count()
	end,

	allow_metadata_inventory_put = function(pos, listname, index, stack, player)

		if core.is_protected(pos, player:get_player_name()) then
			return 0
		end

		if listname == "src" then
			return stack:get_count()
		elseif listname == "dst" then
			return 0
		end
	end,

	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)

		if core.is_protected(pos, player:get_player_name()) then
			return 0
		end

		if to_list == "src" then
			return count
		elseif to_list == "dst" then
			return 0
		end
	end,

	on_metadata_inventory_put = function(pos)

		local timer = core.get_node_timer(pos)

		timer:start(5)
	end,

	on_timer = function(pos)

		local meta = core.get_meta(pos) ; if not meta then return end
		local inv = meta:get_inventory()

		-- is barrel empty?
		if not inv or inv:is_empty("src") then

			meta:set_float("status", 0.0)
			meta:set_string("infotext", S("Fuel Distiller"))

			return false
		end

		-- does it contain any of the source items on the list?
		local has_item

        --normal items
		for n = 1, #ferment do
			if inv:contains_item("src", ItemStack(ferment[n][1])) then
				has_item = n
				break
			end
		end

        --groups
        local has_group
        if not has_item then
            local inv_content = inv:get_list("src")
            if inv_content then
                for k, v in pairs(inv_content) do
                    local item_name = v:get_name()
                    for n = 1, #ferment_groups do
                        if core.get_item_group(item_name, ferment_groups[n]) == 1 then
				            has_group = n
				            break
                        end
                    end
                end
            end
        end

		if not has_item and not has_group then
			return false
		end

		-- is there room for additional fermentation?
		if has_item and not inv:room_for_item("dst", ferment[has_item][2]) then
			meta:set_string("infotext", S("Fuel Distiller (FULL)"))
			return true
		end

		if has_group and not inv:room_for_item("dst", new_gallon_id) then
			meta:set_string("infotext", S("Fuel Distiller (FULL)"))
			return true
		end

		local status = meta:get_float("status")

		-- fermenting (change status)
		if status < 100 then
			meta:set_string("infotext", S("Fuel Distiller @1% done", status))
			meta:set_float("status", status + 5)
		else
            if not has_group then
			    inv:remove_item("src", ferment[has_item][1])
			    inv:add_item("dst", ferment[has_item][2])
            else
                for i,itemstack in pairs(inv:get_list("src")) do
			        inv:remove_item("src", ItemStack(itemstack:get_name().." 1"))
                end
			    inv:add_item("dst", new_gallon_id)
            end

			meta:set_float("status", 0,0)
		end

		if inv:is_empty("src") then
			meta:set_float("status", 0.0)
			meta:set_string("infotext", S("Fuel Distiller"))
		end

		return true
	end,
})

--lets remove the old one
core.register_node(":".."biofuel:biofuel_distiller", {
    groups = {old_biofuel=1},
})

core.register_abm({
    nodenames = {"group:old_biofuel"},
    interval = 1,
    chance = 1,
    action = function(pos, node)
        --core.remove_node(pos)
        core.swap_node(pos,{name = module_name..":biofuel_distiller"})
    end,
})
