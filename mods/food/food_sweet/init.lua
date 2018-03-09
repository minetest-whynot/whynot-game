-- SWEET FOODS
-- A mod written by rubenwardy that adds
-- sweet food to the minetest game
-- =====================================
-- >> food_sweet/init.lua
-- Adds cakes, pies, waffles, and sweet
-- things
-- =====================================

print("Sweet Foods - Version 0.2")

if not food or not food.version or food.version < 2.3 then
	error("You need to update your version of the Food mod - it is too old")
end

-- Boilerplate to support localized strings if intllib mod is installed.
local S
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
else
	S = function ( s ) return s end
end

food.support("strawberry", {
		"farming_plus:strawberry_item",
		"plantlib:strawberry",
		"bushes:strawberry",
		"ethereal:strawberry"
})

food.support("blueberry", "bushes:blueberry")

food.support("rhubarb", "farming_plus:rhubarb_item")

if farming and farming.mod == "redo" then
	food.support("rhubarb", "farming:rhubarb")
	food.support("blueberry", "farming:blueberries")
end

if minetest.settings:get("food_sweet_use_2d")==nil then
	minetest.settings:set("food_sweet_use_2d", "1")
end

food.module("walnut",function()
	minetest.register_craftitem("food_sweet:walnut", {
		description = S("Walnut"),
		inventory_image = "food_sweet_walnut.png",
		groups = {food_walnut = 1, food_nut = 1}
	})
	food.craft({
		output = "food_sweet:walnut 4",
		recipe = {
			{"default:sand","","default:sand"},
			{"","default:sand",""},
			{"default:sand","","default:sand"}
		}
	})
end, true)
food.module("strawberry",function()
	minetest.register_alias("food:strawberry", "food_sweet:strawberry")
	minetest.register_craftitem("food_sweet:strawberry", {
		description = S("Strawberry"),
		inventory_image = "food_strawberry.png",
		on_use = food.item_eat(2),
		groups = {food_strawberry=1}
	})
	food.craft({
		output = "food_sweet:strawberry",
		recipe = {
			{"default:apple"},
		}
	})
end, true)
food.module("blueberry",function()
	minetest.register_craftitem("food_sweet:blueberry", {
		description = S("Blueberry"),
		inventory_image = "food_sweet_blueberry.png",
		groups = {food_blueberry = 1}
	})
	food.craft({
		output = "food_sweet:blueberry 4",
		recipe = {
			{"","wool:blue",""},
			{"wool:blue","","wool:blue"},
			{"","wool:blue",""}
		}
	})
end, true)
food.module("rhubarb",function()
	minetest.register_craftitem("food_sweet:rhubarb", {
		description = S("Rhubard"),
		inventory_image = "farming_rhubarb.png",
		groups = {food_rhubarb = 1}
	})
	food.craft({
		output = "food_sweet:rhubarb 10",
		recipe = {
			{"wool:red"},
			{"wool:red"},
			{"wool:red"}
		}
	})
end, true)
food.module("lemon",function()
	minetest.register_craftitem("food_sweet:lemon", {
		description = S("Lemon"),
		inventory_image = "food_lemon.png",
		groups = {food_lemon = 1}
	})
	food.craft({
		output = "food_sweet:lemon 4",
		recipe = {
			{"","default:sand",""},
			{"default:sand","","default:sand"},
			{"","default:sand",""}
		}
	})
end, true)

-- Walnut and Coffee cake
food.module("cake_walnut_coffee", function()
	food.register("food_sweet:cake_walnut_coffee",{
		description = S("Walnut and Coffee Cake"),
		on_use = food.item_eat(4),
		groups={food=3,crumbly=3},
		walkable = false,
		sunlight_propagates = true,
		inventory_image = "food_sweet_cake_walnut_coffee_2d.png",
		tiles = {
			"food_sweet_cake_walnut_coffee_3d_top.png",
			"food_sweet_cake_walnut_coffee_3d_bottom.png",
			"food_sweet_cake_walnut_coffee_3d.png",
			"food_sweet_cake_walnut_coffee_3d.png",
			"food_sweet_cake_walnut_coffee_3d.png",
			"food_sweet_cake_walnut_coffee_3d.png"
		},
		drawtype = "nodebox",
		paramtype = "light",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5,-0.4375,-0.5,0.5,0,0.5}, --NodeBox1
				{-0.4375,-0.5,-0.4375,0.438462,-0.4375,0.426923}, --NodeBox2
				{-0.4375,0,-0.4375,0.45,0.0625,0.426923}, --NodeBox3
				{-0.3125,0.0625,0.1875,-0.1875,0.1875,0.3125}, --NodeBox4
				{0.1875,0.0625,-0.3125,0.3125,0.1875,-0.1875}, --NodeBox5
			}
		}
	},"sweet")
	minetest.register_craftitem("food_sweet:cakemix_walnut_coffee",{
		description = S("Walnut and Coffee Cake Mix"),
		inventory_image = "food_sweet_cakemix_walnut_coffee.png"
	})
	food.craft({
		type = "cooking",
		output = "food_sweet:cake_walnut_coffee",
		recipe = "food_sweet:cakemix_walnut_coffee",
		cooktime = 10
	})
	food.craft({
		output = "food_sweet:cakemix_walnut_coffee",
		recipe = {
			{"","group:food_walnut",""},
			{"group:food_flour","group:food_sugar","group:food_egg"}
		}
	})
