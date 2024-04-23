-- Miscellanous tools and mechanical contrivances

local S = minetest.get_translator("home_workshop_misc")

minetest.register_node("home_workshop_misc:tool_cabinet", {
	description = S("Metal tool cabinet and work table"),
	drawtype="mesh",
	mesh = "home_workshop_misc_tool_cabinet.obj",
	tiles = {
		{ name = "home_workshop_common_generic_metal.png", color = 0xffd00000 },
		"home_workshop_misc_tool_cabinet_drawers.png",
		{ name = "home_workshop_common_generic_metal.png", color = 0xff006000 },
		{ name = "home_workshop_common_generic_metal.png", color = 0xffa0a0a0 },
		"home_workshop_common_generic_metal_bright.png",
		"home_workshop_misc_tool_cabinet_misc.png",
	},
	paramtype = "light",
	paramtype2="facedir",
	inventory_image = "home_workshop_misc_tool_cabinet_inv.png",
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.rotate_simple or nil,
	groups = { snappy=3, dig_tree=2 },
	is_ground_content = false,
	expand = { top="placeholder" },
	inventory = {
		size=24,
	}
})

minetest.register_node("home_workshop_misc:beer_tap", {
	description = S("Beer tap"),
	drawtype = "mesh",
	mesh = "home_workshop_misc_beer_taps.obj",
	tiles = {
		"home_workshop_common_generic_metal_bright.png",
		{ name = "home_workshop_common_generic_metal.png", color = 0xff303030 }
	},
	inventory_image = "home_workshop_misc_beertap_inv.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = { snappy=3, dig_tree=2 },
	is_ground_content = false,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = { -0.25, -0.5, -0.4375, 0.25, 0.235, 0 }
	},
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		local inv = clicker:get_inventory()
		if not itemstack then return end

		local wieldname = itemstack:get_name()
		if wieldname == "vessels:drinking_glass" then
			if inv:room_for_item("main", "home_workshop_misc:beer_mug 1") then
				inv:add_item("main", "home_workshop_misc:beer_mug 1")
				itemstack:take_item()
				clicker:set_wielded_item(itemstack)
				minetest.chat_send_player(clicker:get_player_name(),
						S("Ahh, a frosty cold beer - look in your inventory for it!"))
			else
				minetest.chat_send_player(clicker:get_player_name(),
						S("No room in your inventory to add a beer mug!"))
			end
		end
	end
})

local beer_cbox = {
	type = "fixed",
	fixed = { -5/32, -8/16, -9/32 , 7/32, -2/16, 1/32 }
}

minetest.register_node("home_workshop_misc:beer_mug", {
	description = S("Beer mug"),
	drawtype = "mesh",
	mesh = "home_workshop_misc_beer_mug.obj",
	tiles = { "home_workshop_misc_beer_mug.png" },
	inventory_image = "home_workshop_misc_beer_mug_inv.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = { snappy=3, oddly_breakable_by_hand=3 },
	is_ground_content = false,
	walkable = false,
	sounds = xcompat.sounds.node_sound_glass_defaults(),
	selection_box = beer_cbox,
	on_use = function(itemstack, user, pointed_thing)
		if not minetest.is_creative_enabled(user:get_player_name()) then
			minetest.do_item_eat(2, "vessels:drinking_glass 1", itemstack, user, pointed_thing)
			return itemstack
		end
	end
})

if minetest.get_modpath("homedecor_common") then
	minetest.register_alias("home_workshop_misc:drawer_small", "homedecor:drawer_small")
else
	minetest.register_craftitem("home_workshop_misc:drawer_small", {
			description = S("Small Wooden Drawer"),
			inventory_image = "home_workshop_common_drawer_small.png",
	})
end

local MODPATH = minetest.get_modpath("home_workshop_misc")
if minetest.get_modpath("basic_materials") then
	dofile(MODPATH.."/crafts.lua")
end

minetest.register_alias("homedecor:tool_cabinet",        "home_workshop_misc:tool_cabinet")
minetest.register_alias("homedecor:tool_cabinet_bottom", "home_workshop_misc:tool_cabinet")
minetest.register_alias("homedecor:tool_cabinet_top",    "air")

minetest.register_alias("homedecor:soda_machine",        "home_workshop_misc:soda_machine")
minetest.register_alias("homedecor:beer_tap",            "home_workshop_misc:beer_tap")
minetest.register_alias("homedecor:beer_mug",            "home_workshop_misc:beer_mug")
minetest.register_alias("homedecor:coin",                "currency:minegeld_cent_25")
