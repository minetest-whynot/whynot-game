local S = minetest.get_translator("homedecor_furniture_medieval")

homedecor.register("bars", {
	description = S("Bars"),
	tiles = { { name = "homedecor_generic_metal.png^[transformR270", color = homedecor.color_black } },
	node_box = {
		type = "fixed",
		fixed = {
			{ -0.5, -0.50, -0.10, -0.4,  0.50,  0.10 },
			{ -0.1, -0.50, -0.10,  0.1,  0.50,  0.10 },
			{  0.4, -0.50, -0.10,  0.5,  0.50,  0.10 },
			{ -0.5, -0.50, -0.05,  0.5, -0.45,  0.05 },
			{ -0.5,  0.45, -0.05,  0.5,  0.50,  0.05 },
		},
	},
	selection_box = {
		type = "fixed",
		fixed = { -0.5, -0.5, -0.1, 0.5, 0.5, 0.1 },
	},
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

--L Binding Bars
homedecor.register("L_binding_bars", {
	description = S("Binding Bars"),
	tiles = { { name = "homedecor_generic_metal.png^[transformR270", color = homedecor.color_black } },
	node_box = {
		type = "fixed",
		fixed = {
			{ -0.10, -0.50, -0.50,  0.10,  0.50, -0.40 },
			{ -0.15, -0.50, -0.15,  0.15,  0.50,  0.15 },
			{  0.40, -0.50, -0.10,  0.50,  0.50,  0.10 },
			{  0.00, -0.50, -0.05,  0.50, -0.45,  0.05 },
			{ -0.05, -0.50, -0.50,  0.05, -0.45,  0.00 },
			{  0.00,  0.45, -0.05,  0.50,  0.50,  0.05 },
			{ -0.05,  0.45, -0.50,  0.05,  0.50,  0.00 },
		},
	},
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

local chain_cbox = {
	type = "fixed",
	fixed = {-1/2, -1/2, 1/4, 1/2, 1/2, 1/2},
}

homedecor.register("chains", {
	description = S("Chains"),
	mesh = "forniture_chains.obj",
	tiles = { { name = "homedecor_generic_metal.png", color = homedecor.color_black } },
	inventory_image="forniture_chains_inv.png",
	selection_box = chain_cbox,
	walkable = false,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

-- Crafts

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

minetest.register_alias("3dforniture:bars", "homedecor:bars")
minetest.register_alias("3dforniture:L_binding_bars", "homedecor:L_binding_bars")
minetest.register_alias("3dforniture:chains", "homedecor:chains")

minetest.register_alias('bars', 'homedecor:bars')
minetest.register_alias('binding_bars', 'homedecor:L_binding_bars')
minetest.register_alias('chains', 'homedecor:chains')
