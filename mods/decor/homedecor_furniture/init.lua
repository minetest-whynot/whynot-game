
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

local kc_cbox = {
	type = "fixed",
	fixed = { -0.3125, -0.3125, -0.5, 0.3125, 0.3125, 0.5 },
}

homedecor.register("kitchen_chair_wood", {
	description = S("Kitchen chair"),
	mesh = "homedecor_kitchen_chair.obj",
	tiles = {
		homedecor.plain_wood,
		homedecor.plain_wood
	},
	inventory_image = "homedecor_chair_wood_inv.png",
	paramtype2 = "wallmounted",
	selection_box = kc_cbox,
	collision_box = kc_cbox,
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
	after_place_node = unifieddyes.fix_rotation_nsew,
	on_rotate = unifieddyes.fix_after_screwdriver_nsew,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		pos.y = pos.y+0 -- where do I put my ass ?
		homedecor.sit(pos, node, clicker)
		return itemstack
	end
})

homedecor.register("kitchen_chair_padded", {
	description = S("Kitchen chair"),
	mesh = "homedecor_kitchen_chair.obj",
	tiles = {
		homedecor.plain_wood,
		"wool_white.png",
	},
	inventory_image = "homedecor_chair_padded_inv.png",
	paramtype2 = "colorwallmounted",
	palette = "unifieddyes_palette_colorwallmounted.png",
	selection_box = kc_cbox,
	collision_box = kc_cbox,
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2, ud_param2_colorable = 1},
	sounds = default.node_sound_wood_defaults(),
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		unifieddyes.fix_rotation_nsew(pos, placer, itemstack, pointed_thing)
	end,
	on_rotate = unifieddyes.fix_after_screwdriver_nsew,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		pos.y = pos.y+0 -- where do I put my ass ?
		homedecor.sit(pos, node, clicker)
		return itemstack
	end
})

local ac_cbox = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5, -0.5, 0.5, 0, 0.5 },
		{-0.5, -0.5, 0.4, 0.5, 0.5, 0.5 }
	}
}

homedecor.register("armchair", {
	description = S("Armchair"),
	mesh = "forniture_armchair.obj",
	tiles = {
		"wool_white.png",
		{ name = "wool_dark_grey.png", color = 0xffffffff },
		{ name = "default_wood.png", color = 0xffffffff }
	},
	inventory_image = "homedecor_armchair_inv.png",
	paramtype2 = "colorwallmounted",
	palette = "unifieddyes_palette_colorwallmounted.png",
	groups = {snappy=3, ud_param2_colorable = 1},
	sounds = default.node_sound_wood_defaults(),
	node_box = ac_cbox,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		unifieddyes.fix_rotation_nsew(pos, placer, itemstack, pointed_thing)
	end,
	on_rotate = unifieddyes.fix_after_screwdriver_nsew,
})

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
	output = "homedecor:kitchen_chair_wood 2",
	recipe = {
		{ "group:stick",""},
		{ "group:wood","group:wood" },
		{ "group:stick","group:stick" },
	},
})

minetest.register_craft({
	output = "homedecor:armchair 2",
	recipe = {
	{ "wool:white",""},
	{ "group:wood","group:wood" },
	{ "wool:white","wool:white" },
	},
})

unifieddyes.register_color_craft({
	output = "homedecor:armchair",
	palette = "wallmounted",
	type = "shapeless",
	neutral_node = "homedecor:armchair",
	recipe = {
		"NEUTRAL_NODE",
		"MAIN_DYE"
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "homedecor:kitchen_chair_padded",
	recipe = {
		"homedecor:kitchen_chair_wood",
		"wool:white",
	},
})

unifieddyes.register_color_craft({
	output = "homedecor:kitchen_chair_padded",
	palette = "wallmounted",
	type = "shapeless",
	neutral_node = "homedecor:kitchen_chair_padded",
	recipe = {
		"NEUTRAL_NODE",
		"MAIN_DYE"
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "homedecor:kitchen_chair_wood",
	burntime = 15,
})

minetest.register_craft({
	type = "fuel",
	recipe = "homedecor:kitchen_chair_padded",
	burntime = 15,
})

minetest.register_craft({
	type = "fuel",
	recipe = "homedecor:armchair",
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
minetest.register_alias("3dforniture:chair", "homedecor:chair")
minetest.register_alias("3dforniture:armchair", "homedecor:armchair_black")
minetest.register_alias("homedecor:armchair", "homedecor:armchair_black")

minetest.register_alias('table', 'homedecor:table')
minetest.register_alias('chair', 'homedecor:chair')
minetest.register_alias('armchair', 'homedecor:armchair')

-- conversion to param2 colorization

homedecor.old_static_chairs = {}

local chair_colors = {
	"black",
	"brown",
	"blue",
	"cyan",
	"dark_grey",
	"dark_green",
	"green",
	"grey",
	"magenta",
	"orange",
	"pink",
	"red",
	"violet",
	"white",
	"yellow",
}

for _, color in ipairs(chair_colors) do
	table.insert(homedecor.old_static_chairs, "homedecor:chair_"..color)
	table.insert(homedecor.old_static_chairs, "homedecor:armchair_"..color)
end
table.insert(homedecor.old_static_chairs, "homedecor:chair")

minetest.register_lbm({
	name = ":homedecor:convert_chairs",
	label = "Convert homedecor chairs to use param2 color",
	run_at_every_load = false,
	nodenames = homedecor.old_static_chairs,
	action = function(pos, node)
		local name = node.name
		local paletteidx = 0
		local color
		local a,b = string.find(name, "_")

		if a then
			color = string.sub(name, a+1)

			if color == "blue" then
				color = "medium_blue"
			elseif color == "violet" then
				color = "medium_violet"
			elseif color == "red" then
				color = "medium_red"
			elseif color == "black" then
				color = "dark_grey"
			end

			paletteidx = unifieddyes.getpaletteidx("unifieddyes:"..color, "wallmounted")
		end

		local old_fdir = math.floor(node.param2 % 32)
		local new_fdir = 3

		if old_fdir == 0 then
			new_fdir = 3
		elseif old_fdir == 1 then
			new_fdir = 4
		elseif old_fdir == 2 then
			new_fdir = 2
		elseif old_fdir == 3 then
			new_fdir = 5
		end

		local param2 = paletteidx + new_fdir
		local newname = "homedecor:armchair"

		if node.name == "homedecor:chair" then
			newname = "homedecor:kitchen_chair_wood"
		elseif string.find(node.name, "homedecor:chair_") then
			newname = "homedecor:kitchen_chair_padded"
		end

		minetest.set_node(pos, { name = newname, param2 = param2 })
		local meta = minetest.get_meta(pos)
		if color then
			meta:set_string("dye", "unifieddyes:"..color)
		end
	end
})
