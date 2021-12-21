local S = farming.intllib

-- item definition
minetest.register_craftitem("farming:artichoke", {
	description = S("Artichoke"),
	inventory_image = "farming_artichoke.png",
	groups = {seed = 2, food_artichoke = 1, flammable = 2},
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:artichoke_1")
	end,
	on_use = minetest.item_eat(4)
})

-- crop definition
local def = {
	drawtype = "plantlike",
	tiles = {"farming_artichoke_1.png"},
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	drop =  "",
	selection_box = farming.select,
	groups = {
		snappy = 3, flammable = 2, plant = 1, attached_node = 1,
		not_in_creative_inventory = 1, growing = 1
	},
	sounds = default.node_sound_leaves_defaults()
}

-- stage 1
minetest.register_node("farming:artichoke_1", table.copy(def))

-- stage 2
def.tiles = {"farming_artichoke_2.png"}
minetest.register_node("farming:artichoke_2", table.copy(def))

-- stage 3
def.tiles = {"farming_artichoke_3.png"}
minetest.register_node("farming:artichoke_3", table.copy(def))

-- stage 4
def.tiles = {"farming_artichoke_4.png"}
minetest.register_node("farming:artichoke_4", table.copy(def))

-- stage 5 (final)
def.tiles = {"farming_artichoke_5.png"}
def.groups.growing = nil
def.drop = {
	items = {
		{items = {"farming:artichoke 2"}, rarity = 1},
		{items = {"farming:artichoke"}, rarity = 2}
	}
}
minetest.register_node("farming:artichoke_5", table.copy(def))

-- add to registered_plants
farming.registered_plants["farming:artichoke"] = {
	crop = "farming:artichoke",
	seed = "farming:artichoke",
	minlight = 13,
	maxlight = 15,
	steps = 5
}
