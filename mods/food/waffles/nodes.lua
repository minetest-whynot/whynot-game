local S = waffles.intllib

--Waffle Maker and Waffles--
local function get_waffle(player)
	local inv = player:get_inventory()
	inv:add_item("main", "waffles:large_waffle")
end
local function replace_emptymaker(pos, node)
	minetest.set_node(pos, {name = "waffles:wafflemaker_open_empty", param2 = node.param2})
end

minetest.register_node("waffles:wafflemaker", {
	description = S("Waffle Maker"),
	drawtype = "mesh",
	mesh = "wafflemaker.obj",
	tiles = {"wafflemaker_texture.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {snappy = 3},
	sounds = default.node_sound_stone_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
	},
	on_punch = function(pos, node, puncher, pointed_thing)
		minetest.set_node(pos, {name = "waffles:wafflemaker_open_empty", param2 = node.param2})
	end
})

minetest.register_node("waffles:wafflemaker_open_empty", {
	description = S("Open Waffle Maker (empty)"),
	drawtype = "mesh",
	mesh = "wafflemaker_open_empty.obj",
	tiles = {"wafflemaker_open_empty_texture.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {snappy = 3, not_in_creative_inventory=1},
	sounds = default.node_sound_stone_defaults(),
	drop = 'waffles:wafflemaker',
	selection_box = {
		type = "fixed",
		fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
		},
	},
	collision_box = {
		type = "fixed",
		fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
		},
	},
	on_punch = function(pos, node, puncher, pointed_thing)
		minetest.set_node(pos, {name = "waffles:wafflemaker", param2 = node.param2})
	end
})

minetest.register_node("waffles:wafflemaker_open_full", {
	description = S("Open Waffle Maker (full)"),
	drawtype = "mesh",
	mesh = "wafflemaker_open_full.obj",
	tiles = {"wafflemaker_open_full_texture.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {not_in_creative_inventory=1},
	sounds = default.node_sound_stone_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
		},
	},
	collision_box = {
		type = "fixed",
		fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
		},
	},
	on_punch = function(pos, node, puncher, pointed_thing)
		minetest.set_node(pos, { name = "waffles:wafflemaker_closed_full", param2 = node.param2 })
		minetest.after(5, minetest.set_node, pos, { name = "waffles:wafflemaker_open_done", param2 = node.param2 })
	end,
})

local function replace_donemodel(pos, node)
	minetest.set_node(pos, {name = "waffles:wafflemaker_open_done", param2 = node.param2})
end

minetest.register_node("waffles:wafflemaker_closed_full", {
	description = S("Closed Waffle Maker (full)"),
	drawtype = "mesh",
	mesh = "wafflemaker_closed_full.obj",
	tiles = {"wafflemaker_texture.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	diggable = false,
	groups = {not_in_creative_inventory=1},
	sounds = default.node_sound_stone_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
	},
})

minetest.register_node("waffles:wafflemaker_open_done", {
	description = S("Open Waffle Maker (done)"),
	drawtype = "mesh",
	mesh = "wafflemaker_open_done.obj",
	tiles = {"wafflemaker_open_done_texture.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {not_in_creative_inventory=1},
	sounds = default.node_sound_stone_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
		},
	},
	collision_box = {
		type = "fixed",
		fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
		},
	},
	on_punch = function (pos, node, player, pointed_thing)
		get_waffle(player)
		replace_emptymaker(pos, node)
	end
})

--Batter is stored in batter.lua for size reasons

minetest.register_craftitem("waffles:large_waffle", {
	description = S("Large Waffle"),
	inventory_image = "large_waffle.png",
	on_use = minetest.item_eat(8),
})

minetest.register_craftitem("waffles:small_waffle", {
	description = S("Small Waffle"),
	inventory_image = "small_waffle.png",
	on_use = minetest.item_eat(2),
})


--Toaster and Toast--

--Use homedecor toaster if detected--
if minetest.get_modpath("homedecor") then

function replace_emptytoaster(pos, node)
	minetest.set_node(pos, {name = "homedecor:toaster", param2 = node.param2})
end

minetest.register_node(":homedecor:toaster", {
	description = S("Toaster"),
	tiles = { "toaster_with_toast_sides.png" },
	inventory_image = "waffles_toaster_inv.png",
	walkable = false,
	groups = { snappy=3 },
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.125, 0.125, -0.3125, 0.125}, -- NodeBox1
		},
	},
})

minetest.register_alias("waffles:toaster", "homedecor:toaster")

else

--This mod registers it's own toaster--
function replace_emptytoaster(pos, node)
	minetest.set_node(pos, {name = "waffles:toaster", param2 = node.param2})
end

minetest.register_node("waffles:toaster", {
	description = S("Toaster"),
	tiles = { "toaster_with_toast_sides.png" },
	inventory_image = "waffles_toaster_inv.png",
	walkable = false,
	groups = { snappy=3 },
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.125, 0.125, -0.3125, 0.125}, -- NodeBox1
		},
	},
})

minetest.register_alias("homedecor:toaster", "waffles:toaster")

