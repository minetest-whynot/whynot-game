local rotate_disallow = rawget(_G, "screwdriver") and screwdriver.disallow or nil

local nodebox = {
	type = "fixed",
	fixed = {
		{-0.4375, -0.5, -0.0625, -0.3125, 0.5, 0.0625},
		{-0.0625, -0.5, -0.0625,  0.0625, 0.5, 0.0625},
		{ 0.3125, -0.5, -0.0625,  0.4375, 0.5, 0.0625},
		{ 0.125,  -0.5, -0.0625,  0.25,   0.5, 0.0625},
		{-0.25,   -0.5, -0.0625, -0.125,  0.5, 0.0625},
	}
}

minetest.register_node("my_misc_doors:door2a", {
	description = "Sliding Door",
	inventory_image = "mydoors_bars.png",
	tiles = {
		"mydoors_bars.png",
		"mydoors_bars.png",
		"mydoors_bars.png",
		"mydoors_bars.png",
		"mydoors_bars.png",
		"mydoors_bars.png",
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 3},
	node_box = table.copy(nodebox),
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.0625, 0.4375, 1.5, 0.0625},
		}
	},
	on_rotate = rotate_disallow,

	on_place = function(itemstack, placer, pointed_thing)
		local pos1 = pointed_thing.above
		local pos2 = vector.add(pos1, {x=0,y=1,z=0})

		if not placer or not placer:is_player() then
			return
		end

		if not minetest.registered_nodes[minetest.get_node(pos1).name].buildable_to or
		   not minetest.registered_nodes[minetest.get_node(pos2).name].buildable_to then
			minetest.chat_send_player(placer:get_player_name(), "Not enough room")
			return
		end

		local p2 = minetest.dir_to_facedir(placer:get_look_dir())
		local p4 = (p2+2)%4
		local pos3 = vector.add(pos1, minetest.facedir_to_dir((p2-1)%4))

		local player_name = placer:get_player_name()
		if minetest.is_protected(pos1, player_name) then
			minetest.record_protection_violation(pos1, player_name)
			return
		end
		if minetest.is_protected(pos2, player_name) then
			minetest.record_protection_violation(pos2, player_name)
			return
		end

		if minetest.get_node(pos3).name == "my_misc_doors:door2a" then
			minetest.set_node(pos1, {name="my_misc_doors:door2a", param2=p4})
			minetest.set_node(pos2, {name="my_misc_doors:door2b", param2=p4})
		else
			minetest.set_node(pos1, {name="my_misc_doors:door2a", param2=p2})
			minetest.set_node(pos2, {name="my_misc_doors:door2b", param2=p2})
		end

		if not (minetest.settings:get_bool("creative_mode") or minetest.check_player_privs(placer:get_player_name(), {creative = true})) then
			itemstack:take_item()
		end
		return itemstack
	end,
	after_destruct = function(pos, oldnode)
		minetest.set_node(vector.add(pos, {x=0,y=1,z=0}), {name="air"})
	end,
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		local timer = minetest.get_node_timer(pos)
		minetest.set_node(pos, {name="my_misc_doors:door2c", param2=node.param2})
		minetest.set_node(vector.add(pos, {x=0,y=1,z=0}), {name="my_misc_doors:door2d", param2=node.param2})

		-- Open neighbouring doors
		for i=0,3 do
			local dir = minetest.facedir_to_dir(i)
			local neighbour_pos = vector.add(pos, dir)
			local neighbour = minetest.get_node(neighbour_pos)
			if neighbour.name == "my_misc_doors:door2a" then
				minetest.set_node(neighbour_pos, {name="my_misc_doors:door2c", param2=neighbour.param2})
				minetest.set_node(vector.add(neighbour_pos, {x=0,y=1,z=0}), {name="my_misc_doors:door2d", param2=neighbour.param2})
			end
		end

		timer:start(3)
	end,
})
minetest.register_node("my_misc_doors:door2b", {
	tiles = {
		"mydoors_bars.png",
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 1},
	node_box = table.copy(nodebox),
	selection_box = {
		type = "fixed",
		fixed = {
			{0, 0, 0, 0, 0, 0},
		}
	},
	on_rotate = rotate_disallow,
})
minetest.register_node("my_misc_doors:door2c", {
	tiles = {
		"mydoors_bars.png",
		"mydoors_bars.png",
		"mydoors_bars.png",
		"mydoors_bars.png",
		"mydoors_bars.png^[transformFX",
		"mydoors_bars.png",
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.375, -0.0625, -0.3125, -0.5, 0.0625},
			{-0.0625, -0.375, -0.0625,  0.0625, -0.5, 0.0625},
			{ 0.3125, -0.375, -0.0625,  0.4375, -0.5, 0.0625},
			{ 0.125,  -0.375, -0.0625,  0.25,   -0.5, 0.0625},
			{-0.25,   -0.375, -0.0625, -0.125,  -0.5, 0.0625},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{0, 0, 0, 0, 0, 0},
		}
	},
	drop = "my_misc_doors:door2a",
	on_rotate = rotate_disallow,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		local node = minetest.get_node(pos)
		local timer = minetest.get_node_timer(pos)
		minetest.set_node(vector.add(pos, {x=0,y=1,z=0}), {name="my_misc_doors:door2d",param2=node.param2})
		timer:start(3)
	end,
	after_destruct = function(pos, oldnode)
		minetest.set_node(vector.add(pos, {x=0,y=1,z=0}), {name="air"})
	end,
	on_timer = function(pos, elapsed)
		local node = minetest.get_node(pos)
		minetest.set_node(pos, {name="my_misc_doors:door2a", param2=node.param2})
		minetest.set_node(vector.add(pos, {x=0,y=1,z=0}), {name="my_misc_doors:door2b", param2=node.param2})

		-- Close neighbouring doors
		for i=0,3 do
			local dir = minetest.facedir_to_dir(i)
			local neighbour_pos = vector.add(pos, dir)
			local neighbour = minetest.get_node(neighbour_pos)
			if neighbour.name == "my_misc_doors:door2c" then
				minetest.set_node(neighbour_pos, {name="my_misc_doors:door2a", param2=neighbour.param2})
				minetest.set_node(vector.add(neighbour_pos, {x=0,y=1,z=0}), {name="my_misc_doors:door2b", param2=neighbour.param2})
			end
		end
	end,
})
minetest.register_node("my_misc_doors:door2d", {
	tiles = {
		"mydoors_bars.png",
		"mydoors_bars.png",
		"mydoors_bars.png",
		"mydoors_bars.png",
		"mydoors_bars.png^[transformFX",
		"mydoors_bars.png",
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, 0.375, -0.0625, -0.3125, 0.5, 0.0625},
			{-0.0625, 0.375, -0.0625,  0.0625, 0.5, 0.0625},
			{ 0.3125, 0.375, -0.0625,  0.4375, 0.5, 0.0625},
			{ 0.125,  0.375, -0.0625,  0.25,   0.5, 0.0625},
			{-0.25,   0.375, -0.0625, -0.125,  0.5, 0.0625},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{0, 0, 0, 0, 0, 0},
		}
	},
	on_rotate = rotate_disallow,
})
minetest.register_craft({
	output = "my_misc_doors:door2a 1",
	recipe = {
		{"default:steelblock", "default:steel_ingot", ""},
		{"default:steel_ingot", "default:steel_ingot", ""},
		{"default:steelblock", "default:steel_ingot", ""}
	}
})
