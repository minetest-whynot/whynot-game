-- Desserts --

minetest.register_craftitem("mtfoods:dandelion_milk", {
	description = "Dandelion Milk",
	inventory_image = "mtfoods_milk.png",
	on_use = minetest.item_eat(1),
})

minetest.register_craftitem("mtfoods:sugar", {
	description = "Sugar",
	inventory_image = "mtfoods_sugar.png",
	on_use = minetest.item_eat(1),
})

minetest.register_craftitem("mtfoods:short_bread", {
	description = "Short Bread",
	inventory_image = "mtfoods_short_bread.png",
	on_use = minetest.item_eat(3.5),
})

minetest.register_craftitem("mtfoods:pie_crust", {
	description = "Pie Crust",
	inventory_image = "mtfoods_pie_crust.png",
	on_use = minetest.item_eat(3.5),
})

minetest.register_craftitem("mtfoods:cream", {
	description = "Cream",
	inventory_image = "mtfoods_cream.png",
	on_use = minetest.item_eat(1.5),
})

minetest.register_craftitem("mtfoods:chocolate", {
	description = "Chocolate Bits",
	inventory_image = "mtfoods_chocolate_bit.png",
	on_use = minetest.item_eat(2.5),
})

minetest.register_craftitem("mtfoods:cupcake", {
	description = "Cup-Cake",
	inventory_image = "mtfoods_cupcake.png",
	on_use = minetest.item_eat(3.5),
})

minetest.register_craftitem("mtfoods:strawberry_shortcake", {
	description = "Strawberry Short-Cake",
	inventory_image = "mtfoods_berry_shortcake.png",
	on_use = minetest.item_eat(3.5),
})

--minetest.register_craftitem("mtfoods:cake", {
--	description = "Cake",
--	inventory_image = "mtfoods_simple_cake.png",
--	on_use = minetest.item_eat(3),
--})
--
--minetest.register_craftitem("mtfoods:chocolate_cake", {
--	description = "Chocolate Cake",
--	inventory_image = "mtfoods_chocolate_cake.png",
--	on_use = minetest.item_eat(5),
--})
--
--minetest.register_craftitem("mtfoods:carrot_cake", {
--	description = "Carrot Cake",
--	inventory_image = "mtfoods_carrot_cake.png",
--	on_use = minetest.item_eat(4),
--})

--minetest.register_craftitem("mtfoods:apple_pie", {
--	description = "Apple Pie",
--	inventory_image = "mtfoods_apple_pie.png",
--	on_use = minetest.item_eat(5),
--})

--minetest.register_craftitem("mtfoods:rhubarb_pie", {
--	description = "Rhubarb Pie",
--	inventory_image = "mtfoods_rhubarb_pie.png",
--	on_use = minetest.item_eat(5),
--})

--minetest.register_craftitem("mtfoods:banana_pie", {
--	description = "Banana Cream Pie",
--	inventory_image = "mtfoods_banana_pie.png",
--	on_use = minetest.item_eat(5),
--})

--minetest.register_craftitem("mtfoods:pumpkin_pie", {
--	description = "Pumpkin Pie",
--	inventory_image = "mtfoods_pumpkin_pie.png",
--	on_use = minetest.item_eat(5),
--})

--minetest.register_craftitem("mtfoods:cookies", {
--	description = "Cookies",
--	inventory_image = "mtfoods_cookies.png",
--	on_use = minetest.item_eat(3),
--})

-- Crafting --
local ing = mtfoods.ingredients

