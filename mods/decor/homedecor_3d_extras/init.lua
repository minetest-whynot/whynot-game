if minetest.get_modpath("default") then
	minetest.override_item("default:bookshelf", {
		drawtype = "mesh",
		mesh = "homedecor_3d_bookshelf.obj",
		tiles = {
			"default_wood.png",
			"default_wood.png^homedecor_3d_bookshelf_inside_back.png",
			"homedecor_3d_bookshelf_books.png",
		},
		paramtype = "light",
		paramtype2 = "facedir",
	})
end

if minetest.get_modpath("vessels") then
	minetest.override_item("vessels:shelf", {
		drawtype = "mesh",
		mesh = "homedecor_3d_vessels_shelf.obj",
		tiles = {
			"default_wood.png",
			"default_wood.png^homedecor_3d_bookshelf_inside_back.png",
			"homedecor_3d_vessels_shelf_glass.png",
		},
		paramtype = "light",
		paramtype2 = "facedir",
		use_texture_alpha = "blend",
	})

	local sbox = {
		type = "fixed",
		fixed = { -0.15, -0.5, -0.15, 0.15, -0.1, 0.15 }
	}

	minetest.override_item("vessels:glass_bottle", {
		drawtype = "mesh",
		mesh = "homedecor_3d_vessels_bottle.obj",
		tiles = {"homedecor_3d_vessels_shelf_glass.png"},
		inventory_image = "homedecor_3d_vessels_glass_bottle_inv.png",
		wield_image = "homedecor_3d_vessels_glass_bottle_inv.png",
		use_texture_alpha = "blend",
		selection_box = sbox
	})

	minetest.override_item("vessels:steel_bottle", {
		drawtype = "mesh",
		mesh = "homedecor_3d_vessels_bottle_steel.obj",
		tiles = {"homedecor_3d_bottle_metal_bright.png"},
		inventory_image = "homedecor_3d_vessels_steel_bottle_inv.png",
		wield_image = "homedecor_3d_vessels_steel_bottle_inv.png",
		selection_box = sbox
	})

	minetest.override_item("vessels:drinking_glass", {
		drawtype = "mesh",
		mesh = "homedecor_3d_vessels_drink.obj",
		tiles = {"homedecor_3d_vessels_shelf_glass.png"},
		inventory_image = "homedecor_3d_vessels_drinking_glass_inv.png",
		wield_image = "homedecor_3d_vessels_drinking_glass_inv.png",
		use_texture_alpha = "blend",
		selection_box = sbox
	})
end

if minetest.get_modpath("moreblocks") then
	minetest.override_item("moreblocks:empty_bookshelf", {
		drawtype = "nodebox",
		tiles = {
			"default_wood.png^[transformR180",
			"default_wood.png",
			"default_wood.png^[transformR90",
			"default_wood.png^[transformR270",
			"default_wood.png^homedecor_3d_bookshelf_inside_back.png",
			"default_wood.png^homedecor_3d_bookshelf_inside_back.png"
		},
		paramtype = "light",
		paramtype2 = "facedir",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.1875, 0.5, 0.5, 0.1875},
				{-0.5, -0.5, -0.5, -0.4375, 0.5, 0.5},
				{0.4375, -0.5, -0.5, 0.5, 0.5, 0.5},
				{-0.5, 0.4375, -0.5, 0.5, 0.5, 0.5},
				{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
				{-0.5, -0.0625, -0.5, 0.5, 0.0625, 0.5},
			}
		}
	})
end

-- 3d-ify default mtg wood and steel doors and trap doors

if minetest.get_modpath("doors") then
	local def
	for _,mat in ipairs({"wood", "steel"}) do
		def = table.copy(minetest.registered_nodes["doors:door_"..mat.."_a"])
			def.mesh = "homedecor_3d_door_"..mat.."_a.obj"
			minetest.register_node(":doors:door_"..mat.."_a", def)

		def = table.copy(minetest.registered_nodes["doors:door_"..mat.."_b"])
			def.mesh = "homedecor_3d_door_"..mat.."_b.obj"
			minetest.register_node(":doors:door_"..mat.."_b", def)
	end

	for _,mat in ipairs({"", "_steel"}) do
		def = table.copy(minetest.registered_nodes["doors:trapdoor"..mat])
			def.drawtype = "mesh"
			def.mesh = "homedecor_3d_trapdoor"..mat..".obj"
			def.tiles = {
				"doors_trapdoor"..mat..".png",
				"doors_trapdoor"..mat.."_side.png"
			}
			minetest.register_node(":doors:trapdoor"..mat, def)

		def = table.copy(minetest.registered_nodes["doors:trapdoor"..mat.."_open"])
			def.mesh = "homedecor_3d_trapdoor"..mat.."_open.obj"
			def.drawtype = "mesh"
			def.tiles = {
				"doors_trapdoor"..mat..".png",
				"doors_trapdoor"..mat.."_side.png"
			}
			minetest.register_node(":doors:trapdoor"..mat.."_open", def)
	end

end
