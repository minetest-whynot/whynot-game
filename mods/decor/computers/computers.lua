local S = minetest.get_translator("computers")

-- Amiga 500 lookalike
computers.register("computers:shefriendSOO", {
	description = S("SheFriendSOO"),
	tiles_off = { front=true },
	node_box = computers.pixelnodebox(32, {
		-- X   Y   Z   W   H   L
		{  0,  0, 17, 32, 32, 12 },   -- Monitor Screen
		{  3,  3, 29, 26, 26,  3 },   -- Monitor Tube
		{  0,  0,  0, 32,  4, 17 }   -- Keyboard
	})
})

-- Some generic laptop
minetest.register_node("computers:vanio", {
	drawtype = "mesh",
	mesh = "computers_laptop.obj",
	description = S("Pony Vanio"),
	inventory_image = "computers_laptop_inv.png",
	tiles = {"computers_laptop.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 4,
	groups = {snappy=3},
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.35, -0.5, -0.35, 0.35, 0.05, 0.35},
	},
	on_rightclick = function(pos, node, clicker, itemstack)
		node.name = "computers:vanio_off"
		minetest.set_node(pos, node)
		return itemstack
	end
})

minetest.register_node("computers:vanio_off", {
	drawtype = "mesh",
	mesh = "computers_laptop_closed.obj",
	tiles = {"computers_laptop.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {snappy=3, not_in_creative_inventory=1},
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.35, -0.5, -0.35, 0.35, -0.4, 0.25},
	},
	drop = "computers:vanio",
	on_rightclick = function(pos, node, clicker, itemstack)
		node.name = "computers:vanio"
		minetest.set_node(pos, node)
		return itemstack
	end
})

-- Sinclair ZX Spectrum lookalike
computers.register("computers:specter", {
	description = S("SX Specter"),
	inventory_image = "computers_specter_inv.png",
	tiles_off = { },
	node_box = computers.pixelnodebox(32, {
		-- X   Y   Z   W   H   L
		{  3,  0,  0, 26,  4, 17 },   -- Keyboard
		{ 18,  0, 18, 12,  6, 14 }   -- Tape Player
	})
})

-- Apple iPad lookalike
minetest.register_node("computers:piepad", {
	description = S("Snapple Piepad"),
	drawtype = "signlike",
	tiles = {"computers_piepad_inv.png"},
	inventory_image = "computers_piepad_inv.png",
	wield_image = "computers_piepad_inv.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	light_source = 8,
	walkable = false,
	groups = {oddly_breakable_by_hand=2},
	selection_box = {type = "wallmounted"},
	sounds = default and default.node_sound_wood_defaults() or nil
})

-- Commodore 64 lookalike
computers.register("computers:admiral64", {
	description = S("Admiral64"),
	inventory_image = "computers_ad64_inv.png",
	tiles_off = { },
	node_box = computers.pixelnodebox(32, {
		-- X   Y   Z   W   H   L
		{  0,  0,  0, 32,  4, 18 }   -- Keyboard
	})
})

-- Commodore 128 lookalike
computers.register("computers:admiral128", {
	description = S("Admiral128"),
	inventory_image = "computers_ad128_inv.png",
	tiles_off = { },
	node_box = computers.pixelnodebox(32, {
		-- X   Y   Z   W   H   L
		{  0,  0,  0, 32,  4, 27 }   -- Keyboard
	})
})

-- Generic Flat Screen LCD (16x9) with keyboard
local mo_sbox = {
	type = "fixed",
	fixed = { -0.5, -0.5, -0.43, 0.5, 0.2, 0.25 }
}

minetest.register_node("computers:monitor", {
	description = S("Monitor and keyboard"),
	inventory_image = "computers_monitor_inv.png",
	drawtype = "mesh",
	mesh = "computers_monitor.obj",
	tiles = {
		"computers_black.png", "computers_monitor_plastic.png", "computers_black.png", "computers_monitor_plastic.png"
	},
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = false,
	groups = {snappy=3},
	selection_box = mo_sbox,
	on_rightclick = function(pos, node, clicker, itemstack)
		node.name = "computers:monitor_on"
		minetest.set_node(pos, node)
		return itemstack
	end
})

minetest.register_node("computers:monitor_on", {
	drawtype = "mesh",
	mesh = "computers_monitor.obj",
	tiles = {
		"computers_monitor_display.png^[transformFX",
		"computers_monitor_plastic.png",
		"computers_black.png",
		"computers_monitor_plastic.png"
	},
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 9,
	walkable = false,
	groups = {snappy=3, not_in_creative_inventory=1},
	selection_box = mo_sbox,
	drop = "computers:monitor",
	on_rightclick = function(pos, node, clicker, itemstack)
		node.name = "computers:monitor"
		minetest.set_node(pos, node)
		return itemstack
	end
})

