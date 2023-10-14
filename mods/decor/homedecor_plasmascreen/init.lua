local S = minetest.get_translator("homedecor_plasmascreen")

local sc_disallow = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil

homedecor.register("tv_stand", {
	description = S("Plasma Screen TV Stand"),
	tiles = {"homedecor_plasmascreen_back.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{0.5000,-0.5000,0.0625,-0.5000,-0.4375,-0.5000}, --NodeBox 1
			{-0.1875,-0.5000,-0.3750,0.1875,0.1250,-0.1250}, --NodeBox 2
			{-0.5000,-0.2500,-0.5000,0.5000,0.5000,-0.3750}, --NodeBox 3
			{-0.3750,-0.1875,-0.3750,0.3750,0.3125,-0.2500}, --NodeBox 4
		}
	},
	selection_box = {
		type = "fixed",
			fixed = {
			{-0.5000, -0.5000, -0.5000, 0.5000, 0.5000, 0.0000},
		}
	},
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2},
	crafts = {
		{
			recipe = {
				{'', '', ''},
				{'', 'steel_ingot', ''},
				{'group:stick', 'coal_lump', 'group:stick'},
			}
		}
	}
})

local fdir_to_left = {
	{ -1,  0 },
	{  0,  1 },
	{  1,  0 },
	{  0, -1 },
}

local fdir_to_right = {
	{  1,  0 },
	{  0, -1 },
	{ -1,  0 },
	{  0,  1 },
}

local tv_cbox = {
	type = "fixed",
	fixed = {-1.5050, -0.3125, 0.3700, 1.5050, 1.5050, 0.5050}
}

local function checkwall(pos)

	local fdir = minetest.get_node(pos).param2

	local dxl = fdir_to_left[fdir + 1][1]	-- dxl = "[D]elta [X] [L]eft"
	local dzl = fdir_to_left[fdir + 1][2]	-- Z left

	local dxr = fdir_to_right[fdir + 1][1]	-- X right
	local dzr = fdir_to_right[fdir + 1][2]	-- Z right

	local node1 = minetest.get_node({x=pos.x+dxl, y=pos.y, z=pos.z+dzl})
	if not node1 or not minetest.registered_nodes[node1.name]
	  or not minetest.registered_nodes[node1.name].buildable_to then
		return false
	end

	local node2 = minetest.get_node({x=pos.x+dxr, y=pos.y, z=pos.z+dzr})
	if not node2 or not minetest.registered_nodes[node2.name]
	  or not minetest.registered_nodes[node2.name].buildable_to then
		return false
	end

	local node3 = minetest.get_node({x=pos.x+dxl, y=pos.y+1, z=pos.z+dzl})
	if not node3 or not minetest.registered_nodes[node3.name]
	  or not minetest.registered_nodes[node3.name].buildable_to then
		return false
	end

	local node4 = minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z})
	if not node4 or not minetest.registered_nodes[node4.name]
	  or not minetest.registered_nodes[node4.name].buildable_to then
		return false
	end

	local node5 = minetest.get_node({x=pos.x+dxr, y=pos.y+1, z=pos.z+dzr})
	if not node5 or not minetest.registered_nodes[node5.name]
	  or not minetest.registered_nodes[node5.name].buildable_to then
		return false
	end

	return true
end

homedecor.register("tv", {
	description = S("Plasma TV"),
	drawtype = "mesh",
	mesh = "homedecor_plasmascreen_tv.obj",
	tiles = {
		"homedecor_plasmascreen_case.png",
		{ name="homedecor_plasmascreen_video.png",
			animation={
				type="vertical_frames",
				aspect_w = 42,
				aspect_h = 23,
				length = 44
			}
		}

	},
	inventory_image = "homedecor_plasmascreen_tv_inv.png",
	wield_image = "homedecor_plasmascreen_tv_inv.png",
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 10,
	selection_box = tv_cbox,
	collision_box = tv_cbox,
	on_rotate = sc_disallow or nil,
	groups = {snappy=1, choppy=2, oddly_breakable_by_hand=2},
	after_place_node = function(pos, placer, itemstack)
		if not checkwall(pos) then
			minetest.set_node(pos, {name = "air"})
			return true	-- "API: If return true no item is taken from itemstack"
		end
	end,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		minetest.set_node(pos, {name = "homedecor:tv_off", param2 = node.param2})
	end,
	crafts = {
		{
			recipe = {
				{'glass_block', 'coal_lump', 'glass_block'},
				{'steel_ingot', 'copper_ingot', 'steel_ingot'},
				{'glass_block', 'glass_block', 'glass_block'},
			}
		},
		{
			type = "shapeless",
			recipe = {'homedecor:television', 'homedecor:television'},
		}
	}
})

homedecor.register("tv_off", {
	description = S("Plasma TV (off)"),
	drawtype = "mesh",
	mesh = "homedecor_plasmascreen_tv.obj",
	tiles = {
		"homedecor_plasmascreen_case_off.png",
		"homedecor_plasmascreen_screen_off.png",
	},
	inventory_image = "homedecor_plasmascreen_tv_inv.png",
	wield_image = "homedecor_plasmascreen_tv_inv.png",
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 10,
	selection_box = tv_cbox,
	collision_box = tv_cbox,
	on_rotate = sc_disallow or nil,
	groups = {snappy=1, choppy=2, oddly_breakable_by_hand=2, not_in_creative_inventory=1},
	after_place_node = function(pos, placer, itemstack)
		if not checkwall(pos) then
			minetest.set_node(pos, {name = "air"})
			return true	-- "API: If return true no item is taken from itemstack"
		end
	end,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		minetest.set_node(pos, {name = "homedecor:tv", param2 = node.param2})
	end,
	drop = "homedecor:tv",
})

minetest.register_alias("plasmascreen:screen1", "air")
minetest.register_alias("plasmascreen:screen2", "air")
minetest.register_alias("plasmascreen:screen3", "air")
minetest.register_alias("plasmascreen:screen4", "air")
minetest.register_alias("plasmascreen:screen6", "air")
minetest.register_alias("plasmascreen:screen5", "homedecor:tv")
minetest.register_alias("plasmascreen:stand", "homedecor:tv_stand")
minetest.register_alias("plasmascreen:tv", "homedecor:tv")
minetest.register_alias("plasmascreen:tv_off", "homedecor:tv_off")