local S = minetest.get_translator("homedecor_pictures_and_paintings")

local pframe_cbox = {
	type = "fixed",
	fixed = { -0.18, -0.5, -0.08, 0.18, -0.08, 0.18 }
}
local n = { 1, 2 }

for _, i in ipairs(n) do
	homedecor.register("picture_frame"..i, {
		description = S("Picture Frame @1", i),
		mesh = "homedecor_picture_frame.obj",
		tiles = {
			"homedecor_picture_frame_image"..i..".png",
			homedecor.lux_wood,
			"homedecor_picture_frame_back.png",
		},
		inventory_image = "homedecor_picture_frame"..i.."_inv.png",
		wield_image = "homedecor_picture_frame"..i.."_inv.png",
		groups = {snappy = 3},
		selection_box = pframe_cbox,
		walkable = false,
		sounds = default.node_sound_glass_defaults()
	})
end

local p_cbox = {
	type = "fixed",
	fixed = {
		{ -0.5, -0.5, 0.4375, 0.5, 0.5, 0.5 }
	}
}

for i = 1,20 do
	homedecor.register("painting_"..i, {
		description = S("Decorative painting #@1", i),
		mesh = "homedecor_painting.obj",
		tiles = {
			"default_wood.png",
			"homedecor_blank_canvas.png",
			"homedecor_painting"..i..".png"
		},
		selection_box = p_cbox,
		walkable = false,
		groups = {snappy=3},
		sounds = default.node_sound_wood_defaults(),
	})
end

-- crafting

minetest.register_craftitem(":homedecor:blank_canvas", {
	description = S("Blank Canvas"),
	inventory_image = "homedecor_blank_canvas.png"
})

-- paintings

minetest.register_craft({
    output = "homedecor:blank_canvas",
    recipe = {
		{ "", "group:stick", "" },
		{ "group:stick", "wool:white", "group:stick" },
		{ "", "group:stick", "" },
    }
})

local painting_patterns = {
	[1] = {	{ "brown", "red", "brown" },
			{ "dark_green", "red", "green" } },

	[2] = {	{ "green", "yellow", "green" },
			{ "green", "yellow", "green" } },

	[3] = {	{ "green", "pink", "green" },
			{ "brown", "pink", "brown" } },

	[4] = {	{ "black", "orange", "grey" },
			{ "dark_green", "orange", "orange" } },

	[5] = {	{ "blue", "orange", "yellow" },
			{ "green", "red", "brown" } },

	[6] = {	{ "green", "red", "orange" },
			{ "orange", "yellow", "green" } },

	[7] = {	{ "blue", "dark_green", "dark_green" },
			{ "green", "grey", "green" } },

	[8] = {	{ "blue", "blue", "blue" },
			{ "green", "green", "green" } },

	[9] = {	{ "blue", "blue", "dark_green" },
			{ "green", "grey", "dark_green" } },

	[10] = { { "green", "white", "green" },
			 { "dark_green", "white", "dark_green" } },

	[11] = { { "blue", "white", "blue" },
			 { "blue", "grey", "dark_green" } },

	[12] = { { "green", "green", "green" },
			 { "grey", "grey", "green" } },

	[13] = { { "blue", "blue", "grey" },
			 { "dark_green", "white", "white" } },

	[14] = { { "red", "yellow", "blue" },
			 { "blue", "green", "violet" } },

	[15] = { { "blue", "yellow", "blue" },
			 { "black", "black", "black" } },

	[16] = { { "red", "orange", "blue" },
			 { "black", "dark_grey", "grey" } },

	[17] = { { "orange", "yellow", "orange" },
			 { "black", "black", "black" } },

	[18] = { { "grey", "dark_green", "grey" },
			 { "white", "white", "white" } },

	[19] = { { "white", "brown", "green" },
			 { "green", "brown", "brown" } },

	[20] = { { "blue", "blue", "blue" },
			 { "red", "brown", "grey" } }
}

for i,recipe in pairs(painting_patterns) do

	local item1 = "dye:"..recipe[1][1]
	local item2 = "dye:"..recipe[1][2]
	local item3 = "dye:"..recipe[1][3]
	local item4 = "dye:"..recipe[2][1]
	local item5 = "dye:"..recipe[2][2]
	local item6 = "dye:"..recipe[2][3]

	minetest.register_craft({
		output = "homedecor:painting_"..i,
		recipe = {
			{ item1, item2, item3 },
			{ item4, item5, item6 },
			{"", "homedecor:blank_canvas", "" }
		}
	})
end

local picture_dyes = {
	{"dye:brown", "dye:green"}, -- the figure sitting by the tree, wielding a pick
	{"dye:green", "dye:blue"}	-- the "family photo"
}

for i in ipairs(picture_dyes) do
	minetest.register_craft({
		output = "homedecor:picture_frame"..i,
		recipe = {
			{ picture_dyes[i][1], picture_dyes[i][2] },
			{ "homedecor:blank_canvas", "group:stick" },
		},
	})
end
