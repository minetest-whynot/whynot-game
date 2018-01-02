local slope_cbox = {
	type = "fixed",
	fixed = {
		{-0.5,  -0.5,  -0.5, 0.5, -0.25, 0.5},
		{-0.5, -0.25, -0.25, 0.5,     0, 0.5},
		{-0.5,     0,     0, 0.5,  0.25, 0.5},
		{-0.5,  0.25,  0.25, 0.5,   0.5, 0.5}
	}
}

local slope_cbox_long = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5,   -1.5,  0.5, -0.375, 0.5},  --  NodeBox1
		{-0.5, -0.375, -1.25, 0.5, -0.25,  0.5},  --  NodeBox2
		{-0.5, -0.25,  -1,    0.5, -0.125, 0.5},  --  NodeBox3
		{-0.5, -0.125, -0.75, 0.5,  0,     0.5},  --  NodeBox4
		{-0.5,  0,     -0.5,  0.5,  0.125, 0.5},  --  NodeBox5
		{-0.5,  0.125, -0.25, 0.5,  0.25,  0.5},  --  NodeBox6
		{-0.5,  0.25,   0,    0.5,  0.375, 0.5},  --  NodeBox7
		{-0.5,  0.375,  0.25, 0.5,  0.5,   0.5},  --  NodeBox8
	}
}

local icorner_cbox = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5, -0.5, 0.5, -0.25, 0.5}, -- NodeBox5
		{-0.5, -0.5, -0.25, 0.5, 0, 0.5}, -- NodeBox6
		{-0.5, -0.5, -0.5, 0.25, 0, 0.5}, -- NodeBox7
		{-0.5, 0, -0.5, 0, 0.25, 0.5}, -- NodeBox8
		{-0.5, 0, 0, 0.5, 0.25, 0.5}, -- NodeBox9
		{-0.5, 0.25, 0.25, 0.5, 0.5, 0.5}, -- NodeBox10
		{-0.5, 0.25, -0.5, -0.25, 0.5, 0.5}, -- NodeBox11
	}
}

local ocorner_cbox = {
	type = "fixed",
	fixed = {
		{-0.5,  -0.5,  -0.5,   0.5, -0.25, 0.5},
		{-0.5, -0.25, -0.25,  0.25,     0, 0.5},
		{-0.5,     0,     0,     0,  0.25, 0.5},
		{-0.5,  0.25,  0.25, -0.25,   0.5, 0.5}
	}
}

local icorner_cbox_long = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5, -1.5, -0.25, 0.5, 0.5},
		{-0.5, -0.5, 0.25, 1.5, 0.5, 0.5},
		{-0.5, -0.5, 0, 1.5, 0.375, 0.5},
		{-0.5, -0.5, -1.5, 0, 0.375, 0.5},
		{-0.5, -0.5, -1.5, 0.25, 0.25, 0.5},
		{-0.5, -0.5, -1.5, 0.5, 0.125, 0.5},
		{-0.5, -0.5, -1.5, 0.75, 0, 0.5},
		{-0.5, -0.5, -1.5, 1, -0.125, 0.5},
		{-0.5, -0.5, -1.5, 1.25, -0.25, 0.5},
		{-0.5, -0.5, -1.5, 1.5, -0.375, 0.5},
		{-0.5, -0.5, -0.25, 1.5, 0.25, 0.5},
		{-0.5, -0.5, -0.5, 1.5, 0.125, 0.5}, 
		{-0.5, -0.5, -0.75, 1.5, 0, 0.5},
		{-0.5, -0.5, -1, 1.5, -0.125, 0.5},
		{-0.5, -0.5, -1.25, 1.5, -0.25, 0.5},
	}
}

