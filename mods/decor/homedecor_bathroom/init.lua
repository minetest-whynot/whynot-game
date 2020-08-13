local S = minetest.get_translator("homedecor_bathroom")

local sc_disallow = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil

minetest.register_node(":homedecor:bathroom_tiles_dark", {
	description = S("Bathroom/kitchen tiles (dark)"),
	tiles = {
		"homedecor_bathroom_tiles_bg.png"
	},
	overlay_tiles = {
		{ name = "homedecor_bathroom_tiles_fg.png", color = 0xff606060 },
	},
	paramtype = "light",
	paramtype2 = "color",
	palette = "unifieddyes_palette_extended.png",
	groups = {cracky=3, ud_param2_colorable = 1},
	sounds = default.node_sound_stone_defaults(),
	on_construct = unifieddyes.on_construct,
	on_dig = unifieddyes.on_dig,
})

minetest.register_node(":homedecor:bathroom_tiles_medium", {
	description = S("Bathroom/kitchen tiles (medium)"),
	tiles = {
		"homedecor_bathroom_tiles_bg.png"
	},
	overlay_tiles = {
		{ name = "homedecor_bathroom_tiles_fg.png", color = 0xffc0c0c0 },
	},
	paramtype = "light",
	paramtype2 = "color",
	palette = "unifieddyes_palette_extended.png",
	groups = {cracky=3, ud_param2_colorable = 1},
	sounds = default.node_sound_stone_defaults(),
	on_construct = unifieddyes.on_construct,
	on_dig = unifieddyes.on_dig,
})

minetest.register_node(":homedecor:bathroom_tiles_light", {
	description = S("Bathroom/kitchen tiles (light)"),
	tiles = {
		"homedecor_bathroom_tiles_bg.png"
	},
	overlay_tiles = {
			{ name = "homedecor_bathroom_tiles_fg.png", color = 0xffffffff },
	},
	paramtype = "light",
	paramtype2 = "color",
	palette = "unifieddyes_palette_extended.png",
	groups = {cracky=3, ud_param2_colorable = 1},
	sounds = default.node_sound_stone_defaults(),
	on_construct = unifieddyes.on_construct,
	on_dig = unifieddyes.on_dig,
})

local tr_cbox = {
	type = "fixed",
	fixed = { -0.375, -0.3125, 0.25, 0.375, 0.375, 0.5 }
}

homedecor.register("towel_rod", {
	description = S("Towel rod with towel"),
	mesh = "homedecor_towel_rod.obj",
	tiles = {
		"homedecor_generic_terrycloth.png",
		"default_wood.png",
	},
	inventory_image = "homedecor_towel_rod_inv.png",
	selection_box = tr_cbox,
	walkable = false,
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=3,flammable=3},
	sounds = default.node_sound_defaults(),
})

homedecor.register("medicine_cabinet", {
	description = S("Medicine cabinet"),
	mesh = "homedecor_medicine_cabinet.obj",
	tiles = {
		'default_wood.png',
		'homedecor_medicine_cabinet_mirror.png'
	},
	inventory_image = "homedecor_medicine_cabinet_inv.png",
	selection_box = {
		type = "fixed",
		fixed = {-0.3125, -0.1875, 0.3125, 0.3125, 0.5, 0.5}
	},
	walkable = false,
	groups = { snappy = 3 },
	sounds = default.node_sound_wood_defaults(),
	on_punch = function(pos, node, puncher, pointed_thing)
		node.name = "homedecor:medicine_cabinet_open"
		minetest.swap_node(pos, node)
	end,
	infotext=S("Medicine cabinet"),
	inventory = {
		size=6,
	},
})

