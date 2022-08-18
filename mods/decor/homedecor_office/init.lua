local S = minetest.get_translator("homedecor_office")

homedecor.register("filing_cabinet", {
	description = S("Filing cabinet"),
	mesh = "homedecor_filing_cabinet.obj",
	tiles = {
		homedecor.plain_wood,
		"homedecor_filing_cabinet_front.png",
		"homedecor_filing_cabinet_bottom.png"
	},
	groups = { snappy = 3, dig_tree=2 },
	_sound_def = {
		key = "node_sound_wood_defaults",
	},
	infotext=S("Filing cabinet"),
	inventory = {
		size=16,
		lockable=true,
	},
	crafts = {
		{
			recipe = {
				{ "", "group:wood", "" },
				{ "group:wood", "homedecor:drawer_small", "group:wood" },
				{ "", "group:wood", "" },
			},
		}
	}
})

local desk_cbox = {
	type = "fixed",
	fixed = { -0.5, -0.5, -0.5, 1.5, 0.5, 0.5 }
}
homedecor.register("desk", {
	description = S("Desk"),
	mesh = "homedecor_desk.obj",
	tiles = {
		homedecor.plain_wood,
		"homedecor_desk_drawers.png",
		{ name = "homedecor_generic_metal.png", color = homedecor.color_black }
	},
	inventory_image = "homedecor_desk_inv.png",
	selection_box = desk_cbox,
	collision_box = desk_cbox,
	_sound_def = {
		key = "node_sound_wood_defaults",
	},
	groups = { snappy = 3, dig_tree=2 },
	expand = { right="placeholder" },
	inventory = {
		size=24,
		lockable=true,
	},
	crafts = {
		{
			recipe = {
				{ "slab_wood", "slab_wood", "slab_wood" },
				{ "homedecor:drawer_small", "group:wood", "group:wood" },
				{ "homedecor:drawer_small", "", "group:wood" },
			},
		},
		{
			recipe = {
				{ "moreblocks:slab_wood", "moreblocks:slab_wood", "moreblocks:slab_wood" },
				{ "homedecor:drawer_small", "group:wood", "group:wood" },
				{ "homedecor:drawer_small", "", "group:wood" },
			},
		}
	}
})
minetest.register_alias("homedecor:desk_r", "air")

local globe_cbox = {
	type = "fixed",
	fixed = { -0.4, -0.5, -0.3, 0.3, 0.3, 0.3 }
}

homedecor.register("desk_globe", {
	description = S("Desk globe"),
	mesh = "homedecor_desk_globe.obj",
	tiles = {
		"homedecor_generic_wood_red.png",
		{ name = "homedecor_generic_metal.png", color = homedecor.color_med_grey },
		"homedecor_earth.png"
	},
	inventory_image = "homedecor_desk_globe_inv.png",
	selection_box = globe_cbox,
	collision_box = globe_cbox,
	groups = {choppy=2, oddly_breakable_by_hand=2},
	walkable = false,
	_sound_def = {
		key = "node_sound_wood_defaults",
	},
	crafts = {
		{
			recipe = {
				{ "group:stick", "basic_materials:plastic_sheet", "dye_green" },
				{ "group:stick", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
				{ "group:stick", "slab_wood", "dye_blue" }
			},
		},
		{
			recipe = {
				{ "group:stick", "basic_materials:plastic_sheet", "dye_green" },
				{ "group:stick", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
				{ "group:stick", "moreblocks:slab_wood", "dye_blue" }
			},
		}
	}
})

homedecor.register("calendar", {
	description = S("Calendar"),
	mesh = "homedecor_calendar.obj",
	tiles = {"homedecor_calendar.png"},
	inventory_image = "homedecor_calendar_inv.png",
	wield_image = "homedecor_calendar_inv.png",
	paramtype2 = "wallmounted",
	walkable = false,
	selection_box = {
		type = "wallmounted",
		wall_side =   { -8/16, -8/16, -4/16, -5/16,  5/16, 4/16 },
		wall_bottom = { -4/16, -8/16, -8/16,  4/16, -5/16, 5/16 },
		wall_top =    { -4/16,  5/16, -8/16,  4/16,  8/16, 5/16 }
	},
	use_texture_alpha = "clip",
	groups = {choppy=2,attached_node=1, dig_tree=2},
	legacy_wallmounted = true,
	_sound_def = {
		key = "node_sound_default",
	},
	infotext = S("Date (right-click to update):\n@1", os.date("%Y-%m-%d")), -- ISO 8601 format
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		local meta = minetest.get_meta(pos)
		local date = os.date("%Y-%m-%d")
		meta:set_string("infotext", S("Date (right-click to update):\n@1", date))
		return itemstack
	end,
	crafts = {
		{
			recipe = {
				{ "","dye_red","" },
				{ "","dye_black","" },
				{ "","paper","" }
			},
		}
	}
})