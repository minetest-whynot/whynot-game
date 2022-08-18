-- Various home electronics

local S = minetest.get_translator("homedecor_electronics")

homedecor.register("speaker", {
	description = S("Large Stereo Speaker"),
	mesh="homedecor_speaker_large.obj",
	tiles = {
		"homedecor_speaker_sides.png",
		"homedecor_speaker_front.png"
	},
	groups = { snappy = 3, dig_tree = 2 },
	_sound_def = {
		key = "node_sound_wood_defaults",
	},
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		minetest.set_node(pos, {name = "homedecor:speaker_open", param2 = node.param2})
	end,
	crafts = {
		{
			recipe = {
				{ "wool_black", "homedecor:speaker_driver", "group:wood" },
				{ "wool_black", "homedecor:speaker_driver", "group:wood" },
				{ "wool_black", "group:wood", "group:wood" },
			},
		},
		{
			recipe = {
				{ "cotton:black", "homedecor:speaker_driver", "group:wood" },
				{ "cotton:black", "homedecor:speaker_driver", "group:wood" },
				{ "cotton:black", "group:wood", "group:wood" },
			},
		}
	}
})

homedecor.register("speaker_open", {
	description = S("Large Stereo Speaker, open front"),
	mesh="homedecor_speaker_large_open.obj",
	tiles = {
		"homedecor_speaker_sides.png",
		"homedecor_speaker_driver.png",
		"homedecor_speaker_open_front.png",
		{ name = "homedecor_generic_metal.png", color = homedecor.color_black }
	},
	groups = { snappy = 3, not_in_creative_inventory=1, dig_tree = 2 },
	_sound_def = {
		key = "node_sound_wood_defaults",
	},
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		minetest.set_node(pos, {name = "homedecor:speaker", param2 = node.param2})
	end
})

local spk_cbox = {
	type = "fixed",
	fixed = { -3/16, -8/16, 1/16, 3/16, -2/16, 7/16 }
}

homedecor.register("speaker_small", {
	description = S("Small Surround Speaker"),
	mesh="homedecor_speaker_small.obj",
	tiles = {
		"homedecor_speaker_sides.png",
		"homedecor_speaker_front.png"
	},
	selection_box = spk_cbox,
	walkable = false,
	groups = { snappy = 3, dig_tree = 2 },
	_sound_def = {
		key = "node_sound_wood_defaults",
	},
	crafts = {
		{
			recipe = {
				{ "wool_black", "homedecor:speaker_driver", "group:wood" },
			},
		},
		{
			recipe = {
				{ "cotton:black", "homedecor:speaker_driver", "group:wood" },
			},
		}
	}
})

