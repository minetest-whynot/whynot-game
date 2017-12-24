
-- add lucky blocks

if minetest.get_modpath("lucky_block") then

	lucky_block:add_blocks({
		{"dro", {"farming:corn"}, 5},
		{"dro", {"farming:coffee_cup_hot"}, 1},
		{"dro", {"farming:bread"}, 5},
		{"nod", "farming:jackolantern", 0},
		{"tro", "farming:jackolantern_on"},
		{"nod", "default:river_water_source", 1},
		{"dro", {"farming:trellis", "farming:grapes"}, 5},
		{"dro", {"farming:bottle_ethanol"}, 1},
		{"nod", "farming:melon", 0},
		{"dro", {"farming:donut", "farming:donut_chocolate", "farming:donut_apple"}, 5},
		{"dro", {"farming:hemp_leaf", "farming:hemp_fibre", "farming:seed_hemp"}, 5},
		{"nod", "fire:permanent_flame", 1},
		{"dro", {"farming:chili_pepper", "farming:chili_bowl"}, 5},
	})
end
