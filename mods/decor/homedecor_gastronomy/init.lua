local S = minetest.get_translator("homedecor_gastronomy")

local cutlery_cbox = {
	type = "fixed",
	fixed = {
		{ -5/16, -8/16, -6/16, 5/16, -7/16, 2/16 },
		{ -2/16, -8/16,  2/16, 2/16, -4/16, 6/16 }
	}
}

homedecor.register("cutlery_set", {
	drawtype = "mesh",
	mesh = "homedecor_cutlery_set.obj",
	tiles = { "homedecor_cutlery_set.png"	},
	inventory_image = "homedecor_cutlery_set_inv.png",
	description = S("Cutlery set"),
	groups = {snappy=3},
	selection_box = cutlery_cbox,
	walkable = false,
	sounds = default.node_sound_glass_defaults(),
})

local bottle_cbox = {
	type = "fixed",
	fixed = {
		{ -0.125, -0.5, -0.125, 0.125, 0, 0.125}
	}
}

local fbottle_cbox = {
	type = "fixed",
	fixed = {
		{ -0.375, -0.5, -0.3125, 0.375, 0, 0.3125 }
	}
}

local bottle_colors = {
	{ "brown", S("Brown bottle"), S("Four brown bottles") },
	{ "green", S("Green bottle"), S("Four green bottles") },
}

for _, b in ipairs(bottle_colors) do

	local name, desc, desc4 = unpack(b)

	homedecor.register("bottle_"..name, {
		tiles = { "homedecor_bottle_"..name..".png" },
		inventory_image = "homedecor_bottle_"..name.."_inv.png",
		description = desc,
		mesh = "homedecor_bottle.obj",
		walkable = false,
		groups = {snappy=3},
		sounds = default.node_sound_glass_defaults(),
		selection_box = bottle_cbox
	})

	-- 4-bottle sets

	homedecor.register("4_bottles_"..name, {
		tiles = {
			"homedecor_bottle_"..name..".png",
			"homedecor_bottle_"..name..".png"
		},
		inventory_image = "homedecor_4_bottles_"..name.."_inv.png",
		description = desc4,
		mesh = "homedecor_4_bottles.obj",
		walkable = false,
		groups = {snappy=3},
		sounds = default.node_sound_glass_defaults(),
		selection_box = fbottle_cbox
	})
end

homedecor.register("4_bottles_multi", {
	tiles = {
		"homedecor_bottle_brown.png",
		"homedecor_bottle_green.png"
	},
	inventory_image = "homedecor_4_bottles_multi_inv.png",
	description = S("Four misc brown/green bottles"),
	mesh = "homedecor_4_bottles.obj",
	groups = {snappy=3},
	walkable = false,
	sounds = default.node_sound_glass_defaults(),
	selection_box = fbottle_cbox
})

local wine_cbox = homedecor.nodebox.slab_z(-0.75)
homedecor.register("wine_rack", {
	description = S("Wine rack"),
	mesh = "homedecor_wine_rack.obj",
	tiles = {
		"homedecor_generic_wood_red.png",
		"homedecor_bottle_brown.png",
		"homedecor_bottle_brown2.png",
		"homedecor_bottle_brown3.png",
		"homedecor_bottle_brown4.png"
	},
	inventory_image = "homedecor_wine_rack_inv.png",
	groups = {choppy=2},
	selection_box = wine_cbox,
	collision_box = wine_cbox,
	sounds = default.node_sound_defaults(),
})

-- coffee!
-- coffee!
-- coffee!

local cm_cbox = {
	type = "fixed",
	fixed = {
		{     0, -8/16,     0,  7/16,  3/16,  8/16 },
		{ -4/16, -8/16, -6/16, -1/16, -5/16, -3/16 }
	}
}

homedecor.register("coffee_maker", {
	mesh = "homedecor_coffeemaker.obj",
	tiles = {
		"homedecor_coffeemaker_decanter.png",
		"homedecor_coffeemaker_cup.png",
		"homedecor_coffeemaker_case.png",
	},
	description = S("Coffee Maker"),
	inventory_image = "homedecor_coffeemaker_inv.png",
	walkable = false,
	groups = {snappy=3},
	selection_box = cm_cbox,
	node_box = cm_cbox,
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil,
})

homedecor.register("toaster", {
	description = S("Toaster"),
	tiles = { "homedecor_toaster_sides.png" },
	inventory_image = "homedecor_toaster_inv.png",
	walkable = false,
	groups = { snappy=3 },
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.125, 0.125, -0.3125, 0.125}, -- NodeBox1
		},
	},
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		local fdir = node.param2
		minetest.set_node(pos, { name = "homedecor:toaster_loaf", param2 = fdir })
		minetest.sound_play("toaster", {
			pos = pos,
			gain = 1.0,
			max_hear_distance = 5
		})
		return itemstack
	end
})

