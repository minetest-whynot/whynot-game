
if not minetest.settings:get_bool('supercub.disable_craftitems') then
    -- wing
    minetest.register_craftitem("supercub:wings",{
	    description = "Supercub wings",
	    inventory_image = "supercub_wings.png",
    })
-- fuselage
    minetest.register_craftitem("supercub:fuselage",{
	    description = "Supercub fuselage",
	    inventory_image = "supercub_fuselage.png",
    })
end

-- pa28
minetest.register_craftitem("supercub:supercub", {
	description = "Supercub",
	inventory_image = "supercub.png",
    liquids_pointable = true,

	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
        
        local pointed_pos = pointed_thing.under
        --local node_below = minetest.get_node(pointed_pos).name
        --local nodedef = minetest.registered_nodes[node_below]
        
		pointed_pos.y=pointed_pos.y+2
		local sc_ent = minetest.add_entity(pointed_pos, "supercub:supercub")
		if sc_ent and placer then
            local ent = sc_ent:get_luaentity()
            if ent then
                local owner = placer:get_player_name()
                ent.owner = owner
			    sc_ent:set_yaw(placer:get_look_horizontal())
			    itemstack:take_item()
                airutils.create_inventory(ent, ent._trunk_slots, owner)
            end
		end

		return itemstack
	end,
})

--
-- crafting
--

if not minetest.settings:get_bool('supercub.disable_craftitems') and minetest.get_modpath("default") then
    minetest.register_craft({
	    output = "supercub:wings",
	    recipe = {
		    {"wool:white", "farming:string", "wool:white"},
		    {"group:wood", "group:wood", "group:wood"},
		    {"wool:white", "default:steel_ingot", "wool:white"},
	    }
    })
    minetest.register_craft({
	    output = "supercub:fuselage",
	    recipe = {
		    {"default:steel_ingot", "default:diamondblock", "default:steel_ingot"},
		    {"wool:white", "default:steel_ingot",  "wool:white"},
		    {"default:steel_ingot", "default:mese_block",   "default:steel_ingot"},
	    }
    })
	minetest.register_craft({
		output = "supercub:supercub",
		recipe = {
			{"supercub:wings",},
			{"supercub:fuselage",},
		}
	})
end