minetest.register_craft({
	output = "mtfoods:dandelion_milk 2",
	recipe = {
		{'','flowers:dandelion_yellow', ''},
		{'mtfoods:sugar', 'flowers:dandelion_yellow', 'mtfoods:sugar'},
		{'', 'vessels:drinking_glass', ''},
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "mtfoods:sugar 3",
	recipe = {'default:papyrus'}
})

minetest.register_craft({
	output = "mtfoods:short_bread",
	recipe = {
		{'mtfoods:dandelion_milk'},
		{ing.bread},
		{'mtfoods:sugar'},
	}
})

minetest.register_craft({
	output = "mtfoods:cream",
	recipe = {
		{'mtfoods:dandelion_milk'},
		{'mtfoods:sugar'},
	}
})

minetest.register_craft({
	output = "mtfoods:chocolate 5",
	recipe = {
		{'mtfoods:sugar', 'mtfoods:dandelion_milk', 'mtfoods:sugar'},
		{ing.cocoa, ing.cocoa, ing.cocoa},
		{'mtfoods:sugar', 'mtfoods:dandelion_milk', 'mtfoods:sugar'},
	}
})

minetest.register_craft({
	output = "mtfoods:cupcake",
	recipe = {
		{'mtfoods:cream'},
		{'mtfoods:short_bread'},
		{'default:paper'},
	}
})

minetest.register_craft({
	output = "mtfoods:strawberry_shortcake",
	recipe = {
		{'mtfoods:cream', ing.strawberry, 'mtfoods:cream'},
		{ing.strawberry, 'mtfoods:short_bread', ing.strawberry},
	}
})

minetest.register_craft({
	output = "mtfoods:cake",
	recipe = {
		{'', 'mtfoods:sugar', ''},
		{'mtfoods:dandelion_milk', ing.bread, 'mtfoods:dandelion_milk'},
		{'', 'mtfoods:sugar', ''},
	}
})

minetest.register_craft({
	output = "mtfoods:chocolate_cake",
	recipe = {
		{'mtfoods:chocolate'},
		{'mtfoods:cake'},
	}
})

minetest.register_craft({
	output = "mtfoods:carrot_cake",
	recipe = {
		{'', ing.carrot, ''},
		{ing.cocoa, 'mtfoods:cake', ing.cocoa},
	}
})

minetest.register_craft({
	output = "mtfoods:pie_crust",
	recipe = {
		{ing.bread, ing.flour},
		{ing.flour, 'mtfoods:sugar'},
	}
})

minetest.register_craft({
	output = "mtfoods:apple_pie",
	recipe = {
		{ing.apple, ing.apple, ing.apple},
		{'', 'mtfoods:pie_crust', ''},
	}
})

minetest.register_craft({
	output = "mtfoods:rhubarb_pie",
	recipe = {
		{ing.rhubarb, ing.rhubarb, ing.rhubarb},
		{'', 'mtfoods:pie_crust', ''},
	}
})

minetest.register_craft({
	output = "mtfoods:banana_pie",
	recipe = {
		{ing.banana, 'mtfoods:cream', ing.banana},
		{'', 'mtfoods:pie_crust', ''},
	}
})

minetest.register_craft({
	output = "mtfoods:pumpkin_pie",
	recipe = {
		{'mtfoods:cream', ing.pumpkin, 'mtfoods:cream'},
		{'', 'mtfoods:pie_crust', ''},
	}
})

minetest.register_craft({
	output = "mtfoods:boston_cream",
	recipe = {
		{'mtfoods:cream', 'mtfoods:chocolate', 'mtfoods:cream'},
		{'', 'mtfoods:pie_crust', ''},
	}
})

minetest.register_craft({
	output = "mtfoods:cookies",
	recipe = {
		{'', 'mtfoods:chocolate', ''},
		{'mtfoods:chocolate', 'mtfoods:cream', 'mtfoods:chocolate'},
		{'', 'mtfoods:chocolate', ''},
	}
})

-- The 3d nodeboxes --

minetest.register_node("mtfoods:cake",{
	drawtype="nodebox",
	paramtype = "light",
	description = "Cake",
	on_use = minetest.item_eat(3),
	groups = {cracky=1,choppy=1,crumbly=1,oddly_breakable_by_hand=1},
	tiles = {"mtfoods_cake_top.png","mtfoods_cake_bottom.png","mtfoods_cake_side.png","mtfoods_cake_side.png","mtfoods_cake_side.png","mtfoods_cake_side.png"},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375000,-0.500000,-0.375000,0.375000,-0.187500,0.375000}, --NodeBox 1
			{-0.312500,-0.500000,-0.312500,0.312500,-0.062500,0.312500}, --NodeBox 2
		}
	}
})

