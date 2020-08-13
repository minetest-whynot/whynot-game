-- This file adds fences of various types

local S = minetest.get_translator("homedecor_fences")

local materials = {
	{ S("brass"), "brass" },
	{ S("wrought iron"), "wrought_iron" },
}

for _, m in ipairs(materials) do

	local desc, name = unpack(m)

	homedecor.register("fence_"..name, {
		description = S("Fence/railing (@1)", desc),
		drawtype = "fencelike",
		tiles = {"homedecor_generic_metal_"..name..".png"},
		inventory_image = "homedecor_fence_"..name..".png",
		selection_box = homedecor.nodebox.bar_y(1/7),
		groups = {snappy=3},
		sounds = default.node_sound_wood_defaults(),
	})

end

-- other types of fences

homedecor.register("fence_picket", {
	description = S("Unpainted Picket Fence"),
	tiles = {
		"homedecor_blanktile.png",
		"homedecor_blanktile.png",
		"homedecor_fence_picket.png",
		"homedecor_fence_picket.png",
		"homedecor_fence_picket_backside.png",
		"homedecor_fence_picket.png"
	},
	groups = {snappy=3},
	sounds = default.node_sound_wood_defaults(),
	selection_box = homedecor.nodebox.slab_z(-0.1),
	node_box = homedecor.nodebox.slab_z(-0.002),
})

homedecor.register("fence_picket_corner", {
	description = S("Unpainted Picket Fence Corner"),
	tiles = {
		"homedecor_blanktile.png",
		"homedecor_blanktile.png",
		"homedecor_fence_picket.png",
		"homedecor_fence_picket_backside.png",
		"homedecor_fence_picket_backside.png",
		"homedecor_fence_picket.png",
	},
	groups = {snappy=3},
	sounds = default.node_sound_wood_defaults(),
	selection_box = homedecor.nodebox.corner_xz(0.1, -0.1),
	node_box = homedecor.nodebox.corner_xz(0.002, -0.002),
})

homedecor.register("fence_picket_white", {
	description = S("White Picket Fence"),
	tiles = {
		"homedecor_blanktile.png",
		"homedecor_blanktile.png",
		"homedecor_fence_picket_white.png",
		"homedecor_fence_picket_white.png",
		"homedecor_fence_picket_white_backside.png",
		"homedecor_fence_picket_white.png"
	},
	groups = {snappy=3},
	sounds = default.node_sound_wood_defaults(),
	selection_box = homedecor.nodebox.slab_z(-0.1),
	node_box = homedecor.nodebox.slab_z(-0.002),
})

homedecor.register("fence_picket_corner_white", {
	description = S("White Picket Fence Corner"),
	tiles = {
		"homedecor_blanktile.png",
		"homedecor_blanktile.png",
		"homedecor_fence_picket_white.png",
		"homedecor_fence_picket_white_backside.png",
		"homedecor_fence_picket_white_backside.png",
		"homedecor_fence_picket_white.png",
	},
	groups = {snappy=3},
	sounds = default.node_sound_wood_defaults(),
	selection_box = homedecor.nodebox.corner_xz(0.1, -0.1),
	node_box = homedecor.nodebox.corner_xz(0.002, -0.002),
})

homedecor.register("fence_privacy", {
	description = S("Wooden Privacy Fence"),
	tiles = {
		"homedecor_fence_privacy_tb.png",
		"homedecor_fence_privacy_tb.png",
		"homedecor_fence_privacy_sides.png",
		"homedecor_fence_privacy_sides.png",
		"homedecor_fence_privacy_backside.png",
		"homedecor_fence_privacy_front.png"
	},
	groups = {snappy=3},
	sounds = default.node_sound_wood_defaults(),
	selection_box = homedecor.nodebox.slab_z(-3/16),
	node_box = {
		type = "fixed",
		fixed = {
			{ -8/16, -8/16, 5/16, -5/16,  8/16, 7/16 },	-- left part
			{ -4/16, -8/16, 5/16,  3/16,  8/16, 7/16 },	-- middle part
			{  4/16, -8/16, 5/16,  8/16,  8/16, 7/16 },	-- right part
			{ -8/16, -2/16, 7/16,  8/16,  2/16, 8/16 },	-- connecting rung
		}
	},
})