homedecor.register("stereo", {
	description = S("Stereo Receiver"),
	tiles = { 'homedecor_stereo_top.png',
			'homedecor_stereo_bottom.png',
			'homedecor_stereo_left.png^[transformFX',
			'homedecor_stereo_left.png',
			'homedecor_stereo_back.png',
			'homedecor_stereo_front.png'},
	groups = { snappy = 3, dig_tree = 2 },
	_sound_def = {
		key = "node_sound_wood_defaults",
	},
	crafts = {
		{
			recipe = {
				{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
				{ "basic_materials:plastic_sheet", "basic_materials:ic", "basic_materials:plastic_sheet" },
				{ "steel_ingot", "basic_materials:ic", "steel_ingot" },
			},
		}
	}
})

homedecor.register("projection_screen", {
	description = S("Projection Screen Material"),
	drawtype = 'signlike',
	tiles = { 'homedecor_projection_screen.png' },
	wield_image = 'homedecor_projection_screen_inv.png',
	inventory_image = 'homedecor_projection_screen_inv.png',
	walkable = false,
	groups = { snappy = 3, dig_tree = 2 },
	_sound_def = {
		key = "node_sound_leaves_defaults",
	},
	paramtype2 = 'wallmounted',
	selection_box = {
		type = "wallmounted",
		--wall_side = = <default>
	},
	crafts = {
		{
			output = "homedecor:projection_screen 3",
			recipe = {
				{ "", "glass_block", "" },
				{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
				{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
			},
		},
	}
})

homedecor.register("television", {
	description = S("Small CRT Television"),
	tiles = { 'homedecor_television_top.png',
		  'homedecor_television_bottom.png',
		  'homedecor_television_left.png^[transformFX',
		  'homedecor_television_left.png',
		  'homedecor_television_back.png',
		   { name="homedecor_television_front_animated.png",
			  animation={
				type="vertical_frames",
				aspect_w=16,
				aspect_h=16,
				length=80.0
			  }
		   }
	},
	light_source = minetest.LIGHT_MAX - 1,
	groups = { snappy = 3, dig_tree = 2 },
	_sound_def = {
		key = "node_sound_wood_defaults",
	},
	crafts = {
		{
			recipe = {
				{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
				{ "basic_materials:plastic_sheet", "glass_block", "basic_materials:plastic_sheet" },
				{ "basic_materials:ic", "basic_materials:energy_crystal_simple", "basic_materials:ic" },
			},
		},
		{
			recipe = {
				{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
				{ "basic_materials:plastic_sheet", "moreblocks:glow_glass", "basic_materials:plastic_sheet" },
				{ "basic_materials:ic", "basic_materials:ic", "basic_materials:ic" },
			},
		}
	}
})

homedecor.register("dvd_vcr", {
	description = S("DVD and VCR"),
	tiles = {
		"homedecor_dvdvcr_top.png",
		"homedecor_dvdvcr_bottom.png",
		"homedecor_dvdvcr_sides.png",
		"homedecor_dvdvcr_sides.png^[transformFX",
		"homedecor_dvdvcr_back.png",
		"homedecor_dvdvcr_front.png",
	},
	inventory_image = "homedecor_dvdvcr_inv.png",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.5, -0.25, 0.3125, -0.375, 0.1875},
			{-0.25, -0.5, -0.25, 0.25, -0.1875, 0.125},
		}
	},
	groups = { snappy = 3, dig_tree = 2 },
	_sound_def = {
		key = "node_sound_wood_defaults",
	},
	crafts = {
		{
			output = "homedecor:dvd_player 2",
			recipe = {
				{ "", "basic_materials:plastic_sheet", "" },
				{ "obsidian_glass", "basic_materials:motor", "basic_materials:motor" },
				{ "mese_crystal_fragment", "basic_materials:ic", "basic_materials:energy_crystal_simple" },
			},
		},
		{
			type = "shapeless",
			output = "homedecor:dvd_vcr",
			recipe = {
				"homedecor:vcr",
				"homedecor:dvd_player"
			},
		}
	}
})

local tel_cbox = {
	type = "fixed",
	fixed = { -0.25, -0.5, -0.1875, 0.25, -0.21, 0.15 }
}

homedecor.register("telephone", {
	mesh = "homedecor_telephone.obj",
	tiles = {
		"homedecor_telephone_dial.png",
		"homedecor_telephone_base.png",
		"homedecor_telephone_handset.png",
		"homedecor_telephone_cord.png",
	},
	inventory_image = "homedecor_telephone_inv.png",
	description = S("Telephone"),
	groups = {snappy=3, dig_tree = 2},
	selection_box = tel_cbox,
	walkable = false,
	_sound_def = {
		key = "node_sound_wood_defaults",
	},
	crafts = {
		{
			recipe = {
				{ "homedecor:speaker_driver", "basic_materials:copper_wire", "homedecor:speaker_driver" },
				{ "basic_materials:plastic_sheet", "steel_ingot", "basic_materials:plastic_sheet" },
				{ "steel_ingot", "steel_ingot", "steel_ingot" }
			},
		}
	}
})

-- craft items

minetest.register_craftitem(":homedecor:vcr", {
	description = S("VCR"),
	inventory_image = "homedecor_vcr.png"
})

minetest.register_craftitem(":homedecor:dvd_player", {
	description = S("DVD Player"),
	inventory_image = "homedecor_dvd_player.png"
})

minetest.register_craftitem(":homedecor:speaker_driver", {
	description = S("Speaker driver"),
	inventory_image = "homedecor_speaker_driver_inv.png"
})

--crafts

minetest.register_craft( {
	output = "basic_materials:ic 4",
	recipe = {
		{ "basic_materials:silicon", "basic_materials:silicon" },
		{ "basic_materials:silicon", "default:copper_ingot" },
	},
})

minetest.register_craft( {
	output = "homedecor:speaker_driver 2",
	recipe = {
		{ "", homedecor.materials["steel_ingot"], "" },
		{ homedecor.materials["paper"], "basic_materials:copper_wire", homedecor.materials["iron_lump"] },
		{ "", homedecor.materials["steel_ingot"], "" },
	},
})

minetest.register_craft({
	output = "homedecor:vcr 2",
	recipe = {
		{ "basic_materials:ic", homedecor.materials["steel_ingot"], "basic_materials:plastic_sheet" },
		{ homedecor.materials["iron_lump"], homedecor.materials["iron_lump"], homedecor.materials["iron_lump"] },
		{ "basic_materials:plastic_sheet", "", "basic_materials:plastic_sheet" },
	},
})

minetest.register_craft({
	type = "fuel",
	recipe = "homedecor:projection_screen",
	burntime = 30,
})