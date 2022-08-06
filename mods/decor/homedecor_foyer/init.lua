local S = minetest.get_translator("homedecor_foyer")

homedecor.register("coatrack_wallmount", {
	tiles = { homedecor.plain_wood },
	inventory_image = "homedecor_coatrack_wallmount_inv.png",
	description = S("Wall-mounted coat rack"),
	groups = {snappy=3},
	sounds = default.node_sound_wood_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, 0, 0.4375, 0.375, 0.14, 0.5}, -- NodeBox1
			{-0.3025, 0.0475, 0.375, -0.26, 0.09, 0.4375}, -- NodeBox2
			{0.26, 0.0475, 0.375, 0.3025, 0.09, 0.4375}, -- NodeBox3
			{0.0725, 0.0475, 0.375, 0.115, 0.09, 0.4375}, -- NodeBox4
			{-0.115, 0.0475, 0.375, -0.0725, 0.09, 0.4375}, -- NodeBox5
			{0.24, 0.025, 0.352697, 0.3225, 0.115, 0.375}, -- NodeBox6
			{-0.3225, 0.025, 0.352697, -0.24, 0.115, 0.375}, -- NodeBox7
			{-0.135, 0.025, 0.352697, -0.0525, 0.115, 0.375}, -- NodeBox8
			{0.0525, 0.025, 0.352697, 0.135, 0.115, 0.375}, -- NodeBox9
		}
	},
})

homedecor.register("coat_tree", {
	mesh = "homedecor_coatrack.obj",
	tiles = {
		homedecor.plain_wood,
		"homedecor_generic_wood_old.png"
	},
	inventory_image = "homedecor_coatrack_inv.png",
	description = S("Coat tree"),
	groups = {snappy=3},
	sounds = default.node_sound_wood_defaults(),
	expand = { top="placeholder" },
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = { -0.4, -0.5, -0.4, 0.4, 1.5, 0.4 }
	},
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.rotate_simple or nil,
})

local mat_colors = {
	{ "green", S("Green welcome mat") },
	{ "brown", S("Brown welcome mat") },
	{ "grey",  S("Grey welcome mat") },
}

for _, mat in ipairs(mat_colors) do
	local color, desc = unpack(mat)
	homedecor.register("welcome_mat_"..color, {
		description = desc,
		tiles = {
			"homedecor_welcome_mat_"..color..".png",
			"homedecor_welcome_mat_bottom.png",
			"homedecor_welcome_mat_"..color..".png",
		},
		groups = {crumbly=3},
		sounds = default.node_sound_dirt_defaults({
			footstep = {name="default_grass_footstep", gain=0.25},
		}),
		node_box = {
			type = "fixed",
			fixed = { -0.5, -0.5, -0.375, 0.5, -0.46875, 0.375 }
		}
	})
end

-- crafting


minetest.register_craft({
    output = "homedecor:welcome_mat_grey 2",
    recipe = {
		{ "", "dye:black", "" },
		{ "wool:grey", "wool:grey", "wool:grey" },
    },
})

minetest.register_craft({
    output = "homedecor:welcome_mat_brown 2",
    recipe = {
		{ "", "dye:black", "" },
		{ "wool:brown", "wool:brown", "wool:brown" },
    },
})

minetest.register_craft({
    output = "homedecor:welcome_mat_green 2",
    recipe = {
		{ "", "dye:white", "" },
		{ "wool:dark_green", "wool:dark_green", "wool:dark_green" },
    },
})

minetest.register_craft({
    output = "homedecor:welcome_mat_green 2",
    recipe = {
		{ "", "dye:white", "" },
		{ "dye:black", "dye:black", "dye:black" },
		{ "wool:green", "wool:green", "wool:green" },
    },
})

minetest.register_craft( {
        output = "homedecor:coat_tree",
        recipe = {
			{ "group:stick", "group:stick", "group:stick" },
			{ "", "group:stick", "" },
			{ "", "group:wood", "" }
        },
})

minetest.register_craft( {
        output = "homedecor:coatrack_wallmount",
        recipe = {
			{ "group:stick", "homedecor:curtainrod_wood", "group:stick" },
        },
})
