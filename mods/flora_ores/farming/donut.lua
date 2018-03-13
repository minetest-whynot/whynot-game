
local S = farming.intllib

-- Donut (thanks to Bockwurst for making the donut images)
minetest.register_craftitem("farming:donut", {
	description = S("Donut"),
	inventory_image = "farming_donut.png",
	on_use = minetest.item_eat(4),
})

minetest.register_craft({
	output = "farming:donut 3",
	recipe = {
		{'', 'group:food_wheat', ''},
		{'group:food_wheat', 'group:food_sugar', 'group:food_wheat'},
		{'', 'group:food_wheat', ''},
	}
})

-- Chocolate Donut
minetest.register_craftitem("farming:donut_chocolate", {
	description = S("Chocolate Donut"),
	inventory_image = "farming_donut_chocolate.png",
	on_use = minetest.item_eat(6),
})

minetest.register_craft({
	output = "farming:donut_chocolate",
	recipe = {
		{'group:food_cocoa'},
		{'farming:donut'},
	}
})

-- Apple Donut
minetest.register_craftitem("farming:donut_apple", {
	description = S("Apple Donut"),
	inventory_image = "farming_donut_apple.png",
	on_use = minetest.item_eat(6),
})

minetest.register_craft({
	output = "farming:donut_apple",
	recipe = {
		{'default:apple'},
		{'farming:donut'},
	}
})

-- Porridge Oats
minetest.register_craftitem("farming:porridge", {
	description = S("Porridge"),
	inventory_image = "farming_porridge.png",
	on_use = minetest.item_eat(6),
})

minetest.after(0, function()

	if minetest.get_modpath("mobs") and mobs and mobs.mod == "redo" then

	minetest.register_craft({
		output = "farming:porridge",
		type = "shapeless",
		recipe = {
			"group:food_barley", "group:food_barley", "group:food_wheat",
			"group:food_wheat", "group:food_milk"
		},
		replacements = {{"mobs:bucket_milk", "bucket:bucket_empty"}}
	})
else
	minetest.register_craft({
		output = "farming:porridge",
		type = "shapeless",
		recipe = {
			"group:food_barley", "group:food_barley", "group:food_wheat",
			"group:food_wheat", "bucket:bucket_water"
		},
		replacements = {{"bucket:bucket_water", "bucket:bucket_empty"}}
	})
	end
end)
