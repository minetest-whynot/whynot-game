-- this component contains all of the random types of seating previously
-- scattered among homedecor's other mods

local S = minetest.get_translator("homedecor_seating")

local dc_cbox = {
	type = "fixed",
	fixed = { -0.5, -0.5, -0.5, 0.5, 0, 1 }
}

homedecor.register("deckchair", {
	mesh = "homedecor_deckchair.obj",
	tiles = {"homedecor_deckchair.png"},
	description = S("Deck Chair"),
	groups = { snappy = 3, dig_tree=2 },
	expand = { forward="placeholder" },
	_sound_def = {
		key = "node_sound_wood_defaults",
	},
	selection_box = dc_cbox,
	collision_box = dc_cbox,
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		return lrfurn.sit(pos, node, clicker, itemstack, pointed_thing, 1)
	end,
	on_destruct = lrfurn.on_seat_destruct,
	on_movenode = lrfurn.on_seat_movenode,
})

minetest.register_alias("homedecor:deckchair_foot", "homedecor:deckchair")
minetest.register_alias("homedecor:deckchair_head", "air")

homedecor.register("deckchair_striped_blue", {
	mesh = "homedecor_deckchair.obj",
	tiles = {"homedecor_deckchair_striped_blue.png"},
	description = S("Deck Chair (blue striped)"),
	groups = { snappy = 3, dig_tree=2 },
	expand = { forward="placeholder" },
	_sound_def = {
		key = "node_sound_wood_defaults",
	},
	selection_box = dc_cbox,
	collision_box = dc_cbox,
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		return lrfurn.sit(pos, node, clicker, itemstack, pointed_thing, 1)
	end,
	on_destruct = lrfurn.on_seat_destruct,
	on_movenode = lrfurn.on_seat_movenode,
})

homedecor.register("simple_bench", {
	tiles = { "homedecor_generic_wood_old.png" },
	description = S("Simple Bench"),
	groups = {snappy=3, dig_tree=2},
	node_box = {
	type = "fixed",
	fixed = {
			{-0.5, -0.15, 0,  0.5,  -0.05, 0.4},
			{-0.4, -0.5,  0.1, -0.3, -0.15, 0.3},
			{ 0.3, -0.5,  0.1,  0.4, -0.15, 0.3},
			}
	},
	_sound_def = {
		key = "node_sound_wood_defaults",
	},
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		return lrfurn.sit(pos, node, clicker, itemstack, pointed_thing, 1)
	end,
	on_destruct = lrfurn.on_seat_destruct,
	on_movenode = lrfurn.on_seat_movenode,
})

local bl1_sbox = {
	type = "fixed",
	fixed = { -0.5, -0.5, -0.25, 1.5, 0.5, 0.5 }
}

local bl1_cbox = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5, -0.25, 1.5, 0, 0.5 },
		{-0.5, -0.5, 0.45, 1.5, 0.5, 0.5 },
	}
}

homedecor.register("bench_large_1", {
	mesh = "homedecor_bench_large_1.obj",
	tiles = {
		"homedecor_generic_wood_old.png",
		"homedecor_generic_metal_wrought_iron.png"
	},
	description = S("Garden Bench (style 1)"),
	inventory_image = "homedecor_bench_large_1_inv.png",
	groups = { snappy = 3, dig_tree=2 },
	expand = { right="placeholder" },
	_sound_def = {
		key = "node_sound_wood_defaults",
	},
	selection_box = bl1_sbox,
	node_box = bl1_cbox,
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil,
})

minetest.register_alias("homedecor:bench_large_1_left", "homedecor:bench_large_1")
minetest.register_alias("homedecor:bench_large_1_right", "air")

local bl2_sbox = {
	type = "fixed",
	fixed = { -0.5, -0.5, -0.25, 1.5, 0.5, 0.5 }
}

local bl2_cbox = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5, -0.25, 1.5, 0, 0.5 },
		{-0.5, -0.5, 0.45, 1.5, 0.5, 0.5 },
	}
}

homedecor.register("bench_large_2", {
	description = S("Garden Bench (style 2)"),
	mesh = "homedecor_bench_large_2.obj",
	tiles = { "homedecor_generic_wood_old.png" },
	inventory_image = "homedecor_bench_large_2_inv.png",
	groups = {snappy=3, dig_tree=2},
	selection_box = bl2_sbox,
	node_box = bl2_cbox,
	expand = { right="placeholder" },
	_sound_def = {
		key = "node_sound_wood_defaults",
	},
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil,
})

minetest.register_alias("homedecor:bench_large_2_left", "homedecor:bench_large_2")
minetest.register_alias("homedecor:bench_large_2_right", "air")

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
	_sound_def = {
		key = "node_sound_wood_defaults",
	},
	after_place_node = unifieddyes.fix_rotation_nsew,
	on_rotate = unifieddyes.fix_after_screwdriver_nsew,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		return lrfurn.sit(pos, node, clicker, itemstack, pointed_thing, 1)
	end,
	on_destruct = lrfurn.on_seat_destruct,
	on_movenode = lrfurn.on_seat_movenode,
})

