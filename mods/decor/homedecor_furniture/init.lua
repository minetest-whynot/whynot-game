
local S = homedecor.gettext

local table_colors = {
	{ "",           S("Table"),           homedecor.plain_wood },
	{ "_mahogany",  S("Mahogany Table"),  homedecor.mahogany_wood },
	{ "_white",     S("White Table"),     homedecor.white_wood }
}

for _, t in ipairs(table_colors) do
	local suffix, desc, texture = unpack(t)

	homedecor.register("table"..suffix, {
		description = desc,
		tiles = { texture },
		node_box = {
			type = "fixed",
			fixed = {
				{ -0.4, -0.5, -0.4, -0.3,  0.4, -0.3 },
				{  0.3, -0.5, -0.4,  0.4,  0.4, -0.3 },
				{ -0.4, -0.5,  0.3, -0.3,  0.4,  0.4 },
				{  0.3, -0.5,  0.3,  0.4,  0.4,  0.4 },
				{ -0.5,  0.4, -0.5,  0.5,  0.5,  0.5 },
				{ -0.4, -0.2, -0.3, -0.3, -0.1,  0.3 },
				{  0.3, -0.2, -0.4,  0.4, -0.1,  0.3 },
				{ -0.3, -0.2, -0.4,  0.4, -0.1, -0.3 },
				{ -0.3, -0.2,  0.3,  0.3, -0.1,  0.4 },
			},
		},
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		sounds = default.node_sound_wood_defaults(),
	})
end



local ob_cbox = {
	type = "fixed",
	fixed = { -0.5, -0.5, 0, 0.5, 0.5, 0.5 }
}

minetest.register_node(":homedecor:openframe_bookshelf", {
	description = S("Bookshelf (open-frame)"),
	drawtype = "mesh",
	mesh = "homedecor_openframe_bookshelf.obj",
	tiles = {
		"homedecor_openframe_bookshelf_books.png",
		"default_wood.png"
	},
	groups = {choppy=3,oddly_breakable_by_hand=2,flammable=3},
	sounds = default.node_sound_wood_defaults(),
	paramtype = "light",
	paramtype2 = "facedir",
	selection_box = ob_cbox,
	collision_box = ob_cbox,
})

homedecor.register("wall_shelf", {
	description = S("Wall Shelf"),
	tiles = {
		"default_wood.png",
	},
	groups = { snappy = 3 },
	sounds = default.node_sound_wood_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.4, 0.47, 0.5, 0.47, 0.5},
			{-0.5, 0.47, -0.1875, 0.5, 0.5, 0.5}
		}
	}
})

-- Crafts


minetest.register_craft({
	output = "homedecor:table",
	recipe = {
		{ "default:wood","default:wood", "default:wood" },
		{ "group:stick", "", "group:stick" },
	},
})

minetest.register_craft({
	type = "shapeless",
	output = "homedecor:table_mahogany",
	recipe = {
		"homedecor:table",
		"dye:brown",
	},
})

minetest.register_craft({
	type = "shapeless",
	output = "homedecor:table_mahogany",
	recipe = {
		"homedecor:table",
		"unifieddyes:dark_orange",
	},
})

minetest.register_craft({
	type = "shapeless",
	output = "homedecor:table_white",
	recipe = {
		"homedecor:table",
		"dye:white",
	},
})

minetest.register_craft({
	type = "fuel",
	recipe = "homedecor:table",
	burntime = 30,
})

minetest.register_craft({
	type = "fuel",
	recipe = "homedecor:table_mahogany",
	burntime = 30,
})

minetest.register_craft({
	type = "fuel",
	recipe = "homedecor:table_white",
	burntime = 30,
})

minetest.register_craft({
	output = "homedecor:standing_lamp_off",
	recipe = {
		{"homedecor:table_lamp_off"},
		{"group:stick"},
		{"group:stick"},
	},
})

