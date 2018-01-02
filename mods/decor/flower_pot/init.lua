minetest.register_node("flower_pot:flower_pot", {
	description = "Flower Pot",
	tiles = {"default_dirt.png^flower_pot_top.png","flower_pot_side.png"},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {{-1/2, -3/8, -1/2, 1/2, -2/8, 1/2},
			{-1/2, -1/2, -1/2, -3/8, 1/2, 1/2},
			{3/8, -1/2, -1/2, 1/2, 1/2, 1/2},
			{-1/2, -3/8, -1/2, 1/2, 1/2, -3/8},
			{-1/2, -3/8, 3/8, 1/2, 1/2, 1/2},
			{-3/8, 0, -3/8, 3/8, 15/32, 3/8}},
	},
	paramtype = "light",
	is_ground_content = false,
	groups = {cracky = 3, soil=3, grassland = 1, wet = 1},
	sounds =  default.node_sound_stone_defaults(),
})

minetest.register_node("flower_pot:flower_pot_sand", {
	description = "Flower Pot with Sand",
	tiles = {"default_desert_sand.png^flower_pot_top.png","flower_pot_side.png"},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {{-1/2, -3/8, -1/2, 1/2, -2/8, 1/2},
			{-1/2, -1/2, -1/2, -3/8, 1/2, 1/2},
			{3/8, -1/2, -1/2, 1/2, 1/2, 1/2},
			{-1/2, -3/8, -1/2, 1/2, 1/2, -3/8},
			{-1/2, -3/8, 3/8, 1/2, 1/2, 1/2},
			{-3/8, 0, -3/8, 3/8, 15/32, 3/8}},
	},
	paramtype = "light",
	is_ground_content = false,
	groups = {cracky = 3, soil=3, desert = 1, wet = 1},
	sounds =  default.node_sound_stone_defaults(),
})

minetest.register_node("flower_pot:flower_pot_empty", {
	description = "Flower Pot (empty)",
	tiles = {"flower_pot_side.png"},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {{-1/2, -3/8, -1/2, 1/2, -2/8, 1/2},
			{-1/2, -1/2, -1/2, -3/8, 1/2, 1/2},
			{3/8, -1/2, -1/2, 1/2, 1/2, 1/2},
			{-1/2, -3/8, -1/2, 1/2, 1/2, -3/8},
			{-1/2, -3/8, 3/8, 1/2, 1/2, 1/2}},
	},
	paramtype = "light",
	is_ground_content = false,
	groups = {cracky = 3},
	sounds =  default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "flower_pot:flower_pot_empty",
	recipe = {
		{"default:clay_brick", "", "default:clay_brick"},
		{"default:clay_brick", "", "default:clay_brick"},
		{"default:clay_brick", "default:clay_brick", "default:clay_brick"}
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "flower_pot:flower_pot",
	recipe = {"default:dirt", "flower_pot:flower_pot_empty"}
})

minetest.register_craft({
	type = "shapeless",
	output = "flower_pot:flower_pot_sand",
	recipe = {"group:sand", "flower_pot:flower_pot_empty"}
})
