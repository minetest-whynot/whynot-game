local cdoor_list = {   --Number , Description , Inven Image , Image
	{"Cottage Door 1" , "door1"},
	{"Cottage Door 2" , "door2"},
}

local function add_door(desc, img)
	doors.register_door("my_cottage_doors:"..img.."_locked", {
		description = desc.." Locked",
		inventory_image = "mycdoors_"..img.."_inv.png",
		groups = {choppy=2,cracky=2,door=1},
		tiles = {{name="mycdoors_"..img..".png", backface_culling = true}},
		protected = true,
	})
end

for _,cdoor in ipairs(cdoor_list) do
	add_door(unpack(cdoor))
end


-- Crafts

minetest.register_craft({
	output = "my_cottage_doors:door1_locked 1",
	recipe = {
		{"my_door_wood:wood_yellow", "my_door_wood:wood_yellow", "default:steel_ingot"},
		{"my_door_wood:wood_yellow", "my_door_wood:wood_yellow", "default:steel_ingot"},
		{"my_door_wood:wood_yellow", "my_door_wood:wood_yellow", "default:steel_ingot"}
	}
})

minetest.register_craft({
	output = "my_cottage_doors:door2_locked 1",
	recipe = {
		{"my_door_wood:wood_red", "my_door_wood:wood_red", ""},
		{"my_door_wood:wood_red", "my_door_wood:wood_red", "default:steel_ingot"},
		{"my_door_wood:wood_red", "my_door_wood:wood_red", ""}
	}
})
