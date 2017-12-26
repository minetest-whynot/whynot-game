local cdoor_list = {   --Number , Description , Inven Image , Image
	{ "1", "Bronze Door" , "bronze", "bronze_ingot"},
	{ "2", "Copper Door" , "copper", "copper_ingot"},
	{ "3", "Gold Door" , "gold", "gold_ingot"},
	{ "4", "Diamond Door" , "diamond", "diamond"},
	{ "5", "Mese Door" , "mese", "mese_crystal"},
}


for i in ipairs(cdoor_list) do
	local num = cdoor_list[i][1]
	local desc = cdoor_list[i][2]
	local img = cdoor_list[i][3]
	local itm = cdoor_list[i][4]


doors.register_door("my_default_doors:door"..num.."_locked", {
	description = desc.." Locked",
	inventory_image = "mydoors_"..img.."_inv.png",
	groups = {choppy=2,cracky=2,door=1},
	tiles = {{name="mydoors_"..img..".png", backface_culling = true}},
	protected = true,
})


-- Crafts

minetest.register_craft({
	output = "my_default_doors:door"..num.."_locked 1",
	recipe = {
		{"", "", ""},
		{"default:"..itm, "doors:door_steel", "default:"..itm},
		{"", "default:steel_ingot", ""}
	}
})
end
