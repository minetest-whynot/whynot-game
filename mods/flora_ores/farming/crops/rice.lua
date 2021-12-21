
local S = farming.intllib

-- rice
minetest.register_craftitem("farming:rice", {
	description = S("Rice"),
	inventory_image = "farming_rice.png",
	groups = {seed = 2, food_rice = 1, flammable = 2},
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:rice_1")
	end
})

-- replacement for rice seeds that was removed
minetest.register_alias("farming:seed_rice", "farming:rice")

minetest.register_craftitem("farming:rice_bread", {
	description = S("Rice Bread"),
	inventory_image = "farming_rice_bread.png",
	on_use = minetest.item_eat(5),
	groups = {food_rice_bread = 1, flammable = 2}
})

minetest.register_craftitem("farming:rice_flour", {
	description = S("Rice Flour"),
	inventory_image = "farming_rice_flour.png",
	groups = {food_rice_flour = 1, flammable = 1}
})

minetest.register_craft({
	output = "farming:rice_flour",
	recipe = {
		{"farming:rice", "farming:rice", "farming:rice"},
		{"farming:rice", "farming:mortar_pestle", ""}
	},
	replacements = {{"group:food_mortar_pestle", "farming:mortar_pestle"}}
})

minetest.register_craft({
	type = "cooking",
	cooktime = 15,
	output = "farming:rice_bread",
	recipe = "farming:rice_flour"
})

-- rice definition
local def = {
	drawtype = "plantlike",
	tiles = {"farming_rice_1.png"},
	paramtype = "light",
	paramtype2 = "meshoptions",
	place_param2 = 3,
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	drop = "",
	selection_box = farming.select,
	groups = {
		snappy = 3, flammable = 4, plant = 1, attached_node = 1,
		not_in_creative_inventory = 1, growing = 1
	},
	sounds = default.node_sound_leaves_defaults()
}

-- stage 1
minetest.register_node("farming:rice_1", table.copy(def))

-- stage 2
def.tiles = {"farming_rice_2.png"}
minetest.register_node("farming:rice_2", table.copy(def))

-- stage 3
def.tiles = {"farming_rice_3.png"}
minetest.register_node("farming:rice_3", table.copy(def))

-- stage 4
def.tiles = {"farming_rice_4.png"}
minetest.register_node("farming:rice_4", table.copy(def))

-- stage 5
def.tiles = {"farming_rice_5.png"}
def.drop = {
	items = {
		{items = {"farming:rice"}, rarity = 2}
	}
}
minetest.register_node("farming:rice_5", table.copy(def))

-- stage 6
def.tiles = {"farming_rice_6.png"}
def.drop = {
	items = {
		{items = {"farming:rice"}, rarity = 2}
	}
}
minetest.register_node("farming:rice_6", table.copy(def))

-- stage 7
def.tiles = {"farming_rice_7.png"}
def.drop = {
	items = {
		{items = {"farming:rice"}, rarity = 1},
		{items = {"farming:rice"}, rarity = 3}
	}
}
minetest.register_node("farming:rice_7", table.copy(def))

-- stage 8 (final)
def.tiles = {"farming_rice_8.png"}
def.groups.growing = nil
def.drop = {
	items = {
		{items = {"farming:rice 2"}, rarity = 1},
		{items = {"farming:rice"}, rarity = 2}
	}
}
minetest.register_node("farming:rice_8", table.copy(def))

-- add to registered_plants
farming.registered_plants["farming:rice"] = {
	crop = "farming:rice",
	seed = "farming:rice",
	minlight = farming.min_light,
	maxlight = farming.max_light,
	steps = 8
}

-- fuels
minetest.register_craft({
	type = "fuel",
	recipe = "farming:rice",
	burntime = 1
})

minetest.register_craft({
	type = "fuel",
	recipe = "farming:rice_bread",
	burntime = 1
})
