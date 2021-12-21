local S = farming.intllib

-- sunflower
minetest.register_craftitem("farming:sunflower", {
	description = S("Sunflower"),
	inventory_image = "farming_sunflower.png",
	groups = {flammable = 2}
})

-- sunflower seeds
minetest.register_craftitem("farming:seed_sunflower", {
	description = S("Sunflower Seeds"),
	inventory_image = "farming_sunflower_seeds.png",
	groups = {seed = 2, food_sunflower_seeds = 1, flammable = 2},
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:sunflower_1")
	end
})

minetest.register_alias("farming:sunflower_seeds", "farming:seed_sunflower")

minetest.register_craft({
	output = "farming:seed_sunflower 5",
	recipe = {{"farming:sunflower"}}
})

-- sunflower seeds (toasted)
minetest.register_craftitem("farming:sunflower_seeds_toasted", {
	description = S("Toasted Sunflower Seeds"),
	inventory_image = "farming_sunflower_seeds_toasted.png",
	groups = {food_sunflower_seeds_toasted = 1, flammable = 2},
	on_use = minetest.item_eat(1)
})

minetest.register_craft({
	type = "cooking",
	cooktime = 10,
	output = "farming:sunflower_seeds_toasted",
	recipe = "farming:seed_sunflower"
})

-- sunflower oil
minetest.register_node("farming:sunflower_oil", {
	description = S("Bottle of Sunflower Oil"),
	drawtype = "plantlike",
	tiles = {"farming_sunflower_oil.png"},
	inventory_image = "farming_sunflower_oil.png",
	wield_image = "farming_sunflower_oil.png",
	paramtype = "light",
	is_ground_content = false,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.3, 0.25}
	},
	groups = {
		food_oil = 1, vessel = 1, dig_immediate = 3, attached_node = 1,
		flammable = 2
	},
	sounds = default.node_sound_glass_defaults()
})

minetest.register_craft( {
	output = "farming:sunflower_oil",
	recipe = {
		{"group:food_sunflower_seeds", "group:food_sunflower_seeds", "group:food_sunflower_seeds"},
		{"group:food_sunflower_seeds", "group:food_sunflower_seeds", "group:food_sunflower_seeds"},
		{"group:food_sunflower_seeds", "vessels:glass_bottle", "group:food_sunflower_seeds"}
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "farming:sunflower_oil",
	burntime = 30,
	replacements = {{"farming:sunflower_oil", "vessels:glass_bottle"}}
})

-- sunflower seed bread
minetest.register_craftitem("farming:sunflower_bread", {
	description = S("Sunflower Seed Bread"),
	inventory_image = "farming_sunflower_bread.png",
	on_use = minetest.item_eat(8),
	groups = {food_bread = 1, flammable = 2}
})

minetest.register_craft({
	output = "farming:sunflower_bread",
	recipe = {{"group:food_sunflower_seeds_toasted", "group:food_bread", "group:food_sunflower_seeds_toasted"}}
})

-- sunflower definition
local def = {
	drawtype = "plantlike",
	tiles = {"farming_sunflower_1.png"},
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	drop = "",
	selection_box = farming.select,
	groups = {
		snappy = 3, flammable = 2, plant = 1, attached_node = 1,
		not_in_creative_inventory = 1, growing = 1
	},
	sounds = default.node_sound_leaves_defaults()
}

-- stage 1
minetest.register_node("farming:sunflower_1", table.copy(def))

-- stage 2
def.tiles = {"farming_sunflower_2.png"}
minetest.register_node("farming:sunflower_2", table.copy(def))

-- stage 3
def.tiles = {"farming_sunflower_3.png"}
minetest.register_node("farming:sunflower_3", table.copy(def))

-- stage 4
def.tiles = {"farming_sunflower_4.png"}
minetest.register_node("farming:sunflower_4", table.copy(def))

-- stage 5
def.tiles = {"farming_sunflower_5.png"}
minetest.register_node("farming:sunflower_5", table.copy(def))

-- stage 6
def.tiles = {"farming_sunflower_6.png"}
def.visual_scale = 1.9
minetest.register_node("farming:sunflower_6", table.copy(def))

-- stage 7
def.tiles = {"farming_sunflower_7.png"}
minetest.register_node("farming:sunflower_7", table.copy(def))

-- stage 8 (final)
def.tiles = {"farming_sunflower_8.png"}
def.groups.growing = nil
def.drop = {
	items = {
		{items = {"farming:sunflower"}, rarity = 1},
		{items = {"farming:sunflower"}, rarity = 6}
	}
}
minetest.register_node("farming:sunflower_8", table.copy(def))

-- add to registered_plants
farming.registered_plants["farming:sunflower"] = {
	crop = "farming:sunflower",
	seed = "farming:seed_sunflower",
	minlight = 14,
	maxlight = farming.max_light,
	steps = 8
}
