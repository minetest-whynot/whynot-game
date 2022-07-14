-- Copyright (C) 2012-2013 Diego Martínez <kaeza@users.sf.net>

minetest.register_craft({
	output = "computers:shefriendSOO",
	recipe = {
		{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
		{ "basic_materials:plastic_sheet", "default:glass", "basic_materials:plastic_sheet" },
		{ "basic_materials:plastic_sheet", "group:wood", "basic_materials:plastic_sheet" }
	}
})

minetest.register_craft({
	output = "computers:slaystation",
	recipe = {
		{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
		{ "basic_materials:plastic_sheet", "group:wood", "basic_materials:plastic_sheet" }
	}
})

minetest.register_craft({
	output = "computers:vanio",
	recipe = {
		{ "basic_materials:plastic_sheet", "", "" },
		{ "default:glass", "", "" },
		{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" }
	}
})

minetest.register_craft({
	output = "computers:specter",
	recipe = {
		{ "", "", "basic_materials:plastic_sheet" },
		{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
		{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" }
	}
})

minetest.register_craft({
	output = "computers:slaystation2",
	recipe = {
		{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
		{ "basic_materials:plastic_sheet", "default:steel_ingot", "basic_materials:plastic_sheet" }
	}
})

minetest.register_craft({
	output = "computers:admiral64",
	recipe = {
		{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
		{ "group:wood", "group:wood", "group:wood" }
	}
})

minetest.register_craft({
	output = "computers:admiral128",
	recipe = {
		{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
		{ "default:steel_ingot", "default:steel_ingot", "default:steel_ingot" }
	}
})

minetest.register_craft({
	output = "computers:wee",
	recipe = {
		{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
		{ "basic_materials:plastic_sheet", "default:copper_ingot", "basic_materials:plastic_sheet" }
	}
})

minetest.register_craft({
	output = "computers:piepad",
	recipe = {
		{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
		{ "basic_materials:plastic_sheet", "default:glass", "basic_materials:plastic_sheet" }
	}
})

--new stuff

minetest.register_craft({
	output = "computers:monitor",
	recipe = {
		{ "basic_materials:plastic_sheet", "default:glass","" },
		{ "basic_materials:plastic_sheet", "default:glass","" },
		{ "basic_materials:plastic_sheet", "default:mese_crystal_fragment", "basic_materials:plastic_sheet" }
	}
})

minetest.register_craft({
	output = "computers:router",
	recipe = {
		{ "default:steel_ingot","","" },
		{ "default:steel_ingot" ,"basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
		{ "default:mese_crystal_fragment","basic_materials:plastic_sheet", "basic_materials:plastic_sheet"  }
	}
})

minetest.register_craft({
	output = "computers:tower",
	recipe = {
		{ "basic_materials:plastic_sheet", "default:steel_ingot", "basic_materials:plastic_sheet" },
		{ "basic_materials:plastic_sheet", "default:mese_crystal", "basic_materials:plastic_sheet" },
		{ "basic_materials:plastic_sheet", "default:steel_ingot", "basic_materials:plastic_sheet" }
	}
})

minetest.register_craft({
	output = "computers:printer",
	recipe = {
		{ "basic_materials:plastic_sheet", "default:steel_ingot","" },
		{ "basic_materials:plastic_sheet", "default:mese_crystal", "basic_materials:plastic_sheet" },
		{ "basic_materials:plastic_sheet", "default:coal_lump", "basic_materials:plastic_sheet" }
	}
})

minetest.register_craft({
	output = "computers:printer",
	recipe = {
		{ "basic_materials:plastic_sheet", "default:steel_ingot","" },
		{ "basic_materials:plastic_sheet", "default:mese_crystal", "basic_materials:plastic_sheet" },
		{ "basic_materials:plastic_sheet", "dye:black", "basic_materials:plastic_sheet", }
	}
})

minetest.register_craft({
	output = "computers:server",
	recipe = {
		{ "computers:tower", "computers:tower", "computers:tower", },
		{ "computers:tower", "computers:tower", "computers:tower" },
		{ "computers:tower", "computers:tower", "computers:tower" }
	}
})

minetest.register_craft({
	output = "computers:tetris_arcade",
	recipe = {
		{ "basic_materials:plastic_sheet", "basic_materials:energy_crystal_simple", "basic_materials:plastic_sheet", },
		{ "dye:black", "default:glass", "dye:black" },
		{ "basic_materials:plastic_sheet", "basic_materials:energy_crystal_simple", "basic_materials:plastic_sheet" }
	}
})