end

local function get_toast(player)
	local inv = player:get_inventory()
	inv:add_item("main", "waffles:toast 2")
	return inv:get_stack("main", player:get_wield_index())
end

minetest.register_craftitem(":farming:bread", {
	description = S("Bread"),
	inventory_image = "farming_bread.png",
	on_use = minetest.item_eat(5),
	groups = {flammable = 2},
})

minetest.register_craftitem("waffles:breadslice", {
	description = S("Slice of Bread"),
	inventory_image = "breadslice.png",
	groups = {flammable = 2},
	on_use = function(itemstack, user, pointed_thing)

		local node, pos
		if pointed_thing.under then
			pos = pointed_thing.under
			node = minetest.get_node(pos)
		end

		local pname = user:get_player_name()

		if node and pos and (node.name == "homedecor:toaster" or
				node.name == "waffles:toaster") then
			if minetest.is_protected(pos, pname) then
				minetest.record_protection_violation(pos, pname)
				else
					if itemstack:get_count() >= 2 then
						itemstack:take_item(2)
						minetest.set_node(pos, {name = "waffles:toaster_with_breadslice", param2 = node.param2})
					return itemstack
				end
			end
		else
			return minetest.do_item_eat(2, nil, itemstack, user, pointed_thing)
		end
	end,
})

minetest.register_craftitem("waffles:toast", {
	description = S("Toast"),
	inventory_image = "toast.png",
	on_use = minetest.item_eat(3),
	groups = {flammable = 2},
})

minetest.register_node("waffles:toaster_with_breadslice", {
	description = S("Toaster with Breadslice"),
	inventory_image = "waffles_toaster_inv.png",
	tiles = {
		"toaster_with_bread_top.png",
		"toaster_with_toast_sides.png",
		"toaster_with_toast_sides.png",
		"toaster_with_toast_sides.png",
		"toaster_with_toast_sides.png",
		"toaster_with_toast_sides.png"
	},
	walkable = false,
	groups = {not_in_creative_inventory=1},
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	diggable = false,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.125, 0.125, -0.3125, 0.125}, -- NodeBox1
			{-0.03125, -0.3125, -0.0935, 0, -0.25, 0.0935}, -- NodeBox2
			{0.0625, -0.3125, -0.0935, 0.0935, -0.25, 0.0935}, -- NodeBox3
		},
	},
	on_punch = function(pos, node, clicker, itemstack, pointed_thing)
		local fdir = node.param2
		minetest.set_node(pos, { name = "waffles:toaster_toasting_breadslice", param2 = fdir })
		minetest.after(6, minetest.set_node, pos, { name = "waffles:toaster_with_toast", param2 = fdir })
		minetest.sound_play("toaster", {
			pos = pos,
			gain = 1.0,
			max_hear_distance = 5
		})
		return itemstack
	end
})

minetest.register_node("waffles:toaster_toasting_breadslice", {
	description = S("Toaster Toasting Slice of Bread"),
	tiles = { "toaster_with_toast_toasting_sides.png" },
	inventory_image = "waffles_toaster_inv.png",
	walkable = false,
	groups = {not_in_creative_inventory = 1 },
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	diggable = false,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.125, 0.125, -0.3125, 0.125}, -- NodeBox1
		},
	},
})

minetest.register_node("waffles:toaster_with_toast", {
	description = S("Toaster with Toast"),
	inventory_image = "waffles_toaster_inv.png",
	tiles = {
		"toaster_with_toast_top.png",
		"toaster_with_toast_sides.png",
		"toaster_with_toast_side_crusts.png",
		"toaster_with_toast_side_crusts.png",
		"toaster_with_toast_end_crusts.png",
		"toaster_with_toast_end_crusts.png"
	},
	walkable = false,
	groups = { snappy=3, not_in_creative_inventory=1 },
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.125, 0.125, -0.3125, 0.125}, -- NodeBox1
			{-0.03125, -0.3125, -0.0935, 0, -0.25, 0.0935}, -- NodeBox2
			{0.0625, -0.3125, -0.0935, 0.0935, -0.25, 0.0935}, -- NodeBox3
		},
	},
	on_punch = function (pos, node, player, pointed_thing)
		get_toast(player)
		replace_emptytoaster(pos, node)
	end
})

--Toaster Waffles--
local function get_toaster_waffle(player)
	local inv = player:get_inventory()
	inv:add_item("main", "waffles:toaster_waffle 2")
	return inv:get_stack("main", player:get_wield_index())
end

minetest.register_craftitem("waffles:toaster_waffle", {
	description = S("Toaster Waffle"),
	inventory_image = "toaster_waffle.png",
	on_use = minetest.item_eat(4),
})

