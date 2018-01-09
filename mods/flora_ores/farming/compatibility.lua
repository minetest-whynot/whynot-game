-- is Ethereal mod installed?
local eth = minetest.get_modpath("ethereal") or nil

-- Banana
if eth then
	minetest.register_alias("farming_plus:banana_sapling", "ethereal:banana_tree_sapling")
	minetest.register_alias("farming_plus:banana_leaves", "ethereal:bananaleaves")
	minetest.register_alias("farming_plus:banana", "ethereal:banana")
else
	minetest.register_node(":ethereal:banana", {
		description = "Banana",
		drawtype = "torchlike",
		tiles = {"banana_single.png"},
		inventory_image = "banana_single.png",
		wield_image = "banana_single.png",
		paramtype = "light",
		sunlight_propagates = true,
		walkable = false,
		selection_box = {
			type = "fixed",
			fixed = {-0.2, -0.5, -0.2, 0.2, 0.2, 0.2}
		},
		groups = {fleshy = 3, dig_immediate = 3, flammable = 2},
		on_use = minetest.item_eat(2),
		sounds = default.node_sound_leaves_defaults(),
	})

	minetest.register_alias("farming_plus:banana_sapling", "default:sapling")
	minetest.register_alias("farming_plus:banana_leaves", "default:leaves")
	minetest.register_alias("farming_plus:banana", "ethereal:banana")
end

-- Carrot
minetest.register_alias("farming_plus:carrot_seed", "farming:carrot")
minetest.register_alias("farming_plus:carrot_1", "farming:carrot_1")
minetest.register_alias("farming_plus:carrot_2", "farming:carrot_4")
minetest.register_alias("farming_plus:carrot_3", "farming:carrot_6")
minetest.register_alias("farming_plus:carrot", "farming:carrot_8")
minetest.register_alias("farming_plus:carrot_item", "farming:carrot")

minetest.register_alias("farming_plus:seed_carrot2", "farming:carrot")
minetest.register_alias("farming_plus:carrot2_1", "farming:carrot_1")
minetest.register_alias("farming_plus:carrot2_2", "farming:carrot_4")
minetest.register_alias("farming_plus:carrot2_3", "farming:carrot_6")
minetest.register_alias("farming_plus:carrot2_4", "farming:carrot_8")
minetest.register_alias("farming_plus:carrot2", "farming:carrot")

-- Cocoa
minetest.register_alias("farming_plus:cocoa_sapling", "farming:cocoa_2")
minetest.register_alias("farming_plus:cocoa_leaves", "default:leaves")
minetest.register_alias("farming_plus:cocoa", "default:apple")
minetest.register_alias("farming_plus:cocoa_bean", "farming:cocoa_beans")

-- Orange
minetest.register_alias("farming_plus:orange_1", "farming:tomato_1")
minetest.register_alias("farming_plus:orange_2", "farming:tomato_4")
minetest.register_alias("farming_plus:orange_3", "farming:tomato_6")
--minetest.register_alias("farming_plus:orange", "farming:tomato_8")

if eth then
	minetest.register_alias("farming_plus:orange_item", "ethereal:orange")
	minetest.register_alias("farming_plus:orange", "ethereal:orange")
	minetest.register_alias("farming_plus:orange_seed", "ethereal:orange_tree_sapling")
else
	minetest.register_node(":ethereal:orange", {
		description = "Orange",
		drawtype = "plantlike",
		tiles = {"farming_orange.png"},
		inventory_image = "farming_orange.png",
		wield_image = "farming_orange.png",
		paramtype = "light",
		sunlight_propagates = true,
		walkable = false,
		selection_box = {
			type = "fixed",
			fixed = {-0.2, -0.3, -0.2, 0.2, 0.2, 0.2}
		},
		groups = {fleshy = 3, dig_immediate = 3, flammable = 2},
		on_use = minetest.item_eat(4),
		sounds = default.node_sound_leaves_defaults(),
	})

	minetest.register_alias("farming_plus:orange_item", "ethereal:orange")
	minetest.register_alias("farming_plus:orange", "ethereal:orange")
	minetest.register_alias("farming_plus:orange_seed", "default:sapling")
end

-- Potato
minetest.register_alias("farming_plus:potato_item", "farming:potato")
minetest.register_alias("farming_plus:potato_1", "farming:potato_1")
minetest.register_alias("farming_plus:potato_2", "farming:potato_2")
minetest.register_alias("farming_plus:potato", "farming:potato_3")
minetest.register_alias("farming_plus:potato_seed", "farming:potato")

minetest.register_alias("farming_plus:potato2_1", "farming:potato_1")
minetest.register_alias("farming_plus:potato2_2", "farming:potato_2")
minetest.register_alias("farming_plus:potato2_3", "farming:potato_3")
minetest.register_alias("farming_plus:potato2_4", "farming:potato_3")
minetest.register_alias("farming_plus:potato2", "farming:potato")
minetest.register_alias("farming_plus:seed_potato2", "farming:potato")