homedecor.register("kitchen_chair_padded", {
	description = S("Kitchen chair"),
	mesh = "homedecor_kitchen_chair.obj",
	tiles = {
		homedecor.plain_wood,
		homedecor.textures.wool.white,
	},
	inventory_image = "homedecor_chair_padded_inv.png",
	paramtype2 = "colorwallmounted",
	palette = "unifieddyes_palette_colorwallmounted.png",
	selection_box = kc_cbox,
	collision_box = kc_cbox,
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2, ud_param2_colorable = 1},
	_sound_def = {
		key = "node_sound_wood_defaults",
	},
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		unifieddyes.fix_rotation_nsew(pos, placer, itemstack, pointed_thing)
	end,
	on_dig = unifieddyes.on_dig,
	on_rotate = unifieddyes.fix_after_screwdriver_nsew,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		return lrfurn.sit(pos, node, clicker, itemstack, pointed_thing, 1)
	end,
	on_destruct = lrfurn.on_seat_destruct,
	on_movenode = lrfurn.on_seat_movenode,
})

local ofchairs_sbox = {
	type = "fixed",
	fixed = { -8/16, -8/16, -8/16, 8/16, 29/32, 8/16 }
}
local ofchairs_cbox = {
	type = "fixed",
	fixed = {
		{ -5/16,   1/16, -7/16,  5/16,   4/16,  7/16 }, -- seat
		{ -5/16,   4/16,  4/16,  5/16,  29/32, 15/32 }, -- seatback
		{ -1/16, -11/32, -1/16,  1/16,   1/16,  1/16 }, -- cylinder
		{ -8/16,  -8/16, -8/16,  8/16, -11/32,  8/16 }  -- legs/wheels
	}
}

local chairs = {
	{ "basic",   S("Basic office chair") },
	{ "upscale", S("Upscale office chair") },
}

for _, c in pairs(chairs) do
	local name, desc = unpack(c)
	homedecor.register("office_chair_"..name, {
		description = desc,
		drawtype = "mesh",
		tiles = { "homedecor_office_chair_"..name..".png" },
		mesh = "homedecor_office_chair_"..name..".obj",
		groups = { snappy = 3, dig_tree=2 },
		_sound_def = {
			key = "node_sound_wood_defaults",
		},
		selection_box = ofchairs_sbox,
		collision_box = ofchairs_cbox,
		expand = { top = "placeholder" },
		on_rotate = minetest.get_modpath("screwdriver") and screwdriver.rotate_simple or nil,
		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			return lrfurn.sit(pos, node, clicker, itemstack, pointed_thing, 1)
		end,
		on_destruct = lrfurn.on_seat_destruct,
		on_movenode = lrfurn.on_seat_movenode,
	})
end

-- crafts!

minetest.register_craft( {
        output = "homedecor:bench_large_1",
        recipe = {
			{ "group:wood", "group:wood", "group:wood" },
			{ "group:wood", "group:wood", "group:wood" },
			{ "basic_materials:steel_bar", "", "basic_materials:steel_bar" }
        },
})

minetest.register_craft( {
        output = "homedecor:bench_large_2_left",
        recipe = {
			{ "homedecor:shutter_oak", "homedecor:shutter_oak", "homedecor:shutter_oak" },
			{ "group:wood", "group:wood", "group:wood" },
			{ homedecor.materials.slab_wood, "", homedecor.materials.slab_wood }
        },
})

minetest.register_craft( {
        output = "homedecor:bench_large_2_left",
        recipe = {
			{ "homedecor:shutter_oak", "homedecor:shutter_oak", "homedecor:shutter_oak" },
			{ "group:wood", "group:wood", "group:wood" },
			{ "moreblocks:slab_wood", "", "moreblocks:slab_wood" }
        },
})

minetest.register_craft( {
        output = "homedecor:simple_bench",
        recipe = {
			{ homedecor.materials.slab_wood, homedecor.materials.slab_wood, homedecor.materials.slab_wood },
			{ homedecor.materials.slab_wood, "", homedecor.materials.slab_wood }
        },
})

minetest.register_craft( {
        output = "homedecor:simple_bench",
        recipe = {
			{ "moreblocks:slab_wood", "moreblocks:slab_wood", "moreblocks:slab_wood" },
			{ "moreblocks:slab_wood", "", "moreblocks:slab_wood" }
        },
})


minetest.register_craft({
	output = "homedecor:deckchair",
	recipe = {
		{ "group:stick", "building_blocks:terrycloth_towel", "group:stick" },
		{ "group:stick", "building_blocks:terrycloth_towel", "group:stick" },
		{ "group:stick", "building_blocks:terrycloth_towel", "group:stick" }
	},
})

minetest.register_craft({
	output = "homedecor:deckchair_striped_blue",
	type = "shapeless",
	recipe = {
		"homedecor:deckchair",
		"dye:blue"
	}
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
	type = "shapeless",
	output = "homedecor:kitchen_chair_padded",
	recipe = {
		"homedecor:kitchen_chair_wood",
		homedecor.materials.wool_white,
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
	output = "homedecor:office_chair_basic",
	recipe = {
		{ "", "", homedecor.materials.wool_black },
		{ "", homedecor.materials.wool_black, homedecor.materials.steel_ingot },
		{ "group:stick", "basic_materials:steel_bar", "group:stick" }
	},
})

minetest.register_craft({
	output = "homedecor:office_chair_upscale",
	recipe = {
		{ homedecor.materials.dye_black, "building_blocks:sticks", "group:wool" },
		{ "basic_materials:plastic_sheet", "group:wool", homedecor.materials.steel_ingot },
		{ "building_blocks:sticks", "basic_materials:steel_bar", "building_blocks:sticks" }
	},
})

-- aliases

minetest.register_alias("3dforniture:chair", "homedecor:chair")
minetest.register_alias('chair', 'homedecor:chair')