end)

-- Strawberry Cheese cake
food.module("cake_cheese", function()
	minetest.register_alias("food:cake_cheese", "food_sweet:cake_cheese")
	minetest.register_alias("food:cakemix_cheese", "food_sweet:cakemix_cheese")
	minetest.register_craftitem("food_sweet:cake_cheese",{
		description = S("Strawberry Cheese Cake"),
		inventory_image = "food_sweet_cake_cheese.png",
		on_use = food.item_eat(4),
		groups={food=3}
	})
	minetest.register_craftitem("food_sweet:cakemix_cheese",{
		description = S("Strawberry Cheese Cake Mix"),
		inventory_image = "food_sweet_cakemix_cheese.png"
	})
	food.craft({
		type = "cooking",
		output = "food_sweet:cake_cheese",
		recipe = "food_sweet:cakemix_cheese",
		cooktime = 10
	})
	food.craft({
		output = "food_sweet:cakemix_cheese",
		recipe = {
			{"group:food_cheese","group:food_strawberry",""},
			{"group:food_flour","group:food_sugar","group:food_egg"}
		}
	})
end)

-- Blueberry Cheese Cake
food.module("cake_cheese_blueberry", function()
	minetest.register_craftitem("food_sweet:cake_cheese_blueberry",{
		description = S("Blueberry Cheese Cake"),
		inventory_image = "food_sweet_cake_cheese_blueberry.png",
		on_use = food.item_eat(4),
		groups={food=3}
	})
	minetest.register_craftitem("food_sweet:cakemix_cheese_blueberry",{
		description = S("Blueberry Cheese Cake Mix"),
		inventory_image = "food_sweet_cakemix_cheese_blueberry.png"
	})
	food.craft({
		type = "cooking",
		output = "food_sweet:cake_cheese_blueberry",
		recipe = "food_sweet:cakemix_cheese_blueberry",
		cooktime = 10
	})
	food.craft({
		output = "food_sweet:cakemix_cheese_blueberry",
		recipe = {
			{"group:food_cheese","group:food_blueberry",""},
			{"group:food_flour","group:food_sugar","group:food_egg"}
		}
	})
end)

-- Triple chocolate cake
food.module("cake_triple_choco", function()
	minetest.register_craftitem("food_sweet:cake_triple_choco",{
		description = S("Triple Chocolate Cake"),
		inventory_image = "food_sweet_cake_triple_choco.png",
		on_use = food.item_eat(4),
		groups={food=3}
	})
	minetest.register_craftitem("food_sweet:cakemix_triple_choco",{
		description = S("Triple Chocolate Cake Mix"),
		inventory_image = "food_sweet_cakemix_triple_choco.png"
	})
	food.craft({
		type = "cooking",
		output = "food_sweet:cake_triple_choco",
		recipe = "food_sweet:cakemix_triple_choco",
		cooktime = 10
	})
	food.craft({
		output = "food_sweet:cakemix_triple_choco",
		recipe = {
			{"group:food_milk_chocolate","group:food_milk_chocolate","group:food_milk_chocolate"},
			{"group:food_flour","group:food_sugar","group:food_egg"}
		}
	})
end)

-- Wedding Cake
food.module("cake_wedding", function()
	minetest.register_craftitem("food_sweet:cake_wedding",{
		description = S("Wedding Cake"),
		inventory_image = "food_sweet_cake_wedding.png",
		on_use = food.item_eat(4),
		groups={food=3}
	})

	food.craft({
		output = "food_sweet:cake_wedding",
		recipe = {
			{"food:cake"},
			{"food:cake"},
			{"food:cake"}
		}
	})
end)

-- Rhubarb Crumble
food.module("crumble_rhubarb", function()
	minetest.register_craftitem("food_sweet:crumble_rhubarb",{
		description = S("Rhubarb Crumble"),
		inventory_image = "food_sweet_crumble_rhubarb.png",
		on_use = food.item_eat(4),
		groups={food=3}
	})
	minetest.register_craftitem("food_sweet:crumble_rhubarb_raw",{
		description = S("Raw Rhubarb Crumble"),
		inventory_image = "food_sweet_crumble_rhubarb_raw.png"
	})
	food.craft({
		type = "cooking",
		output = "food_sweet:crumble_rhubarb",
		recipe = "food_sweet:crumble_rhubarb_raw",
		cooktime = 10
	})
	food.craft({
		output = "food_sweet:crumble_rhubarb_raw",
		recipe = {
			{"","group:food_rhubarb",""},
			{"group:food_flour","group:food_sugar","group:food_egg"}
		}
	})
end)

