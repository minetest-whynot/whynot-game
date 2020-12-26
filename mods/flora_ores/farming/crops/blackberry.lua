
local S = farming.intllib

-- blackberries
minetest.register_craftitem("farming:blackberry", {
	description = S("Blackberries"),
	inventory_image = "farming_blackberry.png",
	groups = {seed = 2, food_blackberries = 1, food_blackberry = 1,
			food_berry = 1, flammable = 2},
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:blackberry_1")
	end,
	on_use = minetest.item_eat(1),
})

local def = {
	drawtype = "plantlike",
	tiles = {"farming_blackberry_1.png"},
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
minetest.register_node("farming:blackberry_1", table.copy(def))

-- stage 2
def.tiles = {"farming_blackberry_2.png"}
minetest.register_node("farming:blackberry_2", table.copy(def))

-- stage 3
def.tiles = {"farming_blackberry_3.png"}
minetest.register_node("farming:blackberry_3", table.copy(def))

-- stage 4
def.tiles = {"farming_blackberry_4.png"}
def.groups.growing = nil
def.drop = {
	items = {
		{items = {'farming:blackberry 2'}, rarity = 1},
		{items = {'farming:blackberry'}, rarity = 2},
		{items = {'farming:blackberry'}, rarity = 3},
	}
}
minetest.register_node("farming:blackberry_4", table.copy(def))

-- add to registered_plants
farming.registered_plants["farming:blackberry"] = {
	crop = "farming:blackberry",
	seed = "farming:blackberry",
	minlight = farming.min_light,
	maxlight = farming.max_light,
	steps = 4
}
