
local S = farming.intllib

-- melon
minetest.register_craftitem("farming:melon_slice", {
	description = S("Melon Slice"),
	inventory_image = "farming_melon_slice.png",
	groups = {seed = 2, food_melon_slice = 1, flammable = 3},
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:melon_1")
	end,
	on_use = minetest.item_eat(2)
})

minetest.register_craft({
	output = "farming:melon_8",
	recipe = {
		{"farming:melon_slice", "farming:melon_slice"},
		{"farming:melon_slice", "farming:melon_slice"}
	}
})

minetest.register_craft({
	output = "farming:melon_slice 4",
	recipe = {{"farming:cutting_board", "farming:melon_8"}},
	replacements = {{"farming:cutting_board", "farming:cutting_board"}}
})

-- melon definition
local def = {
	drawtype = "plantlike",
	tiles = {"farming_melon_1.png"},
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
minetest.register_node("farming:melon_1", table.copy(def))

-- stage 2
def.tiles = {"farming_melon_2.png"}
minetest.register_node("farming:melon_2", table.copy(def))

-- stage 3
def.tiles = {"farming_melon_3.png"}
minetest.register_node("farming:melon_3", table.copy(def))

-- stage 4
def.tiles = {"farming_melon_4.png"}
minetest.register_node("farming:melon_4", table.copy(def))

-- stage 5
def.tiles = {"farming_melon_5.png"}
minetest.register_node("farming:melon_5", table.copy(def))

-- stage 6
def.tiles = {"farming_melon_6.png"}
minetest.register_node("farming:melon_6", table.copy(def))

-- stage 7
def.tiles = {"farming_melon_7.png"}
minetest.register_node("farming:melon_7", table.copy(def))

-- stage 8 (final)
minetest.register_node("farming:melon_8", {
	description = S("Melon"),
	tiles = {
		"farming_melon_top.png",
		"farming_melon_bottom.png",
		"farming_melon_side.png"
	},
	groups = {
		food_melon = 1, snappy = 2, oddly_breakable_by_hand = 1,
		flammable = 2, plant = 1
	},
	drop = "farming:melon_8",
	sounds = default.node_sound_wood_defaults(),
	paramtype2 = "facedir",
	on_place = minetest.rotate_node
})

-- add to registered_plants
farming.registered_plants["farming:melon"] = {
	crop = "farming:melon",
	seed = "farming:melon_slice",
	minlight = farming.min_light,
	maxlight = farming.max_light,
	steps = 8
}
