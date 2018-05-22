--MTFoods-- 
--By: Philipbenr--
--Licence: GPLv3--
mtfoods = {}

local orange_ing = "farming_plus:orange"
if minetest.get_modpath("ethereal") then
	orange_ing = "ethereal:orange"
end

mtfoods.ingredients = {
	orange = orange_ing,
	apple = "default:apple",
	meat = "mobs:meat",
	bread = "farming:bread",
	tomato = "farming_plus:tomato_item",
	wheat = "farming:wheat",
	carrot = "farming_plus:carrot_item",
	potato = "farming_plus:potato_item",
	cocoa = "farming_plus:cocoa_bean",
	strawberry = "farming_plus:strawberry_item",
	flour = "farming:flour",
	rhubarb = "farming_plus:rhubarb_item",
	banana = "farming_plus:banana",
	pumpkin = "farming:pumpkin",
}

-- Add support for the food mod's ingredient list
if minetest.get_modpath("food") then
	mtfoods.ingredients = {
		orange = "group:food_orange",
		apple = "default:apple",
		meat = "group:food_meat",
		bread = "farming:bread",
		tomato = "group:food_tomato",
		wheat = "group:food_wheat",
		carrot = "group:food_carrot",
		potato = "group:food_potato",
		cocoa = "group:food_cocoa",
		strawberry = "group:food_strawberry",
		flour = "group:food_flour",
		rhubarb = "group:food_rhubarb",
		banana = "farming_plus:banana",
		pumpkin = "farming:pumpkin",
	}
end

dofile(minetest.get_modpath("mtfoods").."/desserts.lua")
dofile(minetest.get_modpath("mtfoods").."/foods.lua")
dofile(minetest.get_modpath("mtfoods").."/drinks.lua")