homedecor.register("medicine_cabinet_open", {
	mesh = "homedecor_medicine_cabinet_open.obj",
	tiles = {
		'default_wood.png',
		'homedecor_medicine_cabinet_mirror.png',
		'homedecor_medicine_cabinet_inside.png'
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.3125, -0.1875, -0.25, 0.3125, 0.5, 0.5}
	},
	walkable = false,
	groups = { snappy = 3, not_in_creative_inventory=1 },
	drop = "homedecor:medicine_cabinet",
	on_punch = function(pos, node, puncher, pointed_thing)
		node.name = "homedecor:medicine_cabinet"
		minetest.swap_node(pos, node)
	end,
})

-- "Sanitation" related

local toilet_sbox = {
	type = "fixed",
	fixed = { -6/16, -8/16, -8/16, 6/16, 9/16, 8/16 },
}

local toilet_cbox = {
	type = "fixed",
	fixed = {
		{-6/16, -8/16, -8/16, 6/16, 1/16, 8/16 },
		{-6/16, -8/16, 4/16, 6/16, 9/16, 8/16 }
	}
}

homedecor.register("toilet", {
	description = S("Toilet"),
	mesh = "homedecor_toilet_closed.obj",
	tiles = {
		"building_blocks_marble.png",
		"building_blocks_marble.png",
		"building_blocks_marble.png",
		{ name = "homedecor_generic_metal.png", color = homedecor.color_med_grey }
	},
	selection_box = toilet_sbox,
	node_box = toilet_cbox,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		node.name = "homedecor:toilet_open"
		minetest.set_node(pos, node)
	end
})

homedecor.register("toilet_open", {
	mesh = "homedecor_toilet_open.obj",
	tiles = {
		"building_blocks_marble.png",
		"building_blocks_marble.png",
		"building_blocks_marble.png",
		"default_water.png",
		{ name = "homedecor_generic_metal.png", color = homedecor.color_med_grey }
	},
	selection_box = toilet_sbox,
	collision_box = toilet_cbox,
	drop = "homedecor:toilet",
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		node.name = "homedecor:toilet"
		minetest.set_node(pos, node)
		minetest.sound_play("homedecor_toilet_flush", {
			pos=pos,
			max_hear_distance = 5,
			gain = 1,
		})
	end
})

-- toilet paper :-)

local tp_cbox = {
	type = "fixed",
	fixed = { -0.25, 0.125, 0.0625, 0.1875, 0.4375, 0.5 }
}

homedecor.register("toilet_paper", {
	description = S("Toilet paper"),
	mesh = "homedecor_toilet_paper.obj",
	tiles = {
		"homedecor_generic_quilted_paper.png",
		"default_wood.png"
	},
	inventory_image = "homedecor_toilet_paper_inv.png",
	selection_box = tp_cbox,
	walkable = false,
	groups = {snappy=3,oddly_breakable_by_hand=3},
	sounds = default.node_sound_defaults(),
})

--Sink

local sink_sbox = {
	type = "fixed",
	fixed = { -5/16, -8/16, 1/16, 5/16, 8/16, 8/16 }
}

local sink_cbox = {
	type = "fixed",
	fixed = {
		{ -5/16,  5/16, 1/16, -4/16, 8/16, 8/16 },
		{  5/16,  5/16, 1/16,  4/16, 8/16, 8/16 },
		{ -5/16,  5/16, 1/16,  5/16, 8/16, 2/16 },
		{ -5/16,  5/16, 6/16,  5/16, 8/16, 8/16 },
		{ -4/16, -8/16, 1/16,  4/16, 5/16, 6/16 }
	}
}

homedecor.register("sink", {
	description = S("Bathroom Sink"),
	mesh = "homedecor_bathroom_sink.obj",
	tiles = {
		"building_blocks_marble.png",
		"building_blocks_marble.png",
		"default_water.png"
	},
	inventory_image="homedecor_bathroom_sink_inv.png",
	selection_box = sink_sbox,
	collision_box = sink_cbox,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
	on_destruct = function(pos)
		homedecor.stop_particle_spawner({x=pos.x, y=pos.y+1, z=pos.z})
	end
})

--Taps