homedecor.register("fence_privacy_corner", {
	description = S("Wooden Privacy Fence Corner"),
	tiles = {
		"homedecor_fence_privacy_corner_tb.png",
		"homedecor_fence_privacy_corner_tb.png^[transformFY",
		"homedecor_fence_privacy_corner_right.png",
		"homedecor_fence_privacy_backside2.png",
		"homedecor_fence_privacy_backside.png",
		"homedecor_fence_privacy_corner_front.png"
	},
	groups = {snappy=3},
	sounds = default.node_sound_wood_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {
			homedecor.box.slab_z(-3/16),
			{ -0.5, -0.5, -0.5, -5/16, 0.5, 5/16 },
		}
	},
	node_box = {
		type = "fixed",
		fixed = {
			{ -7/16, -8/16, 5/16, -5/16, 8/16, 7/16 },	-- left part
			{ -4/16, -8/16, 5/16,  3/16, 8/16, 7/16 },	-- middle part
			{  4/16, -8/16, 5/16,  8/16, 8/16, 7/16 },	-- right part
			{ -8/16, -2/16, 7/16,  8/16, 2/16, 8/16 },	-- back-side connecting rung

			{ -7/16, -8/16,  4/16, -5/16, 8/16,  7/16 },	-- back-most part
			{ -7/16, -8/16, -4/16, -5/16, 8/16,  3/16 },	-- middle part
			{ -7/16, -8/16, -8/16, -5/16, 8/16, -5/16 },	-- front-most part
			{ -8/16, -2/16, -8/16, -7/16, 2/16,  7/16 },	-- left-side connecting rung
		}
	},
})

homedecor.register("fence_barbed_wire", {
	description = S("Barbed Wire Fence"),
	mesh = "homedecor_fence_barbed_wire.obj",
	tiles = {"homedecor_fence_barbed_wire.png"},
	groups = {snappy=3},
	sounds = default.node_sound_wood_defaults(),
	selection_box = homedecor.nodebox.slab_z(-0.125),
	collision_box = homedecor.nodebox.slab_z(-0.125),
})

homedecor.register("fence_barbed_wire_corner", {
	description = S("Barbed Wire Fence Corner"),
	mesh = "homedecor_fence_barbed_wire_corner.obj",
	tiles = { "homedecor_fence_barbed_wire.png" },
	groups = {snappy=3},
	sounds = default.node_sound_wood_defaults(),
	selection_box = homedecor.nodebox.corner_xz(0.125, -0.125),
	collision_box = homedecor.nodebox.corner_xz(0.125, -0.125),
})

homedecor.register("fence_chainlink", {
	description = S("Chainlink Fence"),
	mesh="homedecor_fence_chainlink.obj",
	tiles = {
		"homedecor_fence_chainlink_tb.png",
		"homedecor_fence_chainlink_tb.png",
		"homedecor_fence_chainlink_sides.png",
		"homedecor_fence_chainlink_sides.png",
		"homedecor_fence_chainlink_fb.png",
		"homedecor_fence_chainlink_fb.png",
	},
	groups = {snappy=3},
	sounds = default.node_sound_wood_defaults(),
	selection_box = homedecor.nodebox.slab_z(-0.125),
	collision_box = homedecor.nodebox.slab_z(-0.125),
})


homedecor.register("fence_chainlink_corner", {
	description = S("Chainlink Fence Corner"),
	mesh = "homedecor_fence_chainlink_corner.obj",
	tiles = {
		"homedecor_fence_chainlink_corner_top.png",
		"homedecor_fence_chainlink_corner_top.png",
		"homedecor_fence_chainlink_corner_front.png",
		"homedecor_fence_chainlink_corner_front.png",
		"homedecor_fence_chainlink_corner_front.png",
		"homedecor_fence_chainlink_corner_front.png",
	},
	groups = {snappy=3},
	sounds = default.node_sound_wood_defaults(),
	selection_box = homedecor.nodebox.corner_xz(0.125, -0.125),
	collision_box = homedecor.nodebox.corner_xz(0.125, -0.125),
})

