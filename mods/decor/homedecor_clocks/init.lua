
local S = minetest.get_translator("homedecor_clocks")

local clock_sbox = {
	type = "fixed",
	fixed = { -8/32, -8/32, 14/32, 8/32, 8/32, 16/32 }
}

local clock_materials = {
	{ "plastic", S("Plastic analog clock"), "homedecor_generic_plastic.png" },
	{ "wood", S("Wooden analog clock"), "default_wood.png" }
}

for _, mat in ipairs(clock_materials) do
	local name, desc, tex = unpack(mat)
	homedecor.register("analog_clock_"..name, {
		description = desc,
		mesh = "homedecor_analog_clock.obj",
		tiles = {
			"homedecor_analog_clock_face.png",
			tex,
			"homedecor_analog_clock_back.png"
		},
		inventory_image = "homedecor_analog_clock_"..name.."_inv.png",
		walkable = false,
		selection_box = clock_sbox,
		groups = {snappy=3},
		sounds = default.node_sound_wood_defaults(),
	})
end

homedecor.register("digital_clock", {
	description = S("Digital clock"),
	tiles = {
		"homedecor_digital_clock_edges.png",
		"homedecor_digital_clock_edges.png",
		"homedecor_digital_clock_edges.png",
		"homedecor_digital_clock_edges.png",
		"homedecor_digital_clock_back.png",
		"homedecor_digital_clock_front.png"
	},
	inventory_image = "homedecor_digital_clock_inv.png",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.28125, -0.25, 0.4375, 0.3125, 0.25, 0.5},
		}
	},
	walkable = false,
	sounds = default.node_sound_wood_defaults(),
	groups = {snappy=3},
})

homedecor.register("alarm_clock", {
	description = S("Alarm clock"),
	tiles = {
		"homedecor_alarm_clock_top.png",
		"homedecor_alarm_clock_bottom.png",
		"homedecor_alarm_clock_sides.png",
		"homedecor_alarm_clock_sides.png^[transformFX",
		"homedecor_alarm_clock_back.png",
		"homedecor_alarm_clock_front.png"
	},
	inventory_image = "homedecor_alarm_clock_inv.png",
	node_box = {
		type = "fixed",
		fixed = {
			{ -9/32, -16/32, 7/32, 10/32, -5/32, 16/32 },
		}
	},
	walkable = false,
	sounds = default.node_sound_wood_defaults(),
	groups = {snappy=3},
})

local gf_cbox = {
	type = "fixed",
	fixed = { -7/16, -8/16, -7/16, 7/16, 24/16, 7/16 }
}

homedecor.register("grandfather_clock", {
	description = S("Grandfather Clock"),
	mesh = "homedecor_grandfather_clock.obj",
	tiles = {
		"default_glass.png",
		"homedecor_grandfather_clock_face.png",
		homedecor.lux_wood,
		"homedecor_grandfather_clock_face_edge.png",
		"homedecor_generic_metal_brass.png"
	},
	inventory_image = "homedecor_grandfather_clock_inv.png",
	groups = { snappy = 3 },
	selection_box = gf_cbox,
	collision_box = gf_cbox,
	sounds = default.node_sound_wood_defaults(),
	expand = { top="placeholder" },
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.rotate_simple or nil,
})

-- crafting


minetest.register_craft({
    output = "homedecor:analog_clock_plastic 2",
    recipe = {
		{ "basic_materials:plastic_sheet", "dye:black", "basic_materials:plastic_sheet" },
		{ "basic_materials:plastic_sheet", "basic_materials:ic", "basic_materials:plastic_sheet" },
		{ "basic_materials:plastic_sheet", "dye:black", "basic_materials:plastic_sheet" },
    },
})

minetest.register_craft({
    output = "homedecor:analog_clock_wood 2",
    recipe = {
		{ "group:stick", "dye:black", "group:stick" },
		{ "group:stick", "basic_materials:ic", "group:stick" },
		{ "group:stick", "dye:black", "group:stick" },
    },
})

minetest.register_craft({
    output = "homedecor:digital_clock 2",
    recipe = {
		{ "basic_materials:plastic_sheet", "default:paper", "basic_materials:plastic_sheet" },
		{ "basic_materials:plastic_sheet", "basic_materials:ic", "basic_materials:plastic_sheet" },
		{ "basic_materials:plastic_sheet", "basic_materials:energy_crystal_simple", "basic_materials:plastic_sheet" },
    },
})

minetest.register_craft({
    output = "homedecor:alarm_clock",
    recipe = {
		{ "basic_materials:plastic_sheet", "homedecor:speaker_driver", "basic_materials:plastic_sheet" },
		{ "basic_materials:plastic_sheet", "homedecor:digital_clock", "basic_materials:plastic_sheet" },
		{ "basic_materials:plastic_sheet", "basic_materials:energy_crystal_simple", "basic_materials:plastic_sheet" },
    },
})

minetest.register_craft({
	output = "homedecor:grandfather_clock",
	recipe = {
		{ "building_blocks:slab_hardwood","homedecor:analog_clock_wood","building_blocks:slab_hardwood" },
		{ "building_blocks:slab_hardwood","basic_materials:brass_ingot","building_blocks:slab_hardwood" },
		{ "building_blocks:slab_hardwood","basic_materials:brass_ingot","building_blocks:slab_hardwood" }
	},
})

-- aliases

minetest.register_alias("homedecor:grandfather_clock_bottom", "homedecor:grandfather_clock")
minetest.register_alias("homedecor:grandfather_clock_top", "air")
