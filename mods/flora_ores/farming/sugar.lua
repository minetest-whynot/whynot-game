
local S = farming.intllib

--= Sugar

minetest.register_craftitem("farming:sugar", {
	description = S("Sugar"),
	inventory_image = "farming_sugar.png",
})

minetest.register_craft({
	type = "cooking",
	cooktime = 3,
	output = "farming:sugar 2",
	recipe = "default:papyrus",
})


--= Salt

minetest.register_node("farming:salt", {
	description = ("Salt"),
	inventory_image = "farming_salt.png",
	wield_image = "farming_salt.png",
	drawtype = "plantlike",
	paramtype = "light",
	tiles = {"farming_salt.png"},
	groups = {vessel = 1, salt = 1, dig_immediate = 3, attached_node = 1},
	sounds = default.node_sound_glass_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.3, 0.25}
	},
})

minetest.register_craft({
	type = "cooking",
	cooktime = 15,
	output = "farming:salt",
	recipe = "bucket:bucket_water",
	replacements = {{"bucket:bucket_water", "bucket:bucket_empty"}}
})
