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
	groups = { snappy = 3, dig_stone=3 },
	crafts = {
		{
			recipe = {
				{ "steel_ingot", "steel_ingot", "basic_materials:ic" },
				{ "steel_ingot", "water_bucket", "steel_ingot" },
				{ "steel_ingot", "basic_materials:motor", "steel_ingot" }
			},
		},
		{
			recipe = {
				{ "steel_ingot", "steel_ingot", "basic_materials:ic" },
				{ "steel_ingot", "water_bucket", "steel_ingot" },
				{ "steel_ingot", "basic_materials:motor", "steel_ingot" }
			},
		}
	}
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
	groups = { snappy = 3, dig_stone=3 },
	crafts = {
		{
			recipe = {
				{ "steel_ingot", "steel_ingot", "basic_materials:ic" },
				{ "steel_ingot", "empty_bucket", "basic_materials:motor" },
				{ "steel_ingot", "basic_materials:heating_element", "steel_ingot" }
			},
		},
		{
			recipe = {
				{ "steel_ingot", "steel_ingot", "basic_materials:ic" },
				{ "steel_ingot", "empty_bucket", "basic_materials:motor" },
				{ "steel_ingot", "basic_materials:heating_element", "steel_ingot" }
			},
		}
	}
})

local ib_cbox = {
	type = "fixed",
	fixed = { -6/16, -8/16, -4/16, 17/16, 4/16, 4/16 }
}

local wool_tex = homedecor.textures.wool.grey

homedecor.register("ironing_board", {
	description = S("Ironing board"),
	mesh = "homedecor_ironing_board.obj",
	tiles = {
		wool_tex,
		{ name = "homedecor_generic_metal.png", color = homedecor.color_med_grey },
	},
	expand = {right = "placeholder"},
	groups = { snappy = 3, dig_stone=3 },
	selection_box = ib_cbox,
	collision_box = ib_cbox,
	crafts = {
		{
			recipe = {
				{ "wool_grey", "wool_grey", "wool_grey"},
				{ "", "steel_ingot", "" },
				{ "steel_ingot", "", "steel_ingot" }
			},
		}
	}
})