local ocorner_cbox_long = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5, 0.25, -0.25, 0.5, 0.5},
		{-0.5, -0.5, 0, 0, 0.375, 0.5},
		{-0.5, -0.5, -0.25, 0.25, 0.25, 0.5},
		{-0.5, -0.5, -0.5, 0.5, 0.125, 0.5}, 
		{-0.5, -0.5, -0.75, 0.75, 0, 0.5}, 
		{-0.5, -0.5, -1, 1, -0.125, 0.5}, 
		{-0.5, -0.5, -1.25, 1.25, -0.25, 0.5}, 
		{-0.5, -0.5, -1.5, 1.5, -0.375, 0.5},
	}
}

local asphalt_slope = { --desc, color, img
	{"Grey", "grey"},
	{"Dark Grey", "dark_grey"},
	{"Red", "red"},
	{"Green", "green"},
--	{"Grey Round", "grey_round"},
--	{"Dark Grey Round", "dark_grey_round"},
}
for i in ipairs (asphalt_slope) do
	local desc = asphalt_slope[i][1]
	local color = asphalt_slope[i][2]


--Slope
minetest.register_node("myroofs:asphalt_shingle_"..color, {
	description = desc.." Asphalt Shingle",
	drawtype = "mesh",
	mesh = "twelve-twelve.obj",
	tiles = {"myroofs_asphalt_shingle_"..color..".png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=3},
	sounds = default.node_sound_wood_defaults(),
--	on_place = minetest.rotate_node,
	collision_box = slope_cbox,
	selection_box = slope_cbox
})

--Outside Corner
minetest.register_node("myroofs:asphalt_shingle_"..color.."_ocorner", {
	description = desc.." Asphalt Shingle Outside Corner",
	drawtype = "mesh",
	mesh = "twelve-twelve-oc.obj",
	tiles = {"myroofs_asphalt_shingle_"..color..".png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=3},
	sounds = default.node_sound_wood_defaults(),
--	on_place = minetest.rotate_node,
	collision_box = ocorner_cbox,
	selection_box = ocorner_cbox
})

--Inside Corner
minetest.register_node("myroofs:asphalt_shingle_"..color.."_icorner", {
	description = desc.." Asphalt Shingle Inside Corner",
	drawtype = "mesh",
	mesh = "twelve-twelve-ic.obj",
	tiles = {"myroofs_asphalt_shingle_"..color..".png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=3},
	sounds = default.node_sound_wood_defaults(),
--	on_place = minetest.rotate_node,
	collision_box = icorner_cbox,
	selection_box = icorner_cbox
})
end
local asphalt_lslope = { --desc, color, img
	{"Grey", "grey"},
	{"Dark Grey", "dark_grey"},
	{"Red", "red"},
	{"Green", "green"},
	{"Grey Round", "grey_round"},
	{"Dark Grey Round", "dark_grey_round"},
}
for i in ipairs (asphalt_lslope) do
	local desc = asphalt_lslope[i][1]
	local color = asphalt_lslope[i][2]

--Long slope
minetest.register_node("myroofs:asphalt_shingle_"..color.."_long", {
	description = desc.." Asphalt Shingle Long",
	drawtype = "mesh",
	mesh = "six-twelve_slope.obj",
	tiles = {"myroofs_asphalt_shingle_"..color..".png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=3},
	sounds = default.node_sound_wood_defaults(),
--	on_place = minetest.rotate_node,
	collision_box = slope_cbox_long,
	selection_box = slope_cbox_long
})

--Long Inside Corner
minetest.register_node("myroofs:asphalt_shingle_"..color.."_long_icorner", {
	description = desc.." Asphalt Shingle Long Inside Corner",
	drawtype = "mesh",
	mesh = "six-twelve_slope-ic.obj",
	tiles = {"myroofs_asphalt_shingle_"..color..".png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=3},
	sounds = default.node_sound_wood_defaults(),
--	on_place = minetest.rotate_node,
	collision_box = icorner_cbox_long,
	selection_box = icorner_cbox_long
})

--Long Outside Corner
minetest.register_node("myroofs:asphalt_shingle_"..color.."_long_ocorner", {
	description = desc.." Asphalt Shingle Long Outside Corner",
	drawtype = "mesh",
	mesh = "six-twelve_slope-oc.obj",
	tiles = {"myroofs_asphalt_shingle_"..color..".png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=3},
	sounds = default.node_sound_wood_defaults(),
--	on_place = minetest.rotate_node,
	collision_box = ocorner_cbox_long,
	selection_box = ocorner_cbox_long
})

end

-----------------------------------------------------------------------------
--Crafts
-----------------------------------------------------------------------------
local craft_slope = { --desc, color, img
	{"Grey", "grey"},
	{"Dark Grey", "dark_grey"},
	{"Red", "red"},
	{"Green", "green"},
--	{"Grey Round", "grey_round"},
--	{"Dark Grey Round", "dark_grey_round"},
}
for i in ipairs (craft_slope) do
	local desc = craft_slope[i][1]
	local color = craft_slope[i][2]

--Slope
minetest.register_craft({
	output = "myroofs:asphalt_shingle_"..color.." 2",
	recipe = {
		{"", "",""},
		{"", "","myroofs:asphalt_shingle_"..color.."_bundle"},
		{"", "myroofs:asphalt_shingle_"..color.."_bundle","myroofs:asphalt_shingle_"..color.."_bundle"},
	}
})

--Inside Corner
minetest.register_craft({
	output = "myroofs:asphalt_shingle_"..color.."_icorner 3",
	recipe = {
		{"", "",""},
		{"myroofs:asphalt_shingle_"..color.."_bundle", "",""},
		{"myroofs:asphalt_shingle_"..color.."_bundle", "myroofs:asphalt_shingle_"..color.."_bundle",""},
	}
})
--Outside Corner
minetest.register_craft({
	output = "myroofs:asphalt_shingle_"..color.."_ocorner 3",
	recipe = {
		{"", "", ""},
		{"", "myroofs:asphalt_shingle_"..color.."_bundle", ""},
		{"myroofs:asphalt_shingle_"..color.."_bundle", "", "myroofs:asphalt_shingle_"..color.."_bundle"},
	}
})
end

local craft_lslope = { --desc, color, img
	{"Grey", "grey"},
	{"Dark Grey", "dark_grey"},
	{"Red", "red"},
	{"Green", "green"},
	{"Grey Round", "grey_round"},
	{"Dark Grey Round", "dark_grey_round"},
}
for i in ipairs (craft_lslope) do
	local desc = craft_lslope[i][1]
	local color = craft_lslope[i][2]

--Long Slope
minetest.register_craft({
	output = "myroofs:asphalt_shingle_"..color.."_long 3",
	recipe = {
		{"", "",""},
		{"", "myroofs:asphalt_shingle_"..color.."_bundle","myroofs:asphalt_shingle_"..color.."_bundle"},
		{"myroofs:asphalt_shingle_"..color.."_bundle", "myroofs:asphalt_shingle_"..color.."_bundle","myroofs:asphalt_shingle_"..color.."_bundle"},
	}
})
--Long Inside Corner
minetest.register_craft({
	output = "myroofs:asphalt_shingle_"..color.."_long_icorner 2",
	recipe = {
		{"", "","myroofs:asphalt_shingle_"..color.."_bundle"},
		{"", "","myroofs:asphalt_shingle_"..color.."_bundle"},
		{"myroofs:asphalt_shingle_"..color.."_bundle", "myroofs:asphalt_shingle_"..color.."_bundle","myroofs:asphalt_shingle_"..color.."_bundle"},
	}
})
--Long Outside Corner
minetest.register_craft({
	output = "myroofs:asphalt_shingle_"..color.."_long_ocorner 2",
	recipe = {
		{"","myroofs:asphalt_shingle_"..color.."_bundle", ""},
		{"", "myroofs:asphalt_shingle_"..color.."_bundle", ""},
		{"myroofs:asphalt_shingle_"..color.."_bundle", "myroofs:asphalt_shingle_"..color.."_bundle","myroofs:asphalt_shingle_"..color.."_bundle"},
	}
})

end
