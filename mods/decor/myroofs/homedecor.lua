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

local homedecor_slope = { --desc, color, img
	{"Home Decor", "hd_asphalt", "homedecor_shingles_asphalt"},
	{"Terracotta", "hd_terracotta", "homedecor_shingles_terracotta"},
	{"Wood", "hd_wood", "homedecor_shingles_wood"},
}
for i in ipairs (homedecor_slope) do
	local desc = homedecor_slope[i][1]
	local color = homedecor_slope[i][2]
	local img = homedecor_slope[i][3]


--Slope
minetest.register_node("myroofs:asphalt_shingle_"..color, {
	description = desc.." Asphalt Shingle",
	drawtype = "mesh",
	mesh = "twelve-twelve.obj",
	tiles = {img..".png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=3},
	sounds = default.node_sound_wood_defaults(),
	on_place = minetest.rotate_node,
	collision_box = slope_cbox,
	selection_box = slope_cbox
})

--Outside Corner
minetest.register_node("myroofs:asphalt_shingle_"..color.."_ocorner", {
	description = desc.." Asphalt Shingle Outside Corner",
	drawtype = "mesh",
	mesh = "twelve-twelve-oc.obj",
	tiles = {img..".png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=3},
	sounds = default.node_sound_wood_defaults(),
	on_place = minetest.rotate_node,
	collision_box = ocorner_cbox,
	selection_box = ocorner_cbox
})

--Inside Corner
minetest.register_node("myroofs:asphalt_shingle_"..color.."_icorner", {
	description = desc.." Asphalt Shingle Inside Corner",
	drawtype = "mesh",
	mesh = "twelve-twelve-ic.obj",
	tiles = {img..".png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=3},
	sounds = default.node_sound_wood_defaults(),
	on_place = minetest.rotate_node,
	collision_box = icorner_cbox,
	selection_box = icorner_cbox
})
end
local homedecor_lslope = { --desc, color, img
--	{"Dog House", "hd_doghouse", "homedecor_doghouse_roof_top"},
	{"Home Decor", "hd_asphalt", "homedecor_shingles_asphalt"},
	{"Terracotta", "hd_terracotta", "homedecor_shingles_terracotta"},
	{"Wood", "hd_wood", "homedecor_shingles_wood"},
}
for i in ipairs (homedecor_lslope) do
	local desc = homedecor_lslope[i][1]
	local color = homedecor_lslope[i][2]
	local img = homedecor_lslope[i][3]

--Long slope
minetest.register_node("myroofs:asphalt_shingle_"..color.."_long", {
	description = desc.." Asphalt Shingle Long",
	drawtype = "mesh",
	mesh = "six-twelve_slope.obj",
	tiles = {img..".png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=3},
	sounds = default.node_sound_wood_defaults(),
	on_place = minetest.rotate_node,
	collision_box = slope_cbox_long,
	selection_box = slope_cbox_long
})

--Long Inside Corner
minetest.register_node("myroofs:asphalt_shingle_"..color.."_long_icorner", {
	description = desc.." Asphalt Shingle Long Inside Corner",
	drawtype = "mesh",
	mesh = "six-twelve_slope-ic.obj",
	tiles = {img..".png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=3},
	sounds = default.node_sound_wood_defaults(),
	on_place = minetest.rotate_node,
	collision_box = icorner_cbox_long,
	selection_box = icorner_cbox_long
})

--Long Outside Corner
minetest.register_node("myroofs:asphalt_shingle_"..color.."_long_ocorner", {
	description = desc.." Asphalt Shingle Long Outside Corner",
	drawtype = "mesh",
	mesh = "six-twelve_slope-oc.obj",
	tiles = {img..".png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=3},
	sounds = default.node_sound_wood_defaults(),
	on_place = minetest.rotate_node,
	collision_box = ocorner_cbox_long,
	selection_box = ocorner_cbox_long
})

end
minetest.register_craft( {
        output = "homedecor:shingles_terracotta",
        recipe = {
                { "homedecor:roof_tile_terracotta", "homedecor:roof_tile_terracotta"},
                { "homedecor:roof_tile_terracotta", "homedecor:roof_tile_terracotta"},
        },
})

-----------------------------------------------------------------------------
--Crafts
-----------------------------------------------------------------------------
local homedecor_slope = { --desc, color, item
	{"Home Decor", "hd_asphalt", "homedecor:shingles_asphalt"},
	{"Terracotta", "hd_terracotta", "homedecor:shingles_terracotta"},
	{"Wood", "hd_wood", "homedecor:shingles_wood"},
}
for i in ipairs (homedecor_slope) do
	local desc = homedecor_slope[i][1]
	local color = homedecor_slope[i][2]
	local item = homedecor_slope[i][3]

--Slope
minetest.register_craft({
	output = "myroofs:asphalt_shingle_"..color.." 2",
	recipe = {
		{"", "",""},
		{"", "",item},
		{"", item,item},
	}
})

--Inside Corner
minetest.register_craft({
	output = "myroofs:asphalt_shingle_"..color.."_icorner 3",
	recipe = {
		{"", "",""},
		{item, "",""},
		{item, item,""},
	}
})
--Outside Corner
minetest.register_craft({
	output = "myroofs:asphalt_shingle_"..color.."_ocorner 3",
	recipe = {
		{"", "", ""},
		{"", item, ""},
		{item, "", item},
	}
})
end

local homedecor_lslope = { --desc, color, item
	{"Home Decor", "hd_asphalt", "homedecor:shingles_asphalt"},
	{"Terracotta", "hd_terracotta", "homedecor:shingles_terracotta"},
	{"Wood", "hd_wood", "homedecor:shingles_wood"},
}
for i in ipairs (homedecor_lslope) do
	local desc = homedecor_lslope[i][1]
	local color = homedecor_lslope[i][2]
	local item = homedecor_lslope[i][3]

--Long Slope
minetest.register_craft({
	output = "myroofs:asphalt_shingle_"..color.."_long 3",
	recipe = {
		{"", "",""},
		{"", item,item},
		{item, item,item},
	}
})
--Long Inside Corner
minetest.register_craft({
	output = "myroofs:asphalt_shingle_"..color.."_long_icorner 2",
	recipe = {
		{"", "",item},
		{"", "",item},
		{item, item,item},
	}
})
--Long Outside Corner
minetest.register_craft({
	output = "myroofs:asphalt_shingle_"..color.."_long_ocorner 2",
	recipe = {
		{"",item, ""},
		{"", item, ""},
		{item, item,item},
	}
})

end