local function taps_on_rightclick(pos, node, clicker, itemstack, pointed_thing)
	local below = minetest.get_node_or_nil({x=pos.x, y=pos.y-1, z=pos.z})
	if below and
	  below.name == "homedecor:shower_tray" or
	  below.name == "homedecor:sink" or
	  below.name == "homedecor:kitchen_cabinet_with_sink" or
	  below.name == "homedecor:kitchen_cabinet_with_sink_locked" then
		local particledef = {
			outlet      = { x = 0, y = -0.44, z = 0.28 },
			velocity_x  = { min = -0.1, max = 0.1 },
			velocity_y  = -0.3,
			velocity_z  = { min = -0.1, max = 0 },
			spread      = 0,
			die_on_collision = true,
		}
		homedecor.start_particle_spawner(pos, node, particledef, "homedecor_faucet")
	end
	return itemstack
end

homedecor.register("taps", {
	description = S("Bathroom taps/faucet"),
	mesh = "homedecor_bathroom_faucet.obj",
	tiles = {
		{ name = "homedecor_generic_metal.png", color = homedecor.color_med_grey },
		"homedecor_generic_metal_bright.png",
		"homedecor_generic_metal.png",
		"homedecor_generic_metal_bright.png"
	},
	inventory_image = "3dforniture_taps_inv.png",
	wield_image = "3dforniture_taps_inv.png",
	selection_box = {
		type = "fixed",
		fixed = { -4/16, -7/16, 4/16, 4/16, -4/16, 8/16 },
	},
	walkable = false,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
	on_rightclick = taps_on_rightclick,
	on_destruct = homedecor.stop_particle_spawner,
	on_rotate = sc_disallow or nil
})

homedecor.register("taps_brass", {
	description = S("Bathroom taps/faucet (brass)"),
	mesh = "homedecor_bathroom_faucet.obj",
	tiles = {
		"homedecor_generic_metal_brass.png",
		"homedecor_generic_metal_brass.png",
		"homedecor_generic_metal.png",
		"homedecor_generic_metal_brass.png"
	},
	inventory_image = "3dforniture_taps_brass_inv.png",
	wield_image = "3dforniture_taps_brass_inv.png",
	selection_box = {
		type = "fixed",
		fixed = { -4/16, -7/16, 4/16, 4/16, -4/16, 8/16 },
	},
	walkable = false,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
	on_rightclick = taps_on_rightclick,
	on_destruct = homedecor.stop_particle_spawner,
	on_rotate = sc_disallow or nil,
})

--Shower Tray

homedecor.register("shower_tray", {
	description = S("Shower Tray"),
	tiles = {
		"forniture_marble_base_ducha_top.png",
		"building_blocks_marble.png"
	},
	node_box = {
		type = "fixed",
		fixed = {
			{ -0.5, -0.5, -0.5, 0.5, -0.45, 0.5 },
			{ -0.5, -0.45, -0.5, 0.5, -0.4, -0.45 },
			{ -0.5, -0.45, 0.45, 0.5, -0.4, 0.5 },
			{ -0.5, -0.45, -0.45, -0.45, -0.4, 0.45 },
			{  0.45, -0.45, -0.45, 0.5, -0.4, 0.45 }
		},
	},
	selection_box = homedecor.nodebox.slab_y(0.1),
	groups = {cracky=2},
	sounds = default.node_sound_stone_defaults(),
	on_destruct = function(pos)
		homedecor.stop_particle_spawner({x=pos.x, y=pos.y+2, z=pos.z}) -- the showerhead
		homedecor.stop_particle_spawner({x=pos.x, y=pos.y+1, z=pos.z}) -- the taps, if any
	end
})

--Shower Head


local sh_cbox = {
	type = "fixed",
	fixed = { -0.2, -0.4, -0.05, 0.2, 0.1, 0.5 }
}

