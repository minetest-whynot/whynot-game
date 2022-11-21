-- wing
minetest.register_craftitem("hidroplane:wings",{
	description = "Hidroplane wings",
	inventory_image = "wings.png",
})
-- fuselage
minetest.register_craftitem("hidroplane:fuselage",{
	description = "Hidroplane fuselage",
	inventory_image = "fuselage.png",
})
-- floaters
minetest.register_craftitem("hidroplane:floaters",{
	description = "Hidroplane floaters",
	inventory_image = "floaters.png",
})

-- trike
minetest.register_craftitem("hidroplane:hidro", {
	description = "Hidroplane - Super Duck",
	inventory_image = "hidro.png",
    liquids_pointable = true,

	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
        
        local pointed_pos = pointed_thing.under
        --local node_below = minetest.get_node(pointed_pos).name
        --local nodedef = minetest.registered_nodes[node_below]
        
		pointed_pos.y=pointed_pos.y+3
		local hidro = minetest.add_entity(pointed_pos, "hidroplane:hidro")
		if hidro and placer then
            local ent = hidro:get_luaentity()
            local owner = placer:get_player_name()
            ent.owner = owner
			hidro:set_yaw(placer:get_look_horizontal())
			itemstack:take_item()
            airutils.create_inventory(ent, hidroplane.trunk_slots, owner)
		end

		return itemstack
	end,
})

-- repair tool
--[[if not minetest.registered_items["trike:repair_tool"] then
    minetest.register_craftitem("hidroplane:repair_tool",{
	    description = "Hidroplane repair tool",
	    inventory_image = "repair_tool.png",
    })
end]]--

--
-- crafting
--

if minetest.get_modpath("default") then
	minetest.register_craft({
		output = "hidroplane:wings",
		recipe = {
			{"wool:white", "farming:string", "wool:white"},
			{"group:wood", "group:wood", "group:wood"},
			{"wool:white", "default:steel_ingot", "wool:white"},
		}
	})
	minetest.register_craft({
		output = "hidroplane:fuselage",
		recipe = {
			{"default:steel_ingot", "default:diamondblock", "default:steel_ingot"},
			{"wool:white", "default:steel_ingot",  "wool:white"},
			{"default:steel_ingot", "default:mese_block",   "default:steel_ingot"},
		}
	})
	minetest.register_craft({
		output = "hidroplane:floaters",
		recipe = {
			{"default:tin_ingot", "default:steel_ingot", "default:tin_ingot"},
			{"group:wood", "",  "group:wood"},
			{"default:tin_ingot", "default:tin_ingot", "default:tin_ingot"},
		}
	})
	minetest.register_craft({
		output = "hidroplane:hidro",
		recipe = {
			{"hidroplane:wings",},
			{"hidroplane:fuselage",},
            {"hidroplane:floaters",},
		}
	})
end
