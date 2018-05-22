local ing = mtfoods.ingredients

-- Flute Glass --
minetest.register_craftitem("mtfoods:glass_flute", {
	description = "Glass Flute",
	inventory_image = "mtfoods_flute.png",
})

minetest.register_craft({
	output = "mtfoods:glass_flute",
	recipe = {
		{'default:glass', '', 'default:glass'},
		{'', 'default:glass', ''},
		{'default:glass', 'default:glass', 'default:glass'},
	}
})

-- The Juices --

--orange--
minetest.register_craftitem("mtfoods:orange_juice", {
	description = "Orange Juice",
	inventory_image = "mtfoods_orange_juice.png",
	on_use = minetest.item_eat(0.5),
})

minetest.register_craft({
	type = "shapeless",
	output = "mtfoods:orange_juice",
	recipe = {'mtfoods:glass_flute', ing.orange}
})

--apple--

minetest.register_craftitem("mtfoods:apple_juice", {
	description = "Apple Juice",
	inventory_image = "mtfoods_apple_juice.png",
	on_use = minetest.item_eat(0.5),
})

minetest.register_craft({
	type = "shapeless",
	output = "mtfoods:apple_juice",
	recipe = {'mtfoods:glass_flute', ing.apple}
})

--Apple Cider--

minetest.register_node("mtfoods:apple_cider", {
	drawtype = 'plantlike',
	paramtype = 'light',
	tiles = {"mtfoods_apple_cider.png"},
	description = "Apple Cider in Bottle",
	inventory_image = "mtfoods_apple_cider.png",
	wield_image = "mtfoods_apple_cider.png",
	on_use = minetest.item_eat(1),
	groups = {oddly_breakable_by_hand=4, cracky=3},
	on_rightclick = function(pos, node, player, itemstack)
		drop = "mtfoods:apple_juice 3"
	end
})

minetest.register_craft({
    output = "mtfoods:apple_cider",
    recipe = {
        {'', 'default:steel_ingot', ''},
        {'default:glass', 'mtfoods:apple_juice', 'default:glass'},
        {'default:glass', 'mtfoods:apple_juice', 'default:glass'},
    }
})

minetest.register_node("mtfoods:cider_rack", {
	drawtype = 'normal',
	paramtype = 'light',
	paramtype2 = "facedir",
	tiles = {"mtfoods_ciderrack_other_sides.png", "mtfoods_ciderrack_other_sides.png", "mtfoods_ciderrack_other_sides.png", "mtfoods_ciderrack_other_sides.png", "mtfoods_ciderrack_other_sides.png", "mtfoods_ciderrack.png",},
	description = "A Cider Rack",
	inventory_image = "mtfoods_ciderrack.png",
	wield_image = "mtfoods_ciderrack.png",
	groups = {oddly_breakable_by_hand=3, choppy=3},
	drop = "mtfoods:apple_cider 2",
})

minetest.register_craft({
    output = "mtfoods:cider_rack",
    recipe = {
        {'default:wood','mtfoods:apple_cider','default:wood'},
        {'default:wood','mtfoods:apple_cider','default:wood'},
    }
})