homedecor.register("shower_head", {
	drawtype = "mesh",
	mesh = "homedecor_shower_head.obj",
	tiles = {
		"homedecor_generic_metal.png",
		"homedecor_shower_head.png"
	},
	inventory_image = "homedecor_shower_head_inv.png",
	description = S("Shower Head"),
	groups = {snappy=3},
	selection_box = sh_cbox,
	walkable = false,
	on_rotate = sc_disallow or nil,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		local below = minetest.get_node_or_nil({x=pos.x, y=pos.y-2.0, z=pos.z})
		if below and (
			below.name == "homedecor:shower_tray" or
			below.name == "homedecor:bathtub_clawfoot_brass_taps" or
			below.name == "homedecor:bathtub_clawfoot_chrome_taps" ) then
			local particledef = {
				outlet      = { x = 0, y = -0.42, z = 0.1 },
				velocity_x  = { min = -0.15, max = 0.15 },
				velocity_y  = -2,
				velocity_z  = { min = -0.3,  max = 0.1 },
				spread      = 0.12
			}
			homedecor.start_particle_spawner(pos, node, particledef, "homedecor_shower")
		end
		return itemstack
	end,
	on_destruct = function(pos)
		homedecor.stop_particle_spawner(pos)
	end
})

local tub_sbox = {
	type = "fixed",
	fixed = { -0.5, -0.5, -0.5, 1.5, 0.3125, 0.5 },
}

local tub_cbox = {
	type = "fixed",
	fixed = {
		{-0.4375, -0.0625, -0.5, 1.4375, 0.5, -0.4375}, -- NodeBox1
		{-0.4375, -0.0625, 0.4375, 1.4375, 0.5, 0.5}, -- NodeBox2
		{-0.5, 0.1875, -0.4375, -0.4375, 0.5, 0.4375}, -- NodeBox3
		{1.4375, -0.0625, -0.4375, 1.5, 0.5, 0.4375}, -- NodeBox4
		{-0.3125, -0.3125, -0.4375, -0.125, -0.0625, 0.4375}, -- NodeBox5
		{1.375, -0.3125, -0.4375, 1.4375, -0.0625, 0.4375}, -- NodeBox6
		{-0.125, -0.3125, 0.375, 1.375, -0.0625, 0.4375}, -- NodeBox7
		{-0.125, -0.3125, -0.4375, 1.375, -0.0625, -0.375}, -- NodeBox8
		{-0.125, -0.5, -0.375, 1.375, -0.3125, 0.375}, -- NodeBox9
		{-0.4375, -0.0625, -0.4375, -0.3125, 0.1875, 0.4375}, -- NodeBox10
	}
}

homedecor.register("bathtub_clawfoot_brass_taps", {
	drawtype = "mesh",
	mesh = "homedecor_bathtub_clawfoot.obj",
	tiles = {
		{ name = "homedecor_generic_metal.png", color = homedecor.color_med_grey },
		"homedecor_generic_metal_bright.png",
		"homedecor_generic_metal_bright.png",
		"homedecor_generic_metal_brass.png",
		"building_blocks_marble.png",
		"homedecor_bathtub_clawfoot_bottom_inside.png",
	},
	description = S("Bathtub, clawfoot, with brass taps"),
	groups = {cracky=3},
	selection_box = tub_sbox,
	node_box = tub_cbox,
	sounds = default.node_sound_stone_defaults(),
})

homedecor.register("bathtub_clawfoot_chrome_taps", {
	drawtype = "mesh",
	mesh = "homedecor_bathtub_clawfoot.obj",
	tiles = {
		{ name = "homedecor_generic_metal.png", color = homedecor.color_med_grey },
		"homedecor_generic_metal_bright.png",
		"homedecor_generic_metal_bright.png",
		"homedecor_generic_metal_bright.png",
		"building_blocks_marble.png",
		"homedecor_bathtub_clawfoot_bottom_inside.png",
	},
	description = S("Bathtub, clawfoot, with chrome taps"),
	groups = {cracky=3},
	selection_box = tub_sbox,
	node_box = tub_cbox,
	sounds = default.node_sound_stone_defaults(),
})

