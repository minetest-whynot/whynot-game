local S = minetest.get_translator("mtg_plus")

local build
if minetest.get_modpath("doc_items") then
	build = doc.sub.items.temp.build
end

-- Cobblestone

minetest.register_node("mtg_plus:gravel_cobble", {
	description = S("Cobbled Gravel"),
	_doc_items_longdesc = S("Cobbled gravel is solidified gravel, carefully arranged in a mosaic-like pattern. It makes a nice building material."),
	tiles = {"mtg_plus_gravel_cobble.png"},
	is_ground_content = false,
	groups = { cracky = 3, stone = 1 },
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "mtg_plus:gravel_cobble 2",
	recipe = { { "default:gravel", "default:gravel" },
		{ "default:gravel", "default:gravel" } },
})

minetest.register_craft({
	type = "cooking",
	output = "default:gravel",
	recipe = "mtg_plus:gravel_cobble",
})


minetest.register_node("mtg_plus:sandstone_cobble", {
	description = S("Cobbled Sandstone"),
	_doc_items_longdesc = build,
	tiles = {"mtg_plus_sandstone_cobble.png"},
	groups = {cracky = 3, },
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "mtg_plus:sandstone_cobble 2",
	recipe = { { "default:sandstone", "default:sandstone" } },
})

minetest.register_craft({
	type = "cooking",
	output = "default:sandstone",
	recipe = "mtg_plus:sandstone_cobble",
})

minetest.register_node("mtg_plus:desert_sandstone_cobble", {
	description = S("Cobbled Desert Sandstone"),
	_doc_items_longdesc = build,
	tiles = {"mtg_plus_desert_sandstone_cobble.png"},
	groups = {cracky = 3, },
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "mtg_plus:desert_sandstone_cobble 2",
	recipe = { { "default:desert_sandstone", "default:desert_sandstone" } },
})

minetest.register_craft({
	type = "cooking",
	output = "default:desert_sandstone",
	recipe = "mtg_plus:desert_sandstone_cobble",
})

minetest.register_node("mtg_plus:silver_sandstone_cobble", {
	description = S("Cobbled Silver Sandstone"),
	_doc_items_longdesc = build,
	tiles = {"mtg_plus_silver_sandstone_cobble.png"},
	groups = {cracky = 3, },
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "mtg_plus:silver_sandstone_cobble 2",
	recipe = { { "default:silver_sandstone", "default:silver_sandstone" } },
})

minetest.register_craft({
	type = "cooking",
	output = "default:silver_sandstone",
	recipe = "mtg_plus:silver_sandstone_cobble",
})

minetest.register_node("mtg_plus:jungle_cobble", {
	description = S("Jungle Cobblestone"),
	_doc_items_longdesc = build,
	tiles = {"mtg_plus_jungle_cobble.png"},
	groups = {cracky=3, stone=1},
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "mtg_plus:jungle_cobble",
	type = "shapeless",
	recipe = { "default:jungleleaves", "default:jungleleaves", "default:cobble" },
})

minetest.register_craft({
	output = "mtg_plus:jungle_cobble",
	type = "shapeless",
	recipe = { "default:jungleleaves", "default:mossycobble" },
})

minetest.register_craft({
	output = "default:stone",
	type = "cooking",
	recipe = "mtg_plus:jungle_cobble",
})