homedecor.register("toaster_loaf", {
	tiles = {
		"homedecor_toaster_toploaf.png",
		"homedecor_toaster_sides.png",
		"homedecor_toaster_sides.png",
		"homedecor_toaster_sides.png",
		"homedecor_toaster_sides.png",
		"homedecor_toaster_sides.png"
	},
	walkable = false,
	groups = { snappy=3, not_in_creative_inventory=1 },
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.125, 0.125, -0.3125, 0.125}, -- NodeBox1
			{-0.03125, -0.3125, -0.0935, 0, -0.25, 0.0935}, -- NodeBox2
			{0.0625, -0.3125, -0.0935, 0.0935, -0.25, 0.0935}, -- NodeBox3
		},
	},
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		local fdir = node.param2
		minetest.set_node(pos, { name = "homedecor:toaster", param2 = fdir })
		return itemstack
	end,
	drop = "homedecor:toaster"
})

local fdir_to_steampos = {
	x = { 0.15,   0.275, -0.15,  -0.275 },
	z = { 0.275, -0.15,  -0.275,  0.15  }
}

minetest.register_abm({
	nodenames = "homedecor:coffee_maker",
	label = "sfx",
	interval = 2,
	chance = 1,
	action = function(pos, node)
		local fdir = node.param2
		if fdir and fdir < 4 then

			local steamx = fdir_to_steampos.x[fdir + 1]
			local steamz = fdir_to_steampos.z[fdir + 1]

			minetest.add_particlespawner({
				amount = 1,
				time = 1,
				minpos = {x=pos.x - steamx, y=pos.y - 0.35, z=pos.z - steamz},
				maxpos = {x=pos.x - steamx, y=pos.y - 0.35, z=pos.z - steamz},
				minvel = {x=-0.003, y=0.01, z=-0.003},
				maxvel = {x=0.003, y=0.01, z=-0.003},
				minacc = {x=0.0,y=-0.0,z=-0.0},
				maxacc = {x=0.0,y=0.003,z=-0.0},
				minexptime = 2,
				maxexptime = 5,
				minsize = 1,
				maxsize = 1.2,
				collisiondetection = false,
				texture = "homedecor_steam.png",
			})
		end
	end
})

-- crafting

minetest.register_craft( {
        output = "homedecor:bottle_green",
        recipe = {
			{ "vessels:glass_bottle", "dye:green" }
        },
})

minetest.register_craft( {
        output = "homedecor:bottle_brown",
        recipe = {
			{ "vessels:glass_bottle", "dye:brown" }
        },
})

minetest.register_craft({
	output = "homedecor:coffee_maker",
	recipe = {
	    {"basic_materials:plastic_sheet", "bucket:bucket_water", "basic_materials:plastic_sheet"},
	    {"basic_materials:plastic_sheet", "default:glass", "basic_materials:plastic_sheet"},
	    {"basic_materials:plastic_sheet", "basic_materials:heating_element", "basic_materials:plastic_sheet"}
	},
})

minetest.register_craft({
	output = "homedecor:toaster",
	recipe = {
		{ "default:steel_ingot", "basic_materials:heating_element", "default:steel_ingot" },
		{ "default:steel_ingot", "basic_materials:heating_element", "default:steel_ingot" }
	},
})


minetest.register_craft({
	type = "shapeless",
	output = "homedecor:4_bottles_brown",
	recipe = {
		"homedecor:bottle_brown",
		"homedecor:bottle_brown",
		"homedecor:bottle_brown",
		"homedecor:bottle_brown"
	},
})

minetest.register_craft({
	type = "shapeless",
	output = "homedecor:4_bottles_green",
	recipe = {
		"homedecor:bottle_green",
		"homedecor:bottle_green",
		"homedecor:bottle_green",
		"homedecor:bottle_green"
	},
})

minetest.register_craft({
	type = "shapeless",
	output = "homedecor:4_bottles_multi",
	recipe = {
		"homedecor:bottle_brown",
		"homedecor:bottle_brown",
		"homedecor:bottle_green",
		"homedecor:bottle_green",
	},
})

minetest.register_craft({
	output = "homedecor:wine_rack",
	recipe = {
		{ "homedecor:4_bottles_brown", "group:wood", "homedecor:4_bottles_brown" },
		{ "homedecor:4_bottles_brown", "group:wood", "homedecor:4_bottles_brown" },
		{ "homedecor:4_bottles_brown", "group:wood", "homedecor:4_bottles_brown" },
	},
})

