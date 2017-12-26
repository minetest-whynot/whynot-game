local cdoor_list = {   --Number , Description , Inven Image , Image
	{ "1", "Old Door 1" , "old1"},
	{ "2", "Old Door 2" , "old2"},
	{ "3", "Old Door 3" , "old3"},
	{ "4", "Old Door 4" , "old4"},
}
for i in ipairs(cdoor_list) do
	local num = cdoor_list[i][1]
	local desc = cdoor_list[i][2]
	local img = cdoor_list[i][3]


doors.register_door("my_old_doors:door"..num.."_locked", {
	description = desc.." Locked",
	inventory_image = "mydoors_"..img.."_inv.png",
	groups = {choppy=2,cracky=2,door=1},
	tiles = {{ name = "mydoors_"..img..".png", backface_culling = true }},
	protected = true,
})
end

-- Crafts

minetest.register_craft({
	output = "my_old_doors:door1_locked 1",
	recipe = {
		{"default:glass", "my_door_wood:wood_yellow", ""},
		{"my_door_wood:wood_yellow", "my_door_wood:wood_yellow", "default:steel_ingot"},
		{"my_door_wood:wood_yellow", "my_door_wood:wood_yellow", ""}
	}
})
minetest.register_craft({
	output = "my_old_doors:door2_locked 1",
	recipe = {
		{"default:glass", "my_door_wood:wood_red", ""},
		{"my_door_wood:wood_red", "my_door_wood:wood_red", "default:steel_ingot"},
		{"my_door_wood:wood_red", "my_door_wood:wood_red", ""}
	}
})
minetest.register_craft({
	output = "my_old_doors:door3_locked 1",
	recipe = {
		{"default:glass", "my_door_wood:wood_grey", ""},
		{"my_door_wood:wood_grey", "my_door_wood:wood_grey", "default:steel_ingot"},
		{"my_door_wood:wood_grey", "my_door_wood:wood_grey", ""}
	}
})
minetest.register_craft({
	output = "my_old_doors:door4_locked 1",
	recipe = {
		{"my_door_wood:wood_red", "my_door_wood:wood_red", ""},
		{"my_door_wood:wood_red", "dye:black", "default:steel_ingot"},
		{"my_door_wood:wood_red", "my_door_wood:wood_red", ""}
	}
})
