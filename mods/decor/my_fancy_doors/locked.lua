local fdoor_list = {   --Number , Description , Inven Image , Image
	{"Fancy Door 1" , "door1"},
--	{"Fancy Door 2" , "door2"},
--	{"Fancy Door 3" , "door3"},
	{"Fancy Door 4" , "door4"},
	{"Fancy Door 5" , "door5"},
	{"Fancy Door 6" , "door6"},
	{"Fancy Door 7" , "door7"},
	{"Fancy Door 8" , "door8"},
}


for i in ipairs(fdoor_list) do
	local desc = fdoor_list[i][1]
	local img = fdoor_list[i][2]


doors.register_door("my_fancy_doors:"..img.."_locked", {
	description = desc.." Locked",
	inventory_image = "myfdoors_"..img.."_inv.png",
	groups = {choppy=2,cracky=2,door=1},
	tiles = {{ name = "myfdoors_"..img..".png", backface_culling = true }},
	protected = true,
})
end

-- Crafts

minetest.register_craft({
	output = "my_fancy_doors:door1_locked 1",
	recipe = {
		{"my_door_wood:wood_yellow", "default:glass", ""},
		{"my_door_wood:wood_yellow", "my_door_wood:wood_yellow", "default:steel_ingot"},
		{"my_door_wood:wood_yellow", "default:glass", ""}
	}
})

minetest.register_craft({
	output = "my_fancy_doors:door2_locked 1",
	recipe = {
		{"my_door_wood:wood_yellow", "default:glass", ""},
		{"my_door_wood:wood_yellow", "default:steel_ingot", "default:steel_ingot"},
		{"my_door_wood:wood_yellow", "default:glass", ""}
	}
})
minetest.register_craft({
	output = "my_fancy_doors:door3_locked 1",
	recipe = {
		{"my_door_wood:wood_white", "default:glass", ""},
		{"my_door_wood:wood_white", "my_door_wood:wood_white", "default:steel_ingot"},
		{"my_door_wood:wood_white", "default:glass", ""}
	}
})
minetest.register_craft({
	output = "my_fancy_doors:door4_locked 1",
	recipe = {
		{"my_door_wood:wood_red", "my_door_wood:wood_dark_grey", ""},
		{"my_door_wood:wood_red", "my_door_wood:wood_red", "default:steel_ingot"},
		{"my_door_wood:wood_red", "my_door_wood:wood_dark_grey", ""}
	}
})
minetest.register_craft({
	output = "my_fancy_doors:door5_locked 1",
	recipe = {
		{"default:glass", "my_door_wood:wood_yellow", ""},
		{"my_door_wood:wood_yellow", "default:glass", "default:steel_ingot"},
		{"my_door_wood:wood_yellow", "my_door_wood:wood_yellow", ""}
	}
})
minetest.register_craft({
	output = "my_fancy_doors:door6_locked 1",
	recipe = {
		{"default:glass", "my_door_wood:wood_red", ""},
		{"my_door_wood:wood_red", "default:glass", "default:steel_ingot"},
		{"my_door_wood:wood_red", "my_door_wood:wood_red", ""}
	}
})
minetest.register_craft({
	output = "my_fancy_doors:door7_locked 1",
	recipe = {
		{"my_door_wood:wood_red", "default:glass", ""},
		{"my_door_wood:wood_red", "default:glass", "default:steel_ingot"},
		{"my_door_wood:wood_red", "my_door_wood:wood_red", ""}
	}
})
minetest.register_craft({
	output = "my_fancy_doors:door7_locked 1",
	recipe = {
		{"default:glass", "my_door_wood:wood_red", ""},
		{"default:glass", "my_door_wood:wood_red", "default:steel_ingot"},
		{"my_door_wood:wood_red", "my_door_wood:wood_red", ""}
	}
})
