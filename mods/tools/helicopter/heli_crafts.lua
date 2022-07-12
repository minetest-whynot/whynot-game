--
-- items
--

-- blades
minetest.register_craftitem("nss_helicopter:blades",{
	description = "Helicopter Blades",
	inventory_image = "helicopter_blades_inv.png",
})
-- cabin
minetest.register_craftitem("nss_helicopter:cabin",{
	description = "Cabin for Helicopter",
	inventory_image = "helicopter_cabin_inv.png",
})
-- heli
minetest.register_craftitem("nss_helicopter:heli", {
	description = "Helicopter",
	inventory_image = "helicopter_heli_inv.png",

	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
		if minetest.get_node(pointed_thing.above).name ~= "air" then
			return
		end

		local imeta = itemstack:get_meta()
		local color = imeta:get_string("color")
		if color == "" then color = nil end
		local fuel = math.floor(imeta:get_float("fuel") * 100) / 100

		local obj = minetest.add_entity(pointed_thing.above, "nss_helicopter:heli")
		local ent = obj:get_luaentity()
		local owner = placer:get_player_name()
		ent.owner = owner
		ent.energy = fuel
		helicopter.updateIndicator(ent)
		if color then
			helicopter.paint(ent, color)
		end

		local properties = ent.object:get_properties()
		properties.infotext = owner .. " nice helicopter"
		ent.object:set_properties(properties)

		if not (helicopter.creative and placer and
				creative.is_enabled_for(placer:get_player_name())) then
			itemstack:take_item()
		end
		return itemstack
	end,
})

--
-- crafting
--

if minetest.get_modpath("default") then
	minetest.register_craft({
		output = "nss_helicopter:blades",
		recipe = {
			{"",                    "default:steel_ingot", ""},
			{"default:steel_ingot", "default:diamond",         "default:steel_ingot"},
			{"",                    "default:steel_ingot", ""},
		}
	})
	minetest.register_craft({
		output = "nss_helicopter:cabin",
		recipe = {
			{"default:copperblock", "default:diamondblock", ""},
			{"default:steelblock", "default:mese_block", "default:glass"},
			{"default:steelblock", "xpanes:bar_flat", "xpanes:bar_flat"},
		}
	})
	minetest.register_craft({
		output = "nss_helicopter:heli",
		recipe = {
			{"",                  "nss_helicopter:blades"},
			{"nss_helicopter:blades", "nss_helicopter:cabin"},
		}
	})
end