-- Pumpkin
minetest.register_alias("farming:pumpkin_seed", "farming:pumpkin_slice")
minetest.register_alias("farming:pumpkin_face", "farming:jackolantern")
minetest.register_alias("farming:pumpkin_face_light", "farming:jackolantern_on")
minetest.register_alias("farming:big_pumpkin", "farming:pumpkin")
minetest.register_alias("farming:big_pumpkin_side", "air")
minetest.register_alias("farming:big_pumpkin_corner", "air")
minetest.register_alias("farming:big_pumpkin_top", "air")
minetest.register_alias("farming:scarecrow", "farming:jackolantern")
minetest.register_alias("farming:scarecrow_bottom", "default:fence_wood")
minetest.register_alias("farming:scarecrow_light", "farming:jackolantern_on")
minetest.register_alias("farming:pumpkin_flour", "farming:pumpkin_dough")

-- Rhubarb
minetest.register_alias("farming_plus:rhubarb_seed", "farming:rhubarb")
minetest.register_alias("farming_plus:rhubarb_1", "farming:rhubarb_1")
minetest.register_alias("farming_plus:rhubarb_2", "farming:rhubarb_2")
minetest.register_alias("farming_plus:rhubarb", "farming:rhubarb_3")
minetest.register_alias("farming_plus:rhubarb_item", "farming:rhubarb")

minetest.register_alias("farming_plus:seed_rhubarb2", "farming:rhubarb")
minetest.register_alias("farming_plus:rhubarb2_1", "farming:rhubarb_1")
minetest.register_alias("farming_plus:rhubarb2_2", "farming:rhubarb_2")
minetest.register_alias("farming_plus:rhubarb2_3", "farming:rhubarb_3")
minetest.register_alias("farming_plus:rhubarb2", "farming:rhubarb")

-- Strawberry
if eth then
	minetest.register_alias("farming_plus:strawberry_item", "ethereal:strawberry")
	minetest.register_alias("farming_plus:strawberry_seed", "ethereal:strawberry")
	minetest.register_alias("farming_plus:strawberry_1", "ethereal:strawberry_1")
	minetest.register_alias("farming_plus:strawberry_2", "ethereal:strawberry_3")
	minetest.register_alias("farming_plus:strawberry_3", "ethereal:strawberry_5")
	minetest.register_alias("farming_plus:strawberry", "ethereal:strawberry_7")

	minetest.register_alias("farming_plus:strawberry2", "ethereal:strawberry")
	minetest.register_alias("farming_plus:seed_strawberry2", "ethereal:strawberry")
	minetest.register_alias("farming_plus:strawberry2_1", "ethereal:strawberry_1")
	minetest.register_alias("farming_plus:strawberry2_2", "ethereal:strawberry_3")
	minetest.register_alias("farming_plus:strawberry2_3", "ethereal:strawberry_5")
	minetest.register_alias("farming_plus:strawberry2", "ethereal:strawberry_7")

else
	minetest.register_craftitem(":ethereal:strawberry", {
		description = "Strawberry",
		inventory_image = "strawberry.png",
		wield_image = "strawberry.png",
		on_use = minetest.item_eat(1),
	})

	minetest.register_alias("farming_plus:strawberry_item", "ethereal:strawberry")
	minetest.register_alias("farming_plus:strawberry_seed", "ethereal:strawberry")
	minetest.register_alias("farming_plus:strawberry_1", "farming:raspberry_1")
	minetest.register_alias("farming_plus:strawberry_2", "farming:raspberry_2")
	minetest.register_alias("farming_plus:strawberry_3", "farming:raspberry_3")
	minetest.register_alias("farming_plus:strawberry", "farming:raspberry_4")

	minetest.register_alias("farming_plus:strawberry2", "ethereal:strawberry")
	minetest.register_alias("farming_plus:seed_strawberry2", "ethereal:strawberry")
	minetest.register_alias("farming_plus:strawberry2_1", "farming:raspberry_1")
	minetest.register_alias("farming_plus:strawberry2_2", "farming:raspberry_2")
	minetest.register_alias("farming_plus:strawberry2_3", "farming:raspberry_3")
	minetest.register_alias("farming_plus:strawberry2_4", "farming:raspberry_3")
	minetest.register_alias("farming_plus:strawberry2", "farming:raspberry_4")
end

-- Tomato
minetest.register_alias("farming_plus:tomato_seed", "farming:tomato")
minetest.register_alias("farming_plus:tomato_item", "farming:tomato")
minetest.register_alias("farming_plus:tomato_1", "farming:tomato_2")
minetest.register_alias("farming_plus:tomato_2", "farming:tomato_4")
minetest.register_alias("farming_plus:tomato_3", "farming:tomato_6")
minetest.register_alias("farming_plus:tomato", "farming:tomato_8")

minetest.register_alias("farming_plus:seed_tomato2", "farming:tomato")
minetest.register_alias("farming_plus:tomato2", "farming:tomato")
minetest.register_alias("farming_plus:tomato2_1", "farming:tomato_2")
minetest.register_alias("farming_plus:tomato2_2", "farming:tomato_4")
minetest.register_alias("farming_plus:tomato2_3", "farming:tomato_6")
minetest.register_alias("farming_plus:tomato2_4", "farming:tomato_7")

-- Weed
minetest.register_alias("farming:weed", "default:grass_2")
minetest.register_alias("farming_plus:weed", "default:grass_2")

-- Classic Bushes compatibility
if minetest.get_modpath("bushes_classic") then

	if eth then
		minetest.register_alias("bushes:strawberry", "farming:strawberry")
	else
		minetest.register_alias("bushes:strawberry", "farming:raspberries")
	end

	minetest.register_alias("bushes:blueberry", "farming:blueberries")
	minetest.register_alias("bushes:raspberry", "farming:raspberries")

end
