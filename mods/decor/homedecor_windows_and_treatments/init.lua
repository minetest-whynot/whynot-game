local S = minetest.get_translator("homedecor_windows_and_treatments")

homedecor_windows_and_treatments = {}

homedecor.register("window_quartered", {
	description = S("Window (quartered)"),
	tiles = {
		"homedecor_window_sides.png",
		"homedecor_window_sides.png",
		"homedecor_window_sides.png",
		"homedecor_window_sides.png",
		"homedecor_window_quartered.png",
		"homedecor_window_quartered.png"
	},
	use_texture_alpha = true,
	groups = {snappy=3},
	sounds = default.node_sound_glass_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.025, 0.5, 0.5, 0}, -- NodeBox1
			{-0.5, 0.4375, -0.0625, 0.5, 0.5, 0.0625}, -- NodeBox2
			{-0.5, -0.5, -0.0625, 0.5, -0.4375, 0.0625}, -- NodeBox3
			{-0.5, -0.0625, -0.025, 0.5, 0.0625, 0.025}, -- NodeBox4
			{0.4375, -0.5, -0.0625, 0.5, 0.5, 0.0625}, -- NodeBox5
			{-0.5, -0.5, -0.0625, -0.4375, 0.5, 0.0625}, -- NodeBox6
			{-0.0625, -0.5, -0.025, 0.0625, 0.5, 0.025}, -- NodeBox7
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.0625, 0.5, 0.5, 0.0625}
	}
})

homedecor.register("window_plain", {
	description = S("Window (plain)"),
	tiles = {
		"homedecor_window_sides.png",
		"homedecor_window_sides.png",
		"homedecor_window_sides.png",
		"homedecor_window_sides.png",
		"homedecor_window_frame.png",
		"homedecor_window_frame.png"
	},
	use_texture_alpha = true,
	groups = {snappy=3},
	sounds = default.node_sound_glass_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.025, 0.5, 0.5, 0}, -- NodeBox1
			{-0.5, 0.4375, -0.0625, 0.5, 0.5, 0.0625}, -- NodeBox2
			{-0.5, -0.5, -0.0625, 0.5, -0.4375, 0.0625}, -- NodeBox3
			{0.4375, -0.5, -0.0625, 0.5, 0.5, 0.0625}, -- NodeBox4
			{-0.5, -0.5, -0.0625, -0.4375, 0.5, 0.0625}, -- NodeBox5
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.0625, 0.5, 0.5, 0.0625}
	}
})

local wb1_cbox = {
	type = "fixed",
	fixed = { -8/16, -8/16, 5/16, 8/16, 8/16, 8/16 },
}

homedecor.register("blinds_thick", {
	description = S("Window Blinds (thick)"),
	mesh = "homedecor_windowblind_thick.obj",
	inventory_image = "homedecor_windowblind_thick_inv.png",
	tiles = {
		"homedecor_windowblind_strings.png",
		"homedecor_windowblinds.png"
	},
	walkable = false,
	groups = {snappy=3},
	sounds = default.node_sound_wood_defaults(),
	selection_box = wb1_cbox
})

local wb2_cbox = {
	type = "fixed",
	fixed = { -8/16, -8/16, 6/16, 8/16, 8/16, 8/16 },
}

homedecor.register("blinds_thin", {
	description = S("Window Blinds (thin)"),
	mesh = "homedecor_windowblind_thin.obj",
	inventory_image = "homedecor_windowblind_thin_inv.png",
	tiles = {
		"homedecor_windowblind_strings.png",
		"homedecor_windowblinds.png"
	},
	walkable = false,
	groups = {snappy=3},
	sounds = default.node_sound_wood_defaults(),
	selection_box = wb2_cbox
})

minetest.register_node(":homedecor:curtain_closed", {
	description = S("Curtains"),
	tiles = { "homedecor_curtain.png" },
	inventory_image = "homedecor_curtain.png",
	drawtype = 'signlike',
	use_texture_alpha = true,
	walkable = false,
	groups = { snappy = 3, ud_param2_colorable = 1, not_in_creative_inventory=1 },
	sounds = default.node_sound_leaves_defaults(),
	paramtype = "light",
	paramtype2 = "colorwallmounted",
	palette = "unifieddyes_palette_colorwallmounted.png",
	selection_box = { type = "wallmounted" },
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		unifieddyes.fix_rotation(pos, placer, itemstack, pointed_thing)
	end,
	on_dig = unifieddyes.on_dig,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		minetest.set_node(pos, { name = "homedecor:curtain_open", param2 = node.param2 })
		return itemstack
	end
})