unifieddyes.register_color_craft({
	output = "homedecor:standing_lamp_off",
	palette = "extended",
	type = "shapeless",
	neutral_node = "homedecor:standing_lamp_off",
	recipe = {
		"NEUTRAL_NODE",
		"MAIN_DYE"
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "homedecor:table_lamp_off",
	burntime = 10,
})

minetest.register_craft({
	output = "homedecor:table_lamp_off",
	recipe = {
		{ "wool:white", "default:torch", "wool:white"},
		{ "", "group:stick", ""},
		{ "", "stairs:slab_wood", "" },
	},
})

minetest.register_craft({
	output = "homedecor:table_lamp_off",
	recipe = {
		{ "cottages:wool", "default:torch", "cottages:wool"},
		{ "", "group:stick", ""},
		{ "", "stairs:slab_wood", "" },
	},
})

minetest.register_craft({
	output = "homedecor:table_lamp_off",
	recipe = {
		{ "wool:white", "default:torch", "wool:white"},
		{ "", "group:stick", ""},
		{ "", "moreblocks:slab_wood", "" },
	},
})

minetest.register_craft({
	output = "homedecor:table_lamp_off",
	recipe = {
		{ "cottages:wool", "default:torch", "cottages:wool"},
		{ "", "group:stick", ""},
		{ "", "moreblocks:slab_wood", "" },
	},
})

unifieddyes.register_color_craft({
	output = "homedecor:table_lamp_off",
	palette = "extended",
	type = "shapeless",
	neutral_node = "homedecor:table_lamp_off",
	recipe = {
		"NEUTRAL_NODE",
		"MAIN_DYE"
	}
})

minetest.register_craft({
	output = "homedecor:toilet",
	recipe = {
		{ "","","bucket:bucket_water"},
		{ "group:marble","group:marble", "group:marble" },
		{ "", "bucket:bucket_empty", "" },
	},
})

minetest.register_craft({
	output = "homedecor:sink",
	recipe = {
		{ "group:marble","bucket:bucket_empty", "group:marble" },
		{ "", "group:marble", "" }
	},
})

minetest.register_craft({
	output = "homedecor:taps",
	recipe = {
		{ "default:steel_ingot","bucket:bucket_water", "default:steel_ingot" },
	},
})

minetest.register_craft({
	output = "homedecor:taps_brass",
	recipe = {
		{ "technic:brass_ingot","bucket:bucket_water", "technic:brass_ingot" },
	},
})

minetest.register_craft({
	output = "homedecor:shower_tray",
	recipe = {
		{ "group:marble","bucket:bucket_empty", "group:marble" },
	},
})

minetest.register_craft({
	output = "homedecor:shower_head",
	recipe = {
		{"default:steel_ingot", "bucket:bucket_water"},
	},
})

minetest.register_craft({
	output = "homedecor:bathtub_clawfoot_brass_taps",
	recipe = {
		{ "homedecor:taps_brass", "", "" },
		{ "group:marble", "", "group:marble" },
		{"default:steel_ingot", "group:marble", "default:steel_ingot"},
	},
})

minetest.register_craft({
	output = "homedecor:bathtub_clawfoot_chrome_taps",
	recipe = {
		{ "homedecor:taps", "", "" },
		{ "group:marble", "", "group:marble" },
		{"default:steel_ingot", "group:marble", "default:steel_ingot"},
	},
})

minetest.register_craft({
	output = "homedecor:bars 6",
	recipe = {
		{ "default:steel_ingot","default:steel_ingot","default:steel_ingot" },
		{ "homedecor:pole_wrought_iron","homedecor:pole_wrought_iron","homedecor:pole_wrought_iron" },
	},
})

minetest.register_craft({
	output = "homedecor:L_binding_bars 3",
	recipe = {
		{ "homedecor:bars","" },
		{ "homedecor:bars","homedecor:bars" },
	},
})

minetest.register_craft({
	output = "homedecor:torch_wall 10",
	recipe = {
		{ "default:coal_lump" },
		{ "default:steel_ingot" },
	},
})

-- Aliases for 3dforniture mod.

minetest.register_alias("3dforniture:table", "homedecor:table")
minetest.register_alias('table', 'homedecor:table')
