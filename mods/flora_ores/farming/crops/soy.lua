
local S = farming.intllib

-- soy pod
minetest.register_craftitem("farming:soy_pod", {
	description = S("Soy Pod"),
	inventory_image = "farming_soy_pod.png",
	groups = {seed = 2, food_soy = 1, food_soy_pod = 1, flammable = 2},
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:soy_1")
	end
})

-- replacement for soy beans that was removed
minetest.register_alias("farming:soy_beans", "farming:soy_pod")

-- soy sauce
minetest.register_node("farming:soy_sauce", {
	description = S("Soy Sauce"),
	drawtype = "plantlike",
	tiles = {"farming_soy_sauce.png"},
	inventory_image = "farming_soy_sauce.png",
	wield_image = "farming_soy_sauce.png",
	paramtype = "light",
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.3}
	},
	groups = {
		vessel = 1, food_soy_sauce = 1, dig_immediate = 3, attached_node = 1
	},
	sounds = default.node_sound_glass_defaults()
})

-- soy sauce recipe
minetest.register_craft( {
	output = "farming:soy_sauce",
	recipe = {
		{"group:food_soy", "group:food_salt", "group:food_soy"},
		{"", "group:food_juicer", ""},
		{"", "bucket:bucket_water", "vessels:glass_bottle"}
	},
	replacements = {
		{"bucket:bucket_water", "bucket:bucket_empty"},
		{"group:food_juicer", "farming:juicer"}
	}
})

-- soy milk
minetest.register_node("farming:soy_milk", {
	description = S("Soy Milk"),
	drawtype = "plantlike",
	tiles = {"farming_soy_milk_glass.png"},
	inventory_image = "farming_soy_milk_glass.png",
	wield_image = "farming_soy_milk_glass.png",
	paramtype = "light",
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.3}
	},
	on_use = minetest.item_eat(2, "vessels:drinking_glass"),
	groups = {
		vessel = 1, food_milk_glass = 1, dig_immediate = 3,
		attached_node = 1, drink = 1
	},
	sounds = default.node_sound_glass_defaults()
})

minetest.register_craft( {
	output = "farming:soy_milk",
	recipe = {
		{"group:food_soy", "group:food_soy", "group:food_soy"},
		{"farming:vanilla_extract", "bucket:bucket_water", "vessels:drinking_glass"}
	},
	replacements = {
		{"bucket:bucket_water", "bucket:bucket_empty"},
		{"farming:vanilla_extract", "vessels:glass_bottle"}
	}
})

-- tofu
minetest.register_craftitem("farming:tofu", {
	description = S("Tofu"),
	inventory_image = "farming_tofu.png",
	groups = {food_tofu = 1, food_meat_raw = 1, flammable = 2},
	on_use = minetest.item_eat(3)
})

minetest.register_craft({
	output = "farming:tofu",
	recipe = {
		{"farming:baking_tray", "group:food_soy", "group:food_soy"},
		{"group:food_soy", "group:food_soy", "group:food_soy"}
	},
	replacements = {{"farming:baking_tray", "farming:baking_tray"}}
})

-- cooked tofu
minetest.register_craftitem("farming:tofu_cooked", {
	description = S("Cooked Tofu"),
	inventory_image = "farming_tofu_cooked.png",
	groups = {food_meat = 1, flammable = 2},
	on_use = minetest.item_eat(6)
})

minetest.register_craft({
	type = "cooking",
	output = "farming:tofu_cooked",
	recipe = "farming:tofu",
	cooktime = 5
})

-- crop definition

local def = {
	drawtype = "plantlike",
	tiles = {"farming_soy_1.png"},
	paramtype = "light",
	paramtype2 = "meshoptions",
	place_param2 = 3,
	sunlight_propagates = true,
	waving = 1,
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
minetest.register_node("farming:soy_1", table.copy(def))

-- stage 2
def.tiles = {"farming_soy_2.png"}
minetest.register_node("farming:soy_2", table.copy(def))

-- stage 3
def.tiles = {"farming_soy_3.png"}
minetest.register_node("farming:soy_3", table.copy(def))

-- stage 4
def.tiles = {"farming_soy_4.png"}
minetest.register_node("farming:soy_4", table.copy(def))

-- stage 5
def.tiles = {"farming_soy_5.png"}
def.drop = {
	max_items = 1, items = {
		{items = {"farming:soy_pod"}, rarity = 1},
	}
}
minetest.register_node("farming:soy_5", table.copy(def))

-- stage 6
def.tiles = {"farming_soy_6.png"}
def.drop = {
	max_items = 3, items = {
		{items = {"farming:soy_pod"}, rarity = 1},
		{items = {"farming:soy_pod"}, rarity = 2},
		{items = {"farming:soy_pod"}, rarity = 3}
	}
}
minetest.register_node("farming:soy_6", table.copy(def))

-- stage 7
def.tiles = {"farming_soy_7.png"}
def.groups.growing = nil
def.drop = {
	max_items = 5, items = {
		{items = {"farming:soy_pod"}, rarity = 1},
		{items = {"farming:soy_pod"}, rarity = 2},
		{items = {"farming:soy_pod"}, rarity = 3},
		{items = {"farming:soy_pod"}, rarity = 4},
		{items = {"farming:soy_pod"}, rarity = 5}
	}
}
minetest.register_node("farming:soy_7", table.copy(def))

-- add to registered_plants
farming.registered_plants["farming:soy_pod"] = {
	crop = "farming:soy",
	seed = "farming:soy_pod",
	minlight = farming.min_light,
	maxlight = farming.max_light,
	steps = 7
}