local bs_cbox = {
	type = "fixed",
	fixed = { -8/16, -8/16, 1/16, 8/16, 8/16, 8/16 }
}

homedecor.register("bathroom_set", {
	drawtype = "mesh",
	mesh = "homedecor_bathroom_set.obj",
	tiles = {
		"homedecor_bathroom_set_mirror.png",
		"homedecor_bathroom_set_tray.png",
		"homedecor_bathroom_set_toothbrush.png",
		"homedecor_bathroom_set_cup.png",
		"homedecor_bathroom_set_toothpaste.png",
	},
	inventory_image = "homedecor_bathroom_set_inv.png",
	description = S("Bathroom sundries set"),
	groups = {snappy=3},
	selection_box = bs_cbox,
	walkable = false,
	sounds = default.node_sound_glass_defaults(),
})

-- aliases

minetest.register_alias("3dforniture:toilet", "homedecor:toilet")
minetest.register_alias("3dforniture:toilet_open", "homedecor:toilet_open")
minetest.register_alias("3dforniture:sink", "homedecor:sink")
minetest.register_alias("3dforniture:taps", "homedecor:taps")
minetest.register_alias("3dforniture:shower_tray", "homedecor:shower_tray")
minetest.register_alias("3dforniture:shower_head", "homedecor:shower_head")
minetest.register_alias("3dforniture:table_lamp", "homedecor:table_lamp_off")

minetest.register_alias("toilet", "homedecor:toilet")
minetest.register_alias("sink", "homedecor:sink")
minetest.register_alias("taps", "homedecor:taps")
minetest.register_alias("shower_tray", "homedecor:shower_tray")
minetest.register_alias("shower_head", "homedecor:shower_head")
minetest.register_alias("table_lamp", "homedecor:table_lamp_off")

-- convert old static nodes

local old_static_bathroom_tiles = {
	"homedecor:tiles_1",
	"homedecor:tiles_2",
	"homedecor:tiles_3",
	"homedecor:tiles_4",
	"homedecor:tiles_red",
	"homedecor:tiles_tan",
	"homedecor:tiles_yellow",
	"homedecor:tiles_green",
	"homedecor:tiles_blue"
}

local old_to_color = {
	"light_grey",
	"grey",
	"black",
	"black"
}

minetest.register_lbm({
	name = ":homedecor:convert_bathroom_tiles",
	label = "Convert bathroom tiles to use param2 color",
	run_at_every_load = false,
	nodenames = old_static_bathroom_tiles,
	action = function(pos, node)
		local name = node.name
		local newname = "homedecor:bathroom_tiles_light"
		local a = string.find(name, "_")
		local color = string.sub(name, a + 1)

		if color == "tan" then
			color = "yellow_s50"
		elseif color == "1" or color == "2" or color == "3" or color == "4" then
			if color == "4" then
				newname = "homedecor:bathroom_tiles_medium"
			end
			color = old_to_color[tonumber(color)]
		elseif color ~= "yellow" then
			color = color.."_s50"
		end

		local paletteidx = unifieddyes.getpaletteidx("unifieddyes:"..color, "extended")

		minetest.set_node(pos, { name = newname, param2 = paletteidx })
		local meta = minetest.get_meta(pos)
		meta:set_string("dye", "unifieddyes:"..color)
		meta:set_string("palette", "ext")
	end
})

-- crafting


minetest.register_craft({
    output = "homedecor:towel_rod",
    recipe = {
		{ "group:wood", "group:stick", "group:wood" },
		{ "", "building_blocks:terrycloth_towel", "" },
    },
})

minetest.register_craft({
    output = "homedecor:toilet_paper",
    recipe = {
		{ "", "default:paper", "default:paper" },
		{ "group:wood", "group:stick", "default:paper" },
		{ "", "default:paper", "default:paper" },
    },
})

