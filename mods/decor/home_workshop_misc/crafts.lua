minetest.register_craft({
	output = "home_workshop_misc:tool_cabinet",
	recipe = {
		{ "basic_materials:motor", "default:axe_steel",               "default:pick_steel" },
		{ "default:steel_ingot",   "home_workshop_misc:drawer_small", "default:steel_ingot" },
		{ "default:steel_ingot",   "home_workshop_misc:drawer_small", "default:steel_ingot" }
	},
})

minetest.register_craft({
	output = "home_workshop_misc:beer_tap",
	recipe = {
		{ "group:stick",               "default:steel_ingot", "group:stick" },
		{ "basic_materials:steel_bar", "default:steel_ingot", "basic_materials:steel_bar" },
		{ "default:steel_ingot",       "default:steel_ingot", "default:steel_ingot" }
	},
})

minetest.register_craft({
	output = "homedecor:soda_machine",
	recipe = {
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "dye:red",             "default:steel_ingot"},
		{"default:steel_ingot", "default:copperblock", "default:steel_ingot"},
	},
})
