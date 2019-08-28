local S = minetest.get_translator("mtg_plus")

-- Blocks that you can see through

minetest.register_node("mtg_plus:goldglass", {
	description = S("Goldglass"),
	_doc_items_longdesc = S("A ornamental and mostly transparent block, made by combining glass with gold."),
	drawtype = "glasslike_framed_optional",
	tiles = {"mtg_plus_goldglass.png", "mtg_plus_goldglass_detail.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = { cracky = 3, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_craft({
	output = "mtg_plus:goldglass 1",
	recipe = { { "default:gold_ingot", },
		{ "default:glass",},
		{ "default:gold_ingot", },
	}
})

minetest.register_node("mtg_plus:dirty_glass", {
	description = S("Dirty Glass"),
	_doc_items_longdesc = S("A decorative, semitransparent block. The dirt makes it hard for the sunlight to pass through."),
	drawtype = "glasslike_framed_optional",
	tiles = {"mtg_plus_dirty_glass.png", "mtg_plus_dirty_glass_detail.png"},
	paramtype = "light",
	sunlight_propagates = false,
	is_ground_content = false,
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_craft({
	output = "mtg_plus:dirty_glass 3",
	recipe = { { "", "default:dirt", "" },
		{"default:glass", "default:glass", "default:glass"},
	}
})

minetest.register_node("mtg_plus:ice_window", {
	description = S("Ice Window"),
	_doc_items_longdesc = S("This decorational ice tile has been crafted in a way that it is partially transparent and looks like a real window."),
	drawtype = "glasslike",
	tiles = {"mtg_plus_ice_window.png"},
	sunlight_propagates = true,
	groups = {cracky = 3, cools_lava = 1, slippery = 3 },
	is_ground_content = false,
	paramtype = "light",
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_craft({
	output = "mtg_plus:ice_window",
	type = "cooking",
	recipe = "mtg_plus:ice_tile4",
	cooktime = 1,
})