minetest.register_craft({
    output = "homedecor:medicine_cabinet",
    recipe = {
		{ "group:stick", "default:glass", "group:stick" },
		{ "group:stick", "default:glass", "group:stick" },
		{ "group:stick", "default:glass", "group:stick" }
    },
})


-- bathroom/kitchen tiles

minetest.register_craft( {
		output = "homedecor:bathroom_tiles_light 4",
		recipe = {
			{ "group:marble", "group:marble" },
			{ "group:marble", "group:marble" }
		},
})

unifieddyes.register_color_craft({
	output = "homedecor:bathroom_tiles_light",
	palette = "extended",
	type = "shapeless",
	neutral_node = "homedecor:bathroom_tiles_light",
	recipe = {
		"NEUTRAL_NODE",
		"MAIN_DYE"
	}
})

minetest.register_craft( {
		output = "homedecor:bathroom_tiles_medium 4",
		recipe = {
			{ "group:marble", "group:marble", "" },
			{ "group:marble", "group:marble", "dye:grey" }
		},
})

unifieddyes.register_color_craft({
	output = "homedecor:bathroom_tiles_medium",
	palette = "extended",
	type = "shapeless",
	neutral_node = "homedecor:bathroom_tiles_medium",
	recipe = {
		"NEUTRAL_NODE",
		"MAIN_DYE"
	}
})

minetest.register_craft( {
		output = "homedecor:bathroom_tiles_dark 4",
		recipe = {
			{ "group:marble", "group:marble", "" },
			{ "group:marble", "group:marble", "dye:dark_grey" }
		},
})

unifieddyes.register_color_craft({
	output = "homedecor:bathroom_tiles_dark",
	palette = "extended",
	type = "shapeless",
	neutral_node = "homedecor:bathroom_tiles_dark",
	recipe = {
		"NEUTRAL_NODE",
		"MAIN_DYE"
	}
})

minetest.register_craft({
	output = "homedecor:bathroom_set",
	recipe = {
		{ "", "homedecor:glass_table_small_round", "" },
		{ "basic_materials:plastic_sheet", "homedecor:glass_table_small_round", "basic_materials:plastic_sheet" },
		{ "group:stick", "basic_materials:plastic_sheet", "group:stick" }
	},
})

minetest.register_craft({
	output = "homedecor:toilet",
	recipe = {
		{ "","","bucket:bucket_water"},
		{ "group:marble","group:marble", "group:marble" },
		{ "", "bucket:bucket_empty", "" },
	},
})

minetest.register_craft({
	output = "homedecor:sink",
	recipe = {
		{ "group:marble","bucket:bucket_empty", "group:marble" },
		{ "", "group:marble", "" }
	},
})

minetest.register_craft({
	output = "homedecor:taps",
	recipe = {
		{ "default:steel_ingot","bucket:bucket_water", "default:steel_ingot" },
	},
})

minetest.register_craft({
	output = "homedecor:taps_brass",
	recipe = {
		{ "basic_materials:brass_ingot","bucket:bucket_water", "basic_materials:brass_ingot" },
	},
})

minetest.register_craft({
	output = "homedecor:shower_tray",
	recipe = {
		{ "group:marble","bucket:bucket_empty", "group:marble" },
	},
})

minetest.register_craft({
	output = "homedecor:shower_head",
	recipe = {
		{"default:steel_ingot", "bucket:bucket_water"},
	},
})

minetest.register_craft({
	output = "homedecor:bathtub_clawfoot_brass_taps",
	recipe = {
		{ "homedecor:taps_brass", "", "" },
		{ "group:marble", "", "group:marble" },
		{ "default:steel_ingot", "group:marble", "default:steel_ingot"},
	},
})

minetest.register_craft({
	output = "homedecor:bathtub_clawfoot_chrome_taps",
	recipe = {
		{ "homedecor:taps", "", "" },
		{ "group:marble", "", "group:marble" },
		{"default:steel_ingot", "group:marble", "default:steel_ingot"},
	},
})

