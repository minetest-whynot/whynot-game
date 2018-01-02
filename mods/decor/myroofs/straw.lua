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

local straw_slope = { --desc, color, item
	{"Straw", "straw", "farming:straw"},
	{"Dark Straw", "straw_dark", "myroofs:straw_dark"},
	{"Reet", "reet", "myroofs:reet"},
	{"Copper", "copper", "myroofs:copper_roofing"},
	{"Green Copper","green_copper","myroofs:green_copper_roofing"},
}
for i in ipairs (straw_slope) do
	local desc = straw_slope[i][1]
	local color = straw_slope[i][2]
	local item = straw_slope[i][3]
--Slope
minetest.register_node("myroofs:"..color.."_roof", {
	description = desc.." Roof",
	drawtype = "mesh",
	mesh = "twelve-twelve.obj",
	tiles = {"myroofs_"..color..".png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=3},
	sounds = default.node_sound_wood_defaults(),
--	on_place = minetest.rotate_node,
	collision_box = slope_cbox,
	selection_box = slope_cbox
})

--Outside Corner
minetest.register_node("myroofs:"..color.."_roof_ocorner", {
	description = desc.." Roof Outside Corner",
	drawtype = "mesh",
	mesh = "twelve-twelve-oc.obj",
	tiles = {"myroofs_"..color..".png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=3},
	sounds = default.node_sound_wood_defaults(),
--	on_place = minetest.rotate_node,
	collision_box = ocorner_cbox,
	selection_box = ocorner_cbox
})

--Inner Corner
minetest.register_node("myroofs:"..color.."_roof_icorner", {
	description = desc.." Roof Inside Corner",
	drawtype = "mesh",
	mesh = "twelve-twelve-ic.obj",
	tiles = {"myroofs_"..color..".png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=3},
	sounds = default.node_sound_wood_defaults(),
--	on_place = minetest.rotate_node,
	collision_box = icorner_cbox,
	selection_box = icorner_cbox
})

--Long Slope
minetest.register_node("myroofs:"..color.."_roof_long", {
	description = desc.." Roof Long",
	drawtype = "mesh",
	mesh = "six-twelve_slope.obj",
	tiles = {"myroofs_"..color..".png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=3},
	sounds = default.node_sound_wood_defaults(),
--	on_place = minetest.rotate_node,
	collision_box = slope_cbox_long,
	selection_box = slope_cbox_long
})

--Long Inner Corner
minetest.register_node("myroofs:"..color.."_roof_long_icorner", {
	description = desc.." Roof Long Inside Corner",
	drawtype = "mesh",
	mesh = "six-twelve_slope-ic.obj",
	tiles = {"myroofs_"..color..".png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=3},
	sounds = default.node_sound_wood_defaults(),
--	on_place = minetest.rotate_node,
	collision_box = icorner_cbox_long,
	selection_box = icorner_cbox_long
})

--Long Outside Corner
minetest.register_node("myroofs:"..color.."_roof_long_ocorner", {
	description = desc.." Roof Long Outside Corner",
	drawtype = "mesh",
	mesh = "six-twelve_slope-oc.obj",
	tiles = {"myroofs_"..color..".png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=3},
	sounds = default.node_sound_wood_defaults(),
--	on_place = minetest.rotate_node,
	collision_box = ocorner_cbox_long,
	selection_box = ocorner_cbox_long
})

------------------------------------------------------------------------------------
--Crafts
------------------------------------------------------------------------------------

--Slope
minetest.register_craft({
	output = "myroofs:"..color.."_roof 6",
	recipe = {
		{"","",""},
		{"","",item},
		{"",item,item},
	}
})

--Outside Corner
minetest.register_craft({
	output = "myroofs:"..color.."_roof_ocorner 5",
	recipe = {
		{"", "", ""},
		{"", item, ""},
		{item, "", item},
	}
})



--Inside Corner
minetest.register_craft({
	output = "myroofs:"..color.."_roof_icorner 8",
	recipe = {
		{"","",""},
		{item,"",""},
		{item,item,""},
	}
})

--Long Slope
minetest.register_craft({
	output = "myroofs:"..color.."_roof_long 1",
	recipe = {
		{"", "",""},
		{"", item,item},
		{item, item,item},
	}
})

--Long Inside Corner
minetest.register_craft({
	output = "myroofs:"..color.."_roof_long_icorner 1",
	recipe = {
		{"", "",item},
		{"", "",item},
		{item, item,item},
	}
})

--Long Outside Corner
minetest.register_craft({
	output = "myroofs:"..color.."_roof_long_ocorner 1",
	recipe = {
		{"", item,""},
		{"", item,""},
		{item, item,item},
	}
})

end