minetest.register_craftitem("waffles:toaster_waffle_pack", {
	description = S("Pack of 6 Toaster Waffles"),
	inventory_image = "toaster_waffle_pack_6.png",
	on_use = function(itemstack, user, pointed_thing)

		if pointed_thing.type ~= "node" then
			return
		end

		local pos = pointed_thing.under
		local pname = user:get_player_name()

		if minetest.is_protected(pos, pname) then
			minetest.record_protection_violation(pos, pname)
			return
		end

		local node = minetest.get_node(pos)

		if node.name == "homedecor:toaster"
		or node.name == "waffles:toaster" then
				minetest.set_node(pos, {name = "waffles:toaster_with_waffle", param2 = node.param2})
			return ItemStack("waffles:toaster_waffle_pack_4")
		end
	end,
})

minetest.register_craftitem("waffles:toaster_waffle_pack_4", {
	description = S("Pack of 4 Toaster Waffles"),
	inventory_image = "toaster_waffle_pack_4.png",
	groups = {not_in_creative_inventory = 1},
	on_use = function(itemstack, user, pointed_thing)

		if pointed_thing.type ~= "node" then
			return
		end

		local pos = pointed_thing.under
		local pname = user:get_player_name()

		if minetest.is_protected(pos, pname) then
			minetest.record_protection_violation(pos, pname)
			return
		end

		local node = minetest.get_node(pos)

		if node.name == "homedecor:toaster"
		or node.name == "waffles:toaster" then
				minetest.set_node(pos, {name = "waffles:toaster_with_waffle", param2 = node.param2})
			return ItemStack("waffles:toaster_waffle_pack_2")
		end
	end,
})

minetest.register_craftitem("waffles:toaster_waffle_pack_2", {
	description = S("Pack of 2 Toaster Waffles"),
	inventory_image = "toaster_waffle_pack_2.png",
	groups = {not_in_creative_inventory = 1},
	on_use = function(itemstack, user, pointed_thing)

		if pointed_thing.type ~= "node" then
			return
		end

		local pos = pointed_thing.under
		local pname = user:get_player_name()

		if minetest.is_protected(pos, pname) then
			minetest.record_protection_violation(pos, pname)
			return
		end

		local node = minetest.get_node(pos)

		if node.name == "homedecor:toaster"
		or node.name == "waffles:toaster" then
			itemstack:take_item()
			minetest.set_node(pos, {name = "waffles:toaster_with_waffle", param2 = node.param2})
			return itemstack
		end
	end,
})

minetest.register_node("waffles:toaster_with_waffle", {
	description = S("Toaster with Waffle"),
	inventory_image = "waffles_toaster_inv.png",
	tiles = {
		"toaster_with_waffle_top.png",
		"toaster_with_waffle_sides.png",
		"toaster_with_waffle_side_crusts.png",
		"toaster_with_waffle_side_crusts.png",
		"toaster_with_waffle_end_crusts.png",
		"toaster_with_waffle_end_crusts.png"
	},
	walkable = false,
	groups = {not_in_creative_inventory=1},
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	diggable = false,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.125, 0.125, -0.3125, 0.125}, -- NodeBox1
			{-0.03125, -0.3125, -0.0935, 0, -0.25, 0.0935}, -- NodeBox2
			{0.0625, -0.3125, -0.0935, 0.0935, -0.25, 0.0935}, -- NodeBox3
		},
	},
	on_punch = function(pos, node, clicker, itemstack, pointed_thing)
		local fdir = node.param2
		minetest.set_node(pos, { name = "waffles:toaster_toasting_waffle", param2 = fdir })
		minetest.after(6, minetest.set_node, pos, { name = "waffles:toaster_with_toasted_waffle", param2 = fdir })
		minetest.sound_play("toaster", {
			pos = pos,
			gain = 1.0,
			max_hear_distance = 5
		})
		return itemstack
	end
})

minetest.register_node("waffles:toaster_toasting_waffle", {
	description = S("Toaster Toasting Waffle"),
	tiles = { "toaster_with_waffle_toasting_sides.png" },
	inventory_image = "waffles_toaster_inv.png",
	walkable = false,
	groups = {not_in_creative_inventory = 1 },
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	diggable = false,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.125, 0.125, -0.3125, 0.125}, -- NodeBox1
		},
	},
})

minetest.register_node("waffles:toaster_with_toasted_waffle", {
	description = S("Toaster with Toasted Waffle"),
	inventory_image = "waffles_toaster_inv.png",
	tiles = {
		"toaster_with_waffle_toasted_top.png",
		"toaster_with_waffle_toasted_sides.png",
		"toaster_with_waffle_toasted_sides.png",
		"toaster_with_waffle_toasted_sides.png",
		"toaster_with_waffle_toasted_end_crusts.png",
		"toaster_with_waffle_toasted_end_crusts.png"
	},
	walkable = false,
	groups = { snappy=3, not_in_creative_inventory=1 },
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.125, 0.125, -0.3125, 0.125}, -- NodeBox1
			{-0.03125, -0.3125, -0.0935, 0, -0.25, 0.0935}, -- NodeBox2
			{0.0625, -0.3125, -0.0935, 0.0935, -0.25, 0.0935}, -- NodeBox3
		},
	},
	on_punch = function (pos, node, player, pointed_thing)
		get_toaster_waffle(player)
		replace_emptytoaster(pos, node)
	end
})
