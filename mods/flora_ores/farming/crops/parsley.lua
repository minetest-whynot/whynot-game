local S = farming.intllib

-- item definition
minetest.register_craftitem("farming:parsley", {
	description = S("Parsley"),
	inventory_image = "farming_parsley.png",
	groups = {seed = 2, food_parsley = 1, flammable = 2},
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:parsley_1")
	end
})

-- crop definition
local def = {
	drawtype = "plantlike",
	tiles = {"farming_parsley_1.png"},
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
minetest.register_node("farming:parsley_1", table.copy(def))

-- stage 2
def.tiles = {"farming_parsley_2.png"}
minetest.register_node("farming:parsley_2", table.copy(def))

-- stage 3 (final)
def.tiles = {"farming_parsley_3.png"}
def.groups.growing = nil
def.drop = {
	items = {
		{items = {"farming:parsley 2"}, rarity = 1},
		{items = {"farming:parsley"}, rarity = 2},
		{items = {"farming:parsley"}, rarity = 3}
	}
}
minetest.register_node("farming:parsley_3", table.copy(def))

-- add to registered_plants
farming.registered_plants["farming:parsley"] = {
	crop = "farming:parsley",
	seed = "farming:parsley",
	minlight = 13,
	maxlight = 15,
	steps = 3
}