minetest.register_node(":homedecor:curtain_open", {
	description = S("Curtains (open)"),
	tiles = { "homedecor_curtain_open.png" },
	inventory_image = "homedecor_curtain_open.png",
	drawtype = 'signlike',
	use_texture_alpha = true,
	walkable = false,
	groups = { snappy = 3, ud_param2_colorable = 1 },
	sounds = default.node_sound_leaves_defaults(),
	paramtype = "light",
	paramtype2 = "colorwallmounted",
	palette = "unifieddyes_palette_colorwallmounted.png",
	selection_box = { type = "wallmounted" },
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		unifieddyes.fix_rotation(pos, placer, itemstack, pointed_thing)
	end,
	on_dig = unifieddyes.on_dig,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		minetest.set_node(pos, { name = "homedecor:curtain_closed", param2 = node.param2 })
		return itemstack
	end
})

local mats = {
	{ "brass", S("brass"), "homedecor_generic_metal_brass.png" },
	{ "wrought_iron", S("wrought iron"), "homedecor_generic_metal_wrought_iron.png" },
	{ "wood", S("wood"), "default_wood.png" }
}

for _, m in ipairs(mats) do
	local material, mat_name, texture = unpack(m)
	homedecor.register("curtainrod_"..material, {
		tiles = { texture },
		inventory_image  = "homedecor_curtainrod_"..material.."_inv.png",
		description = S("Curtain Rod (@1)", mat_name),
		groups = { snappy = 3 },
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, 0.375, 0.5, -0.4375, 0.4375},
				{-0.4375, -0.5, 0.4375, -0.375, -0.4375, 0.5},
				{0.375, -0.5, 0.4375, 0.4375, -0.4375, 0.5}
			}
		}
	})
end

homedecor.register("window_flowerbox", {
	description = S("Window flowerbox"),
	tiles = {
		"homedecor_flowerbox_top.png",
		"homedecor_flowerbox_bottom.png",
		"homedecor_flowerbox_sides.png"
	},
	inventory_image = "homedecor_flowerbox_inv.png",
	sounds = default.node_sound_stone_defaults(),
	groups = { snappy = 3 },
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, 0.25, -0.125, 0.375, 0.5, 0.375}, -- NodeBox1
			{-0.3125, 0.4375, 0.375, -0.25, 0.4875, 0.5}, -- NodeBox2
			{0.25, 0.4375, 0.375, 0.3125, 0.4875, 0.5}, -- NodeBox3
		}
	}
})

homedecor.register("stained_glass", {
	description = S("Stained Glass"),
	tiles = {"homedecor_stained_glass.png"},
	inventory_image = "homedecor_stained_glass.png",
	groups = {snappy=3},
	use_texture_alpha = true,
	light_source = 3,
	sounds = default.node_sound_glass_defaults(),
	node_box = {
		type = "fixed",
		fixed = { {-0.5, -0.5, 0.46875, 0.5, 0.5, 0.5} }
	}
})

-- Various kinds of window shutters

local shutters = {
	"mahogany",
	"red",
	"yellow",
	"forest_green",
	"light_blue",
	"violet",
	"black",
	"dark_grey",
	"grey",
	"white",
}

local shutter_cbox = {
	type = "wallmounted",
	wall_top =		{ -0.5,  0.4375, -0.5,  0.5,     0.5,    0.5 },
	wall_bottom =	{ -0.5, -0.5,    -0.5,  0.5,    -0.4375, 0.5 },
	wall_side =		{ -0.5, -0.5,    -0.5, -0.4375,  0.5,    0.5 }
}

local inv = "homedecor_window_shutter_inv.png^[colorize:#a87034:150"

