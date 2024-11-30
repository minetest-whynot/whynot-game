local cdoor_list = {   --Number , Description , Inven Image , Image
	{ "1", "Bronze Door" , "bronze", "bronze_ingot"},
	{ "2", "Copper Door" , "copper", "copper_ingot"},
	{ "3", "Gold Door" , "gold", "gold_ingot"},
	{ "4", "Diamond Door" , "diamond", "diamond"},
	{ "5", "Mese Door" , "mese", "mese_crystal"},
}

local function add_door(num, desc, img, itm)
	doors.register_door("my_default_doors:door"..num, {
		description = desc,
		inventory_image = "mydoors_"..img.."_inv.png",
		groups = {choppy=2,cracky=2,door=1},
		tiles = {{name="mydoors_"..img..".png", backface_culling = true}},
		protected = false,
	})

	-- Crafts
	minetest.register_craft({
		output = "my_default_doors:door"..num.." 1",
		recipe = {
			{"", "", ""},
			{"default:"..itm, "doors:door_steel", "default:"..itm},
			{"", "", ""}
		}
	})
end

for _,cdoor in ipairs(cdoor_list) do
	add_door(unpack(cdoor))
end