-- Cup cake
food.module("cupcake", function()
	minetest.register_craftitem("food_sweet:cupcake",{
		description = S("Cupcake"),
		inventory_image = "food_sweet_cupcake.png",
		on_use = food.item_eat(2),
		groups={food=1}
	})
	minetest.register_craftitem("food_sweet:cupcake_mix",{
		description = S("Cupcake Mix"),
		inventory_image = "food_sweet_cupcake_mix.png"
	})
	food.craft({
		type = "cooking",
		output = "food_sweet:cupcake",
		recipe = "food_sweet:cupcake_mix",
		cooktime = 1
	})
	food.craft({
		output = "food_sweet:cupcake_mix 6",
		recipe = {
			{"group:food_flour","","group:food_egg"},
			{"","group:food_sugar",""}
		}
	})
end)

-- Chocolate Cupcake
food.module("cupcake_choco", function()
	minetest.register_craftitem("food_sweet:cupcake_choco",{
		description = S("Chocolate Cupcake"),
		inventory_image = "food_sweet_cupcake_choco.png",
		on_use = food.item_eat(2),
		groups={food=1}
	})
	minetest.register_craftitem("food_sweet:cupcake_choco_mix",{
		description = S("Chocolate Cupcake Mix"),
		inventory_image = "food_sweet_cupcake_choco_mix.png"
	})
	food.craft({
		type = "cooking",
		output = "food_sweet:cupcake_choco",
		recipe = "food_sweet:cupcake_choco_mix",
		cooktime = 1
	})
	food.craft({
		output = "food_sweet:cupcake_choco_mix 6",
		recipe = {
			{"group:food_flour","group:food_milk_chocolate","group:food_egg"},
			{"","group:food_sugar",""}
		}
	})
end)

-- Fairy Cake
food.module("cupcake_fairy", function()
	minetest.register_craftitem("food_sweet:cupcake_fairy",{
		description = S("Fairy Cake"),
		inventory_image = "food_sweet_cupcake_fairy.png",
		on_use = food.item_eat(2),
		groups={food=1}
	})
	food.craft({
		output = "food_sweet:cupcake_fairy",
		recipe = {
			{"group:food_sugar"},
			{"food_sweet:cupcake"}
		}
	})
end)

-- Lemon Cake
food.module("cupcake_lemon", function()
	minetest.register_craftitem("food_sweet:cupcake_lemon",{
		description = S("Lemon Drizzle Cupcake"),
		inventory_image = "food_sweet_cupcake_lemon.png",
		on_use = food.item_eat(2),
		groups={food=1}
	})
	food.craft({
		output = "food_sweet:cupcake_lemon",
		recipe = {
			{"group:food_lemon"},
			{"food_sweet:cupcake"}
		}
	})
end)

-- Blueberry Muffin
food.module("muffin_blueberry", function()
	minetest.register_craftitem("food_sweet:muffin_blueberry",{
		description = S("Blueberry Muffin"),
		inventory_image = "food_sweet_muffin_blueberry.png",
		on_use = food.item_eat(2),
		groups={food=1}
	})
	minetest.register_craftitem("food_sweet:muffin_blueberry_mix",{
		description = S("Blueberry Muffin Mix"),
		inventory_image = "food_sweet_cupcake_mix.png"
	})
	food.craft({
		type = "cooking",
		output = "food_sweet:muffin_blueberry",
		recipe = "food_sweet:muffin_blueberry_mix",
		cooktime = 1
	})
	food.craft({
		output = "food_sweet:muffin_blueberry_mix 6",
		recipe = {
			{"group:food_flour","group:food_blueberry","group:food_egg"},
			{"","group:food_sugar",""}
		}
	})
end)

-- Chocolate Chip Muffin
food.module("muffin_choco", function()
	minetest.register_craftitem("food_sweet:muffin_choco",{
		description = S("Chocolate Chip Muffin"),
		inventory_image = "food_sweet_muffin_choco.png",
		on_use = food.item_eat(2),
		groups={food=1}
	})
	minetest.register_craftitem("food_sweet:muffin_choco_mix",{
		description = S("Chocolate Chip Muffin Mix"),
		inventory_image = "food_sweet_cupcake_choco_mix.png"
	})
	food.craft({
		type = "cooking",
		output = "food_sweet:muffin_choco",
		recipe = "food_sweet:muffin_choco_mix",
		cooktime = 1
	})
	food.craft({
		output = "food_sweet:muffin_choco_mix 6",
		recipe = {
			{"","group:food_milk_chocolate",""},
			{"group:food_flour","group:food_milk_chocolate","group:food_egg"},
			{"","group:food_sugar",""}
		}
	})
end)