minetest.register_node("mtfoods:chocolate_cake",{
	drawtype="nodebox",
	description = "Chocolate Cake",
	paramtype = "light",
	on_use = minetest.item_eat(5),
	groups = {cracky=1,choppy=1,crumbly=1,oddly_breakable_by_hand=1},
	tiles = {"mtfoods_cake_ctop.png","mtfoods_cake_cbottom.png","mtfoods_cake_cside.png","mtfoods_cake_cside.png","mtfoods_cake_cside.png","mtfoods_cake_cside.png"},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375000,-0.500000,-0.375000,0.375000,-0.187500,0.375000}, --NodeBox 1
			{-0.312500,-0.500000,-0.312500,0.312500,-0.062500,0.312500}, --NodeBox 2
		}
	}
})

minetest.register_node("mtfoods:carrot_cake",{
	drawtype = "nodebox",
	description = "Carrot Cake",
	on_use = minetest.item_eat(4),
	groups = {cracky=1,choppy=1,crumbly=1,oddly_breakable_by_hand=1},
	tiles = {"mtfoods_cake_atop.png","mtfoods_cake_bottom.png","mtfoods_cake_aside.png","mtfoods_cake_aside.png","mtfoods_cake_aside.png","mtfoods_cake_aside.png"},
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375000,-0.500000,-0.375000,0.375000,-0.187500,0.375000}, --NodeBox 1
			{-0.312500,-0.500000,-0.312500,0.312500,-0.062500,0.312500}, --NodeBox 2
		}
	}
})

minetest.register_node("mtfoods:apple_pie",{
	drawtype = "nodebox",
	paramtype = "light",
	description = "Apple Pie",
	on_use = minetest.item_eat(5),
	groups = {cracky=1,choppy=1,crumbly=1,oddly_breakable_by_hand=1},
	tiles = {"mtfoods_apie_top.png","mtfoods_pie_bottom.png","mtfoods_pie_side.png","mtfoods_pie_side.png","mtfoods_pie_side.png","mtfoods_pie_side.png"},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375000,-0.312500,-0.375000,0.375000,-0.125000,0.375000}, --NodeBox 1
			{-0.312500,-0.437500,-0.312500,0.312500,-0.062500,0.312500}, --NodeBox 2
			{-0.250000,-0.500000,-0.250000,0.250000,-0.125000,0.250000}, --NodeBox 3
		}
	}
})

minetest.register_node("mtfoods:rhubarb_pie",{
	drawtype="nodebox",
	paramtype = "light",
	description = "Rhubarb Pie",
	on_use = minetest.item_eat(5),
	groups = {cracky=1,choppy=1,crumbly=1,oddly_breakable_by_hand=1},
	tiles = {"mtfoods_rpie_top.png","mtfoods_pie_bottom.png","mtfoods_pie_side.png","mtfoods_pie_side.png","mtfoods_pie_side.png","mtfoods_pie_side.png"},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375000,-0.312500,-0.375000,0.375000,-0.125000,0.375000}, --NodeBox 1
			{-0.312500,-0.437500,-0.312500,0.312500,-0.062500,0.312500}, --NodeBox 2
			{-0.250000,-0.500000,-0.250000,0.250000,-0.125000,0.250000}, --NodeBox 3
		}
	}
})

minetest.register_node("mtfoods:banana_pie",{
	drawtype="nodebox",
	paramtype = "light",
	description = "Banana Pie",
	on_use = minetest.item_eat(5),
	groups = {cracky=1,choppy=1,crumbly=1,oddly_breakable_by_hand=1},
	tiles = {"mtfoods_bpie_top.png","mtfoods_pie_bottom.png","mtfoods_pie_side.png","mtfoods_pie_side.png","mtfoods_pie_side.png","mtfoods_pie_side.png"},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375000,-0.312500,-0.375000,0.375000,-0.125000,0.375000}, --NodeBox 1
			{-0.312500,-0.437500,-0.312500,0.312500,-0.062500,0.312500}, --NodeBox 2
			{-0.250000,-0.500000,-0.250000,0.250000,-0.125000,0.250000}, --NodeBox 3
		}
	}
})

