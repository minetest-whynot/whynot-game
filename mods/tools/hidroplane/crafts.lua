
if not minetest.settings:get_bool('supercub.disable_craftitems') then
    minetest.register_craftitem("hidroplane:floaters",{
	    description = "Hidroplane floaters",
	    inventory_image = "floaters.png",
    })
end

-- pa28
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
		local sc_ent = minetest.add_entity(pointed_pos, "hidroplane:hidro")
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

if not minetest.settings:get_bool('hidroplane.disable_craftitems') and minetest.get_modpath("default") then
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
			{"supercub:supercub",},
			{"hidroplane:floaters",},
		}
	})
end