--WIFI Router (linksys look-a-like)
minetest.register_node("computers:router", {
	description = S("WIFI Router"),
	inventory_image = "computers_router_inv.png",
	tiles = {
		"computers_router_t.png",
		"computers_router_bt.png",
		"computers_router_l.png",
		"computers_router_r.png",
		"computers_router_b.png",
		{
			name = "computers_router_f_animated.png",
			animation = {type="vertical_frames", aspect_w=32, aspect_h=32, length=1.0}
		},
	}, --"computers_router_f.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = false,
	groups = {snappy=3},
	sound = default and default.node_sound_wood_defaults() or nil,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.5, -0.0625, 0.25, -0.375, 0.3125},
			{-0.1875, -0.4375, 0.3125, -0.125, -0.1875, 0.375},
			{0.125, -0.4375, 0.3125, 0.1875, -0.1875, 0.375},
			{-0.0625, -0.4375, 0.3125, 0.0625, -0.25, 0.375}
		}
	}
})

local pct_cbox = {
	type = "fixed",
	fixed = { -0.1875, -0.5, -0.36, 0.1875, 0.34, 0.46 }
}

--Modern PC Tower
minetest.register_node("computers:tower", {
	description = S("Computer Tower"),
	inventory_image = "computers_tower_inv.png",
	drawtype = "mesh",
	mesh = "computers_tower.obj",
	tiles = {"computers_tower.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {snappy=3},
	sound = default and default.node_sound_wood_defaults() or nil,
	selection_box = pct_cbox,
	collision_box = pct_cbox
})

--Rack Server
minetest.register_node("computers:server", {
	drawtype = "nodebox",
	description = S("Rack Server"),
	tiles = {
		'computers_server_t.png',
		'computers_server_bt.png',
		'computers_server_l.png',
		'computers_server_r.png',
		'computers_server_bt.png',
		'computers_server_f_off.png'
	},
	inventory_image = "computers_server_inv.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {snappy=3},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.25, 0.5, 1.125, 0.4375}
	},
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.25, 0.5, 1.125, 0.4375}
	},
	sounds = default and default.node_sound_wood_defaults() or nil,
	on_rightclick = function(pos, node, clicker, itemstack)
		node.name = "computers:server_on"
		minetest.set_node(pos, node)
		return itemstack
	end,
	on_place = function(itemstack, placer, pointed_thing)
		local pos = pointed_thing.above
		if minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z}).name ~= "air" then
			minetest.chat_send_player( placer:get_player_name(),
					S("Not enough vertical space to place a server!" ))
			return itemstack
		end
		return minetest.item_place(itemstack, placer, pointed_thing)
	end
})

minetest.register_node("computers:server_on", {
	drawtype = "nodebox",
	tiles = {
		'computers_server_t.png',
		'computers_server_bt.png',
		'computers_server_l.png',
		'computers_server_r.png',
		'computers_server_bt.png',
		'computers_server_f_on.png',
	},
	inventory_image = "computers_server_inv.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {snappy=3,not_in_creative_inventory=1},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.25, 0.5, 1.125, 0.4375}
	},
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.25, 0.5, 1.125, 0.4375}
	},
	sounds = default and default.node_sound_wood_defaults() or nil,
	drop = 'computers:server',
	on_rightclick = function(pos, node, clicker, itemstack)
		node.name = "computers:server"
		minetest.set_node(pos, node)
		return itemstack
	end
})

-- Printer of some kind

minetest.register_node("computers:printer", {
	description = S("Printer-Scanner Combo"),
	inventory_image = "computers_printer_inv.png",
	tiles = {"computers_printer_t.png","computers_printer_bt.png","computers_printer_l.png",
			"computers_printer_r.png","computers_printer_b.png","computers_printer_f.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = true,
	groups = {snappy=3},
	sound = default and default.node_sound_wood_defaults() or nil,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.3125, -0.125, 0.4375, -0.0625, 0.375},
			{-0.4375, -0.5, -0.125, 0.4375, -0.4375, 0.375},
			{-0.4375, -0.5, -0.125, -0.25, -0.0625, 0.375},
			{0.25, -0.5, -0.125, 0.4375, -0.0625, 0.375},
			{-0.4375, -0.5, -0.0625, 0.4375, -0.0625, 0.375},
			{-0.375, -0.4375, 0.25, 0.375, -0.0625, 0.4375},
			{-0.25, -0.25, 0.4375, 0.25, 0.0625, 0.5},
			{-0.25, -0.481132, -0.3125, 0.25, -0.4375, 0}
		},
	},
})