homedecor.register("shutter", {
	mesh = "homedecor_window_shutter.obj",
	tiles = {
		{ name = "homedecor_window_shutter.png", color = 0xffa87034 }
	},
	description = S("Wooden Shutter"),
	inventory_image = inv,
	wield_image = inv,
	paramtype2 = "colorwallmounted",
	palette = "unifieddyes_palette_colorwallmounted.png",
	airbrush_replacement_node = "homedecor:shutter_colored",
	groups = { snappy = 3, ud_param2_colorable = 1 },
	sounds = default.node_sound_wood_defaults(),
	selection_box = shutter_cbox,
	node_box = shutter_cbox,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		unifieddyes.fix_rotation(pos, placer, itemstack, pointed_thing)
	end,
	on_dig = unifieddyes.on_dig,
})

homedecor.register("shutter_colored", {
	mesh = "homedecor_window_shutter.obj",
	tiles = { "homedecor_window_shutter.png" },
	description = S("Wooden Shutter"),
	inventory_image = "homedecor_window_shutter_inv.png",
	wield_image = "homedecor_window_shutter_inv.png",
	paramtype2 = "colorwallmounted",
	palette = "unifieddyes_palette_colorwallmounted.png",
	groups = { snappy = 3 , not_in_creative_inventory = 1, ud_param2_colorable = 1},
	sounds = default.node_sound_wood_defaults(),
	selection_box = shutter_cbox,
	node_box = shutter_cbox,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		unifieddyes.fix_rotation(pos, placer, itemstack, pointed_thing)
	end,
	on_dig = unifieddyes.on_dig,
})

minetest.register_alias("homedecor:shutter_purple", "homedecor:shutter_violet")
minetest.register_alias("homedecor:shutter_oak", "homedecor:shutter")

-- convert old shutters to param2 coloring

homedecor_windows_and_treatments.old_shutter_nodes = {}

for _, color in ipairs(shutters) do
	table.insert(homedecor_windows_and_treatments.old_shutter_nodes, "homedecor:shutter_"..color)
end

minetest.register_lbm({
	name = ":homedecor:convert_shutters",
	label = "Convert shutter static nodes to use param2 color",
	run_at_every_load = false,
	nodenames = homedecor_windows_and_treatments.old_shutter_nodes,
	action = function(pos, node)
		local name = node.name
		local color = string.sub(name, string.find(name, "_") + 1)

		if color == "mahogany" then
			color = "dark_red"
		elseif color == "forest_green" then
			color = "dark_green"
		elseif color == "light_blue" then
			color = "medium_cyan"
		elseif color == "red" then
			color = "medium_red"
		end

		local paletteidx = unifieddyes.getpaletteidx("unifieddyes:"..color, "wallmounted")
		local param2 = paletteidx + node.param2

		minetest.set_node(pos, { name = "homedecor:shutter_colored", param2 = param2 })
		local meta = minetest.get_meta(pos)
		meta:set_string("dye", "unifieddyes:"..color)
	end
})

-- Convert old curtain nodes to param2-colorization

local curtaincolors = {
	"red",
	"green",
	"blue",
	"white",
	"pink",
	"violet",
}

homedecor_windows_and_treatments.old_static_curtain_nodes = {}

for _, color in ipairs(curtaincolors) do
	table.insert(homedecor_windows_and_treatments.old_static_curtain_nodes, "homedecor:curtain_"..color)
	table.insert(homedecor_windows_and_treatments.old_static_curtain_nodes, "homedecor:curtain_open_"..color)
end

minetest.register_lbm({
	name = ":homedecor:convert_curtains",
	label = "Convert static curtain nodes to use param2 color",
	run_at_every_load = false,
	nodenames = homedecor_windows_and_treatments.old_static_curtain_nodes,
	action = function(pos, node)
		local name = node.name
		local color = string.sub(name, 19)
		local openclose = "closed"

		if string.find(color, "open") then
			color = string.sub(color, 6)
			openclose = "open"
		end

		local metadye = "medium_"..color
		if color == "white" then
			metadye = "white"
		end

		local newnode = "homedecor:curtain_"..openclose
		local paletteidx, _ = unifieddyes.getpaletteidx("unifieddyes:"..metadye, "wallmounted")
		local newparam2 = paletteidx + (node.param2 % 8)

		minetest.set_node(pos, { name = newnode, param2 = newparam2 })
		local meta = minetest.get_meta(pos)
		meta:set_string("dye", "unifieddyes:"..metadye)
	end
})

-- crafting


minetest.register_craft( {
	output = "homedecor:shutter 2",
	recipe = {
		{ "group:stick", "group:stick" },
		{ "group:stick", "group:stick" },
		{ "group:stick", "group:stick" },
	},
})

