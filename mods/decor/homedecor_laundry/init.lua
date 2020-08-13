local S = minetest.get_translator("homedecor_laundry")
-- laundry devices

homedecor.register("washing_machine", {
	description = S("Washing Machine"),
	tiles = {
		"homedecor_washing_machine_top.png",
		"homedecor_washing_machine_bottom.png",
		"homedecor_washing_machine_sides.png",
		"homedecor_washing_machine_sides.png^[transformFX",
		"homedecor_washing_machine_back.png",
		"homedecor_washing_machine_front.png"
	},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.375, 0.375},
			{-0.5, -0.5, 0.3125, 0.5, 0.5, 0.5},
		}
	},
	selection_box = { type = "regular" },
	groups = { snappy = 3 },
})

homedecor.register("dryer", {
	description = S("Tumble dryer"),
	tiles = {
		"homedecor_dryer_top.png",
		"homedecor_dryer_bottom.png",
		"homedecor_dryer_sides.png",
		"homedecor_dryer_sides.png^[transformFX",
		"homedecor_dryer_back.png",
		"homedecor_dryer_front.png"
	},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.375, 0.375},
			{-0.5, -0.5, 0.3125, 0.5, 0.5, 0.5},
		}
	},
	selection_box = { type = "regular" },
	groups = { snappy = 3 },
})

local ib_cbox = {
	type = "fixed",
	fixed = { -6/16, -8/16, -4/16, 17/16, 4/16, 4/16 }
}

homedecor.register("ironing_board", {
	description = S("Ironing board"),
	mesh = "homedecor_ironing_board.obj",
	tiles = {
		"wool_grey.png",
		{ name = "homedecor_generic_metal.png", color = homedecor.color_med_grey },
	},
	expand = {right = "placeholder"},
	groups = { snappy = 3 },
	selection_box = ib_cbox,
	collision_box = ib_cbox
})

-- crafting


-- laundry stuff

minetest.register_craft( {
    output = "homedecor:washing_machine",
    recipe = {
		{ "default:steel_ingot", "default:steel_ingot", "basic_materials:ic" },
		{ "default:steel_ingot", "bucket:bucket_water", "default:steel_ingot" },
		{ "default:steel_ingot", "basic_materials:motor", "default:steel_ingot" }
    },
})

minetest.register_craft( {
    output = "homedecor:washing_machine",
    recipe = {
		{ "default:steel_ingot", "default:steel_ingot", "basic_materials:ic" },
		{ "default:steel_ingot", "bucket:bucket_water", "default:steel_ingot" },
		{ "default:steel_ingot", "basic_materials:motor", "default:steel_ingot" }
    },
})

minetest.register_craft( {
    output = "homedecor:dryer",
    recipe = {
		{ "default:steel_ingot", "default:steel_ingot", "basic_materials:ic" },
		{ "default:steel_ingot", "bucket:bucket_empty", "basic_materials:motor" },
		{ "default:steel_ingot", "basic_materials:heating_element", "default:steel_ingot" }
    },
})

minetest.register_craft( {
    output = "homedecor:dryer",
    recipe = {
		{ "default:steel_ingot", "default:steel_ingot", "basic_materials:ic" },
		{ "default:steel_ingot", "bucket:bucket_empty", "basic_materials:motor" },
		{ "default:steel_ingot", "basic_materials:heating_element", "default:steel_ingot" }
    },
})

minetest.register_craft( {
    output = "homedecor:ironing_board",
    recipe = {
		{ "wool:grey", "wool:grey", "wool:grey"},
		{ "", "default:steel_ingot", "" },
		{ "default:steel_ingot", "", "default:steel_ingot" }
    },
})