homedecor.register("fence_wrought_iron_2", {
	description = S("Wrought Iron fence (type 2)"),
	tiles = {
		"homedecor_fence_wrought_iron_2_tb.png",
		"homedecor_fence_wrought_iron_2_tb.png",
		"homedecor_fence_wrought_iron_2_sides.png",
		"homedecor_fence_wrought_iron_2_sides.png",
		"homedecor_fence_wrought_iron_2_fb.png",
		"homedecor_fence_wrought_iron_2_fb.png"
	},
	groups = {snappy=3},
	sounds = default.node_sound_wood_defaults(),
	selection_box = homedecor.nodebox.slab_z(-0.08),
	node_box = {
		type = "fixed",
		fixed = {
			{ -8/16, -8/16,  14/32, -7.75/16,  8/16,  16/32 }, -- left post
			{  7.75/16, -8/16,  14/32,  8/16,  8/16,  16/32 }, -- right post
			{ -8/16,  7.75/16, 14/32,  8/16,  8/16, 16/32 }, -- top piece
			{ -8/16,  -0.015625, 14.75/32,  8/16,  0.015625, 15.25/32 }, -- cross piece
			{ -0.015625, -8/16,  14.75/32,  0.015625,  8/16,  15.25/32 }, -- cross piece
			{ -8/16, -8/16, 14/32,  8/16, -7.75/16, 16/32 }, -- bottom piece
			{ -8/16, -8/16,  15/32,  8/16,  8/16,  15/32 }	-- the grid itself
		}
	},
})

homedecor.register("fence_wrought_iron_2_corner", {
	description = S("Wrought Iron fence (type 2) Corner"),
	tiles = {
		"homedecor_fence_corner_wrought_iron_2_tb.png",
		"homedecor_fence_corner_wrought_iron_2_tb.png",
		"homedecor_fence_corner_wrought_iron_2_sides.png^[transformFX",
		"homedecor_fence_corner_wrought_iron_2_sides.png",
		"homedecor_fence_corner_wrought_iron_2_sides.png^[transformFX",
		"homedecor_fence_corner_wrought_iron_2_sides.png"
	},
	groups = {snappy=3},
	sounds = default.node_sound_wood_defaults(),
	selection_box = homedecor.nodebox.corner_xz(0.08, -0.08),
	node_box = {
		type = "fixed",
		fixed = {
			{ -0.5, -0.5, 0.453125, -0.453125, 0.5, 0.5 }, -- corner edge
			{ -7.5/16,  7.75/16, 14/32,  8/16,  8/16, 16/32 },	-- top piece
			{ -7.5/16, -8/16, 14/32,  8/16, -7.75/16, 16/32 },	-- bottom piece
			{ -16/32,  7.75/16, -8/16, -14/32,  8/16,  8/16 },	-- top piece, side
			{ -16/32, -8/16, -8/16, -14/32, -7.75/16,  8/16 },	-- bottom piece, side
			{ -7.5/16, -8/16,  7.5/16,  8/16,  8/16,  7.5/16 },	-- the grid itself
			{ -7.5/16, -8/16, -8/16,  -7.5/16,  8/16,  7.5/16 },	-- the grid itself, side
			{ -15.5/32, -0.5, -0.5, -14.5/32, 0.5, -0.484375 }, -- left post side
			{  7.75/16, -8/16,  14.5/32,  8/16,  8/16,  15.5/32 }, -- right post
			{ -8/16,  -0.015625, 14.75/32,  8/16,  0.015625, 15.25/32 }, -- cross piece
			{ -0.015625, -8/16,  14.75/32,  0.015625,  8/16,  15.25/32 }, -- cross piece
			{ -15.25/32, -0.5, -0.015625, -14.75/32, 0.5, 0.015625 }, -- cross piece side
			{ -15.25/32, -0.015625, -0.5, -14.75/32, 0.015625, 0.5 } -- cross piece side
		}
	},
})

-- insert the old wood signs-on-metal-fences into signs_lib's conversion LBM
if minetest.get_modpath("signs_lib") then
	-- FIXME: export a function in signs_lib API to allow signs_lib to be read only in .luacheckrc
	table.insert(signs_lib.old_fenceposts_with_signs, "homedecor:fence_brass_with_sign")
	signs_lib.old_fenceposts["homedecor:fence_brass_with_sign"] = "homedecor:fence_brass"
	signs_lib.old_fenceposts_replacement_signs["homedecor:fence_brass_with_sign"] = "default:sign_wall_wood_onpole"

	table.insert(signs_lib.old_fenceposts_with_signs, "homedecor:fence_wrought_iron_with_sign")
	signs_lib.old_fenceposts["homedecor:fence_wrought_iron_with_sign"] = "homedecor:fence_wrought_iron"
	signs_lib.old_fenceposts_replacement_signs["homedecor:fence_wrought_iron_with_sign"] = "default:sign_wall_wood_onpole"
end

-- crafting

-- Brass/wrought iron fences

minetest.register_craft( {
        output = "homedecor:fence_brass 6",
	recipe = {
		{ "basic_materials:brass_ingot", "basic_materials:brass_ingot", "basic_materials:brass_ingot" },
		{ "basic_materials:brass_ingot", "basic_materials:brass_ingot", "basic_materials:brass_ingot" },
	},
})