unifieddyes.register_color_craft({
	output = "homedecor:shutter_colored",
	palette = "wallmounted",
	type = "shapeless",
	neutral_node = "homedecor:shutter",
	recipe = {
		"NEUTRAL_NODE",
		"MAIN_DYE"
	}
})

minetest.register_craft({
        type = "fuel",
        recipe = "homedecor:shutter_oak",
        burntime = 30,
})


minetest.register_craft( {
	output = "homedecor:curtain_open 4",
		recipe = {
		{ "wool:white", "", ""},
		{ "wool:white", "", ""},
		{ "wool:white", "", ""},
	},
})

minetest.register_craft( {
	output = "homedecor:curtain_open 4",
		recipe = {
		{ "cottages:wool", "", ""},
		{ "cottages:wool", "", ""},
		{ "cottages:wool", "", ""},
	},
})

unifieddyes.register_color_craft({
	output = "homedecor:curtain_closed",
	palette = "wallmounted",
	type = "shapeless",
	neutral_node = "homedecor:curtain_closed",
	recipe = {
		"NEUTRAL_NODE",
		"MAIN_DYE"
	}
})

unifieddyes.register_color_craft({
	output = "homedecor:curtain_open",
	palette = "wallmounted",
	type = "shapeless",
	neutral_node = "homedecor:curtain_open",
	recipe = {
		"NEUTRAL_NODE",
		"MAIN_DYE"
	}
})

local mats_craft = {
	{ "brass", "homedecor:pole_brass" },
	{ "wrought_iron", "homedecor:pole_wrought_iron" },
	{ "wood", "group:stick" }
}

for i in ipairs(mats_craft) do
	local material = mats_craft[i][1]
	local ingredient = mats_craft[i][2]
	minetest.register_craft( {
		output = "homedecor:curtainrod_"..material.." 3",
		recipe = {
			{ ingredient, ingredient, ingredient },
		},
	})
end

minetest.register_craft({
	type = "shapeless",
    output = "homedecor:window_plain 8",
    recipe = {
		"dye:white",
		"dye:white",
		"dye:white",
		"dye:white",
		"building_blocks:woodglass"
    }
})

minetest.register_craft({
	type = "shapeless",
    output = "homedecor:window_quartered",
    recipe = {
		"dye:white",
		"group:stick",
		"group:stick",
		"homedecor:window_plain"
    }
})

minetest.register_craft({
    output = "homedecor:blinds_thin",
    recipe = {
		{ "group:stick", "basic_materials:plastic_sheet", "group:stick" },
		{ "farming:string", "basic_materials:plastic_strip", "" },
		{ "", "basic_materials:plastic_strip", "" },
    },
})

minetest.register_craft({
    output = "homedecor:blinds_thick",
    recipe = {
		{ "group:stick", "basic_materials:plastic_sheet", "group:stick" },
		{ "farming:string", "basic_materials:plastic_strip", "basic_materials:plastic_strip" },
		{ "", "basic_materials:plastic_strip", "basic_materials:plastic_strip" },
    },
})

minetest.register_craft( {
        output = "homedecor:window_flowerbox",
        recipe = {
                { "homedecor:roof_tile_terracotta", "default:dirt", "homedecor:roof_tile_terracotta" },
                { "", "homedecor:roof_tile_terracotta", "" },
        },
})

minetest.register_craft({
	output = "homedecor:stained_glass 8",
	recipe = {
		{"", "dye:blue", ""},
		{"dye:red", "default:glass", "dye:green"},
		{"", "dye:yellow", ""},
	},
})

minetest.register_craft({
	output = "homedecor:stained_glass 3",
	recipe = {
		{"", "dye:blue", ""},
		{"dye:red", "xpanes:pane_flat", "dye:green"},
		{"", "dye:yellow", ""},
	},
})

minetest.register_craft({
	output = "homedecor:stained_glass 2",
	recipe = {
		{"", "dye:blue", ""},
		{"dye:red", "cottages:glass_pane_side", "dye:green"},
		{"", "dye:yellow", ""},
	},
})

minetest.register_craft({
	output = "homedecor:stained_glass 2",
	recipe = {
		{"", "dye:blue", ""},
		{"dye:red", "cottages:glass_pane", "dye:green"},
		{"", "dye:yellow", ""},
	},
})

