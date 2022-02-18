-- formerly lrfurn endtable component

local S = minetest.get_translator("homedecor_tables")

minetest.register_node(":lrfurn:endtable", {
	description = S("End Table"),
	drawtype = "nodebox",
	tiles = {
		"lrfurn_coffeetable_back.png",
		"lrfurn_coffeetable_back.png",
		"lrfurn_coffeetable_back.png",
		"lrfurn_coffeetable_back.png",
		"lrfurn_coffeetable_back.png",
		"lrfurn_coffeetable_back.png"
	},
	paramtype = "light",
	paramtype2 = "facedir",
	use_texture_alpha = "blend",
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
	sounds = default.node_sound_wood_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
					--legs
					{-0.375, -0.5, -0.375, -0.3125, -0.0625, -0.3125},
					{0.3125, -0.5, -0.375, 0.375, -0.0625, -0.3125},
					{-0.375, -0.5, 0.3125, -0.3125, -0.0625, 0.375},
					{0.3125, -0.5, 0.3125, 0.375, -0.0625, 0.375},

					--tabletop
					{-0.4375, -0.0625, -0.4375, 0.4375, 0, 0.4375},
				}
	},
	selection_box = {
		type = "fixed",
		fixed = {
					{-0.4375, -0.5, -0.4375, 0.4375, 0.0, 0.4375},
				}
	},
})

minetest.register_craft({
	output = "lrfurn:endtable",
	recipe = {
		{"", "", "", },
		{"stairs:slab_wood", "stairs:slab_wood", "", },
		{"group:stick", "group:stick", "", }
	}
})

minetest.register_craft({
	output = "lrfurn:endtable",
	recipe = {
		{"", "", "", },
		{"moreblocks:slab_wood", "moreblocks:slab_wood", "", },
		{"group:stick", "group:stick", "", }
	}
})

if minetest.settings:get("log_mods") then
	minetest.log("action", "[lrfurn/endtable] Loaded!")
end