minetest.register_craft( {
	output = "homedecor:fence_wrought_iron 6",
	recipe = {
		{ "default:iron_lump","default:iron_lump","default:iron_lump" },
		{ "default:iron_lump","default:iron_lump","default:iron_lump" },
	},
})

-- other types of fences

minetest.register_craft( {
	output = "homedecor:fence_wrought_iron_2 4",
	recipe = {
		{ "homedecor:pole_wrought_iron", "default:iron_lump" },
		{ "homedecor:pole_wrought_iron", "default:iron_lump" },
	},
})

minetest.register_craft( {
	type = "shapeless",
	output = "homedecor:fence_wrought_iron_2_corner",
	recipe = {
		"homedecor:fence_wrought_iron_2",
		"homedecor:fence_wrought_iron_2"
	},
})

minetest.register_craft( {
	type = "shapeless",
	output = "homedecor:fence_wrought_iron_2 2",
	recipe = {
		"homedecor:fence_wrought_iron_2_corner",
	},
})

--

minetest.register_craft( {
	output = "homedecor:fence_picket 6",
	recipe = {
		{ "group:stick", "group:stick", "group:stick" },
		{ "group:stick", "", "group:stick" },
		{ "group:stick", "group:stick", "group:stick" }
	},
})

minetest.register_craft( {
	type = "shapeless",
	output = "homedecor:fence_picket_corner",
	recipe = {
		"homedecor:fence_picket",
		"homedecor:fence_picket"
	},
})

minetest.register_craft( {
	type = "shapeless",
	output = "homedecor:fence_picket 2",
	recipe = {
		"homedecor:fence_picket_corner"
	},
})

--


minetest.register_craft( {
	output = "homedecor:fence_picket_white 6",
	recipe = {
		{ "group:stick", "group:stick", "group:stick" },
		{ "group:stick", "dye:white", "group:stick" },
		{ "group:stick", "group:stick", "group:stick" }
	},
})

minetest.register_craft( {
	type = "shapeless",
	output = "homedecor:fence_picket_corner_white",
	recipe = {
		"homedecor:fence_picket_white",
		"homedecor:fence_picket_white"
	},
})

minetest.register_craft( {
	type = "shapeless",
	output = "homedecor:fence_picket_white 2",
	recipe = {
		"homedecor:fence_picket_corner_white"
	},
})

--


minetest.register_craft( {
	output = "homedecor:fence_privacy 6",
	recipe = {
		{ "group:wood", "group:stick", "group:wood" },
		{ "group:wood", "", "group:wood" },
		{ "group:wood", "group:stick", "group:wood" }
	},
})

minetest.register_craft( {
	type = "shapeless",
	output = "homedecor:fence_privacy_corner",
	recipe = {
		"homedecor:fence_privacy",
		"homedecor:fence_privacy"
	},
})

minetest.register_craft( {
	type = "shapeless",
	output = "homedecor:fence_privacy 2",
	recipe = {
		"homedecor:fence_privacy_corner"
	},
})

--


minetest.register_craft( {
	output = "homedecor:fence_barbed_wire 6",
	recipe = {
		{ "group:stick", "basic_materials:steel_wire", "group:stick" },
		{ "group:stick", "", "group:stick" },
		{ "group:stick", "basic_materials:steel_wire", "group:stick" }
	},
})

minetest.register_craft( {
	type = "shapeless",
	output = "homedecor:fence_barbed_wire_corner",
	recipe = { "homedecor:fence_barbed_wire", "homedecor:fence_barbed_wire" },
})

minetest.register_craft( {
	type = "shapeless",
	output = "homedecor:fence_barbed_wire 2",
	recipe = { "homedecor:fence_barbed_wire_corner" },
})

--

minetest.register_craft( {
	output = "homedecor:fence_chainlink 9",
	recipe = {
		{ "default:steel_ingot", "default:steel_ingot", "default:steel_ingot" },
		{ "basic_materials:steel_wire", "basic_materials:steel_wire", "default:steel_ingot" },
		{ "basic_materials:steel_wire", "basic_materials:steel_wire", "default:steel_ingot" }
	},
})

minetest.register_craft( {
	type = "shapeless",
	output = "homedecor:fence_chainlink_corner",
	recipe = { "homedecor:fence_chainlink", "homedecor:fence_chainlink" },
})

minetest.register_craft( {
	type = "shapeless",
	output = "homedecor:fence_chainlink 2",
	recipe = { "homedecor:fence_chainlink_corner" },
})