minetest.register_node("mtfoods:pumpkin_pie",{
	drawtype="nodebox",
	paramtype = "light",
	description = "Pumpkin Pie",
	on_use = minetest.item_eat(5),
	groups = {cracky=1,choppy=1,crumbly=1,oddly_breakable_by_hand=1},
	tiles = {"mtfoods_ppie_top.png","mtfoods_pie_bottom.png","mtfoods_pie_side.png","mtfoods_pie_side.png","mtfoods_pie_side.png","mtfoods_pie_side.png"},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375000,-0.312500,-0.375000,0.375000,-0.125000,0.375000}, --NodeBox 1
			{-0.312500,-0.437500,-0.312500,0.312500,-0.062500,0.312500}, --NodeBox 2
			{-0.250000,-0.500000,-0.250000,0.250000,-0.125000,0.250000}, --NodeBox 3
		}
	}
})

minetest.register_node("mtfoods:boston_cream",{
	drawtype="nodebox",
	paramtype = "light",
	description = "Boston Cream Pie",
	on_use = minetest.item_eat(5),
	groups = {cracky=1,choppy=1,crumbly=1,oddly_breakable_by_hand=1},
	tiles = {"mtfoods_cake_cbottom.png","mtfoods_pie_bottom.png","mtfoods_bcpie_side.png","mtfoods_bcpie_side.png","mtfoods_bcpie_side.png","mtfoods_bcpie_side.png"},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375000,-0.312500,-0.375000,0.375000,-0.125000,0.375000}, --NodeBox 1
			{-0.312500,-0.437500,-0.312500,0.312500,-0.062500,0.312500}, --NodeBox 2
			{-0.250000,-0.500000,-0.250000,0.250000,-0.125000,0.250000}, --NodeBox 3
		}
	}
})


minetest.register_node("mtfoods:cookies",{
	drawtype = "nodebox",
	paramtype = "light",
	description = "Cookies",
	on_use = minetest.item_eat(3),
	groups = {cracky=1,choppy=1,crumbly=1,oddly_breakable_by_hand=1},
	tiles = {"mtfoods_cookies.png","mtfoods_cookies.png","mtfoods_cookies.png","mtfoods_cookies.png","mtfoods_cookies.png","mtfoods_cookies.png"},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125000,-0.500000,-0.250000,0.250000,-0.312500,0.125000}, --NodeBox 1
			{-0.187500,-0.312500,-0.187500,0.187500,-0.125000,0.187500}, --NodeBox 2
			{-0.250000,-0.125000,-0.125000,0.125000,0.062500,0.250000}, --NodeBox 3
		}
	}
})

minetest.register_node("mtfoods:chocolate",{
	drawtype = "nodebox",
	paramtype = "light",
	description = "Chocolate Bars",
	on_use = minetest.item_eat(2),
	groups = {cracky=1,choppy=1,crumbly=1,oddly_breakable_by_hand=1},
	tiles = {"mtfoods_chocolate.png","mtfoods_chocolate.png","mtfoods_chocolate.png","mtfoods_chocolate.png","mtfoods_chocolate.png","mtfoods_chocolate.png"},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.312500,-0.500000,-0.187500,0.312500,-0.375000,0.187500}, --NodeBox 1
			{-0.250000,-0.500000,-0.125000,0.250000,-0.312500,0.125000}, --NodeBox 2
		}
	}
})

minetest.register_node("mtfoods:cupcake",{
	drawtype = "nodebox",
	paramtype = "light",
	description = "Cupcakes",
	on_use = minetest.item_eat(3.5),
	groups = {cracky=1,choppy=1,crumbly=1,oddly_breakable_by_hand=1},
	tiles = {"mtfoods_cupcake_top.png","mtfoods_cake_bottom.png","mtfoods_cupcake_side.png","mtfoods_cupcake_side.png","mtfoods_cupcake_side.png","mtfoods_cupcake_side.png"},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.187500,-0.500000,-0.187500,0.187500,0.125000,0.187500},
			{-0.312500,-0.375000,-0.312500,0.312500,0.000000,0.312500},

		}
	}
})

-- Finis --
