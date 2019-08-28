local S = minetest.get_translator("mtg_plus")

local deco, build
if minetest.get_modpath("doc_items") then
	deco = doc.sub.items.temp.deco
	build = doc.sub.items.temp.build
end

local metal_sounds
if default.node_sound_metal_defaults then
	metal_sounds = default.node_sound_metal_defaults()
else
	metal_sounds = default.node_sound_stone_defaults()
end


-- Dirt bricks

minetest.register_node("mtg_plus:dirtbrick", {
	description = S("Soft Dirt Brick"),
	_doc_items_longdesc = build,
	tiles = {"mtg_plus_dirt_brick.png"},
	is_ground_content = false,
	groups = { crumbly = 2, soil = 1 },
	sounds = default.node_sound_dirt_defaults(),
	drop = "default:dirt",
})

minetest.register_craft({
	output = "mtg_plus:dirtbrick 4",
	recipe = { { "default:dirt", "default:dirt", },
	{ "default:dirt", "default:dirt", }, },
})

minetest.register_node("mtg_plus:harddirtbrick", {
	description = S("Hardened Dirt Brick"),
	_doc_items_longdesc = build,
	tiles = {"mtg_plus_dirt_brick_hard.png"},
	is_ground_content = false,
	groups = { crumbly = 1, level = 1, soil = 1 },
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_craft({
	type = "cooking",
	output = "mtg_plus:harddirtbrick",
	recipe = "mtg_plus:dirtbrick",
	cooktime = 5,
})

-- Metal bricks

minetest.register_node("mtg_plus:goldbrick", {
	description = S("Gold Brick"),
	_doc_items_longdesc = build,
	tiles = {"mtg_plus_gold_brick.png"},
	is_ground_content = false,
	groups = { cracky = 1, },
	sounds = metal_sounds,
})

minetest.register_craft({
	output = "mtg_plus:goldbrick 4",
	recipe = { { "default:goldblock", "default:goldblock", },
	{ "default:goldblock", "default:goldblock", }, },
})

minetest.register_node("mtg_plus:bronzebrick", {
	description = S("Bronze Brick"),
	_doc_items_longdesc = build,
	tiles = {"mtg_plus_bronze_brick.png"},
	is_ground_content = false,
	groups = { cracky = 1, level = 2 },
	sounds = metal_sounds,
})

minetest.register_craft({
	output = "mtg_plus:bronzebrick 4",
	recipe = { { "default:bronzeblock", "default:bronzeblock", },
	{ "default:bronzeblock", "default:bronzeblock", }, },
})

minetest.register_node("mtg_plus:tinbrick", {
	description = S("Tin Brick"),
	_doc_items_longdesc = build,
	tiles = {"mtg_plus_tin_brick.png"},
	is_ground_content = false,
	groups = { cracky = 1, level = 2 },
	sounds = metal_sounds,
})

minetest.register_craft({
	output = "mtg_plus:tinbrick 4",
	recipe = { { "default:tinblock", "default:tinblock", },
	{ "default:tinblock", "default:tinblock", }, },
})

minetest.register_node("mtg_plus:copperbrick", {
	description = S("Copper Brick"),
	_doc_items_longdesc = build,
	tiles = {"mtg_plus_copper_brick.png"},
	is_ground_content = false,
	groups = { cracky = 1, level = 2 },
	sounds = metal_sounds,
})

minetest.register_craft({
	output = "mtg_plus:copperbrick 4",
	recipe = { { "default:copperblock", "default:copperblock", },
	{ "default:copperblock", "default:copperblock", }, },
})

minetest.register_node("mtg_plus:steelbrick", {
	description = S("Steel Brick"),
	_doc_items_longdesc = build,
	tiles = {"mtg_plus_steel_brick.png"},
	is_ground_content = false,
	groups = { cracky = 1, level = 2 },
	sounds = metal_sounds,
})

minetest.register_craft({
	output = "mtg_plus:steelbrick 4",
	recipe = { { "default:steelblock", "default:steelblock", },
	{ "default:steelblock", "default:steelblock", }, },
})


-- Golden edges

minetest.register_node("mtg_plus:stonebrick_gold", {
	description = S("Stone Brick with Golden Edges"),
	_doc_items_longdesc = build,
	tiles = {"mtg_plus_stone_brick_gold.png"},
	is_ground_content = false,
	groups = { cracky = 2, stone = 1 },
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "mtg_plus:stonebrick_gold 4",
	recipe = { {  "", "default:stonebrick", "", },
	{ "default:stonebrick", "default:gold_ingot", "default:stonebrick", },
	{ "", "default:stonebrick", "", } }
})

minetest.register_node("mtg_plus:desert_stonebrick_gold", {
	description = S("Desert Stone Brick with Golden Edges"),
	_doc_items_longdesc = build,
	tiles = {"mtg_plus_desert_stone_brick_gold.png"},
	is_ground_content = false,
	groups = { cracky = 2, stone = 1 },
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "mtg_plus:desert_stonebrick_gold 4",
	recipe = { { "", "default:desert_stonebrick", "" },
	{ "default:desert_stonebrick", "default:gold_ingot", "default:desert_stonebrick", },
	{ "", "default:desert_stonebrick", "", } }
})

minetest.register_node("mtg_plus:sandstonebrick_gold", {
	description = S("Sandstone Brick with Golden Edges"),
	_doc_items_longdesc = build,
	tiles = {"mtg_plus_sandstone_brick_gold.png"},
	is_ground_content = false,
	groups = { cracky = 2, },
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "mtg_plus:sandstonebrick_gold 4",
	recipe = { { "", "default:sandstonebrick", "", },
	{ "default:sandstonebrick", "default:gold_ingot", "default:sandstonebrick", },
	{ "", "default:sandstonebrick", "", } }
})

minetest.register_node("mtg_plus:desert_sandstone_brick_gold", {
	description = S("Desert Sandstone Brick with Golden Edges"),
	_doc_items_longdesc = build,
	tiles = {"mtg_plus_desert_sandstone_brick_gold.png"},
	is_ground_content = false,
	groups = { cracky = 2, },
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "mtg_plus:desert_sandstone_brick_gold 4",
	recipe = { { "", "default:desert_sandstone_brick", "", },
	{ "default:desert_sandstone_brick", "default:gold_ingot", "default:desert_sandstone_brick", },
	{ "", "default:desert_sandstone_brick", "", } }
})

minetest.register_node("mtg_plus:silver_sandstone_brick_gold", {
	description = S("Silver Sandstone Brick with Golden Edges"),
	_doc_items_longdesc = build,
	tiles = {"mtg_plus_silver_sandstone_brick_gold.png"},
	is_ground_content = false,
	groups = { cracky = 2, },
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "mtg_plus:silver_sandstone_brick_gold 4",
	recipe = { { "", "default:silver_sandstone_brick", "", },
	{ "default:silver_sandstone_brick", "default:gold_ingot", "default:silver_sandstone_brick", },
	{ "", "default:silver_sandstone_brick", "", } }
})

minetest.register_node("mtg_plus:obsidianbrick_gold", {
	description = S("Obsidian Brick with Golden Edges"),
	_doc_items_longdesc = build,
	tiles = {"mtg_plus_obsidian_brick_gold.png"},
	is_ground_content = false,
	groups = { cracky = 1, level = 2 },
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "mtg_plus:obsidianbrick_gold 4",
	recipe = { { "", "default:obsidianbrick", "", },
	{ "default:obsidianbrick", "default:gold_ingot", "default:obsidianbrick", },
	{ "", "default:obsidianbrick", "", } }
})


-- Snow and ice

minetest.register_node("mtg_plus:ice_block", {
	description = S("Ice Block"),
	_doc_items_longdesc = build,
	tiles = {"mtg_plus_ice_block.png"},
	groups = {cracky = 3, cools_lava = 1, slippery = 3 },
	is_ground_content = false,
	paramtype = "light",
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_craft({
	output = "mtg_plus:ice_block 9",
	recipe = { { "default:ice", "default:ice", "default:ice" },
	{ "default:ice", "default:ice", "default:ice" },
	{ "default:ice", "default:ice", "default:ice" } }
})



minetest.register_node("mtg_plus:ice_tile4", {
	description = S("Ice Tile"),
	_doc_items_longdesc = build,
	tiles = {"mtg_plus_ice_tile4.png"},
	groups = {cracky = 3, level = 1, cools_lava = 1, slippery = 3 },
	is_ground_content = false,
	paramtype = "light",
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_craft({
	output = "mtg_plus:ice_tile4",
	recipe = { { "mtg_plus:ice_block", "mtg_plus:ice_block" },
	{ "mtg_plus:ice_block", "mtg_plus:ice_block" },}
})

minetest.register_node("mtg_plus:ice_tile16", {
	description = S("Dense Ice Tile"),
	_doc_items_longdesc = build,
	tiles = {"mtg_plus_ice_tile16.png"},
	groups = {cracky = 3, level = 2, cools_lava = 1, slippery = 2 },
	is_ground_content = false,
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_craft({
	output = "mtg_plus:ice_tile16",
	recipe = { { "mtg_plus:ice_tile4", "mtg_plus:ice_tile4" },
	{ "mtg_plus:ice_tile4", "mtg_plus:ice_tile4" } }
})

minetest.register_node("mtg_plus:snow_brick", {
	description = S("Soft Snow Brick"),
	_doc_items_longdesc = build,
	tiles = {"mtg_plus_snow_brick.png"},
	groups = {crumbly = 2, cools_lava = 1, snowy = 1},
	is_ground_content = false,
	sounds = default.node_sound_dirt_defaults({
		footstep={name="default_snow_footstep", gain = 0.15},
		dig={name="default_snow_footstep", gain = 0.2},
		dug={name="default_snow_footstep", gain = 0.2}
	}),
})

minetest.register_craft({
	output = "mtg_plus:snow_brick 4",
	recipe = { { "default:snowblock", "default:snowblock" },
	{ "default:snowblock", "default:snowblock", } },
})

minetest.register_craft({
	output = "default:snowblock 4",
	recipe = { { "mtg_plus:snow_brick" } },
})

minetest.register_node("mtg_plus:hard_snow_brick", {
	description = S("Hard Snow Brick"),
	_doc_items_longdesc = build,
	tiles = {"mtg_plus_hard_snow_brick.png"},
	groups = {crumbly = 1, cracky = 2, cools_lava = 1, snowy = 1},
	is_ground_content = false,
	sounds = default.node_sound_dirt_defaults({
		dig={name="default_snow_footstep", gain = 0.2},
		dug={name="default_snow_footstep", gain = 0.2}
	}),
})

minetest.register_craft({
	output = "mtg_plus:hard_snow_brick",
	recipe = { { "mtg_plus:snow_brick", "mtg_plus:snow_brick" },
		{  "mtg_plus:snow_brick", "mtg_plus:snow_brick" } },
})

minetest.register_node("mtg_plus:ice_snow_brick", {
	description = S("Icy Snow Brick"),
	_doc_items_longdesc = build,
	tiles = {"mtg_plus_ice_snow_brick.png"},
	groups = {cracky = 2, cools_lava = 1, slippery=1},
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "mtg_plus:ice_snow_brick 2",
	type = "shapeless",
	recipe = { "mtg_plus:hard_snow_brick", "mtg_plus:ice_brick" },
})

minetest.register_node("mtg_plus:ice_brick", {
	description = S("Ice Brick"),
	_doc_items_longdesc = build,
	tiles = {"mtg_plus_ice_brick.png"},
	paramtype = "light",
	groups = {cracky = 3, cools_lava = 1, slippery = 3},
	is_ground_content = false,
	sounds = default.node_sound_glass_defaults(),
})

-- Papyrus Block

minetest.register_node("mtg_plus:papyrus_block", {
	description = S("Papyrus Block"),
	_doc_items_longdesc = build,
	tiles = {"mtg_plus_papyrus_block_y.png","mtg_plus_papyrus_block_y.png","mtg_plus_papyrus_block_side2.png","mtg_plus_papyrus_block_side2.png","mtg_plus_papyrus_block_side.png","mtg_plus_papyrus_block_side.png"},
	groups = {snappy = 2, choppy = 2, flammable = 3},
	is_ground_content = false,
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_craft({
	output = "mtg_plus:papyrus_block",
	recipe = { { "default:papyrus", "default:papyrus", "default:papyrus", },
	{ "default:papyrus", "default:papyrus", "default:papyrus", },
	{ "default:papyrus", "default:papyrus", "default:papyrus", } }
})

minetest.register_craft({
	output = "default:papyrus 9",
	recipe = { { "mtg_plus:papyrus_block" } }
})

minetest.register_craft({
	type = "fuel",
	recipe = "mtg_plus:papyrus_block",
	burntime = 9,
})


-- Flint block

minetest.register_node("mtg_plus:flint_block", {
	description = S("Flint Block"),
	_doc_items_longdesc = deco,
	tiles = {"mtg_plus_flint_block.png"},
	is_ground_content = false,
	groups = {cracky = 2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "mtg_plus:flint_block",
	recipe = {
		{ "default:flint", "default:flint", "default:flint" },
		{ "default:flint", "default:flint", "default:flint" },
		{ "default:flint", "default:flint", "default:flint" },
	}
})

minetest.register_craft({
	output = "default:flint 9 ",
	recipe = {
		{ "mtg_plus:flint_block" },
	}
})

-- Gold-framed diamond block, just an absurd luxurious decoration. :D
minetest.register_node("mtg_plus:gold_diamond_block", {
	description = S("Small Gold-framed Diamond Block"),
	_doc_items_longdesc = deco,
	tiles = {"mtg_plus_gold_diamond_block.png"},
	is_ground_content = false,
	groups = {cracky = 1, level = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "mtg_plus:gold_diamond_block",
	recipe = { { "default:gold_ingot", "default:diamond", "default:gold_ingot", },
	{ "default:diamond", "default:diamond", "default:diamond" },
	{ "default:gold_ingot", "default:diamond", "default:gold_ingot", } },
})
