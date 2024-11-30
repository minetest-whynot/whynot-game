local rotate_disallow = rawget(_G, "screwdriver") and screwdriver.disallow or nil

local doors = {
	{"my_future_doors:door2a","my_future_doors:door2b","my_future_doors:door2c","my_future_doors:door2d","2","Steel",
			{{"default:steel_ingot", "default:steelblock", ""},
				{"default:steel_ingot", "default:steel_ingot", ""},
				{"default:steelblock", "default:steel_ingot", ""}}},
	{"my_future_doors:door3a","my_future_doors:door3b","my_future_doors:door3c","my_future_doors:door3d","3","Squared",
			{{"default:steel_ingot","default:steel_ingot", ""},
				{"default:steel_ingot", "default:steel_ingot", ""},
				{"default:steelblock", "default:steelblock", ""}}},
	{"my_future_doors:door4a","my_future_doors:door4b","my_future_doors:door4c","my_future_doors:door4d","4","Dark",
			{{"default:steel_ingot","default:steel_ingot", ""},
				{"default:steel_ingot", "default:steel_ingot", "dye:black"},
				{"default:steelblock", "default:steelblock", ""}}},
	{"my_future_doors:door6a","my_future_doors:door6b","my_future_doors:door6c","my_future_doors:door6d","6","Points",
			{{"default:steel_ingot","default:steel_ingot", ""},
				{"default:steelblock", "default:steelblock", ""},
				{"default:steel_ingot", "default:steel_ingot", ""}}},
	{"my_future_doors:door7a","my_future_doors:door7b","my_future_doors:door7c","my_future_doors:door7d","7","Snow Flake",
			{{"default:steel_ingot", "default:steelblock", ""},
				{"default:steel_ingot", "default:steel_ingot", ""},
				{ "default:steel_ingot", "default:steelblock",""}}},
	{"my_future_doors:door8a","my_future_doors:door8b","my_future_doors:door8c","my_future_doors:door8d","8","Blue Steel",
			{{"default:steel_ingot", "default:steelblock", ""},
				{"default:steel_ingot", "default:steel_ingot", "dye:blue"},
				{ "default:steel_ingot", "default:steelblock",""}}},
	{"my_future_doors:door9a","my_future_doors:door9b","my_future_doors:door9c","my_future_doors:door9d","9","Tan Steel",
			{{"default:steel_ingot", "default:steelblock", ""},
				{"default:steel_ingot", "default:steel_ingot", "dye:brown"},
				{ "default:steel_ingot", "default:steelblock",""}}},
}

local function add_door(doora, doorb, doorc, doord, num, des, recipe)
	local function onplace(itemstack, placer, pointed_thing)
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

		if minetest.get_node(pos3).name == doora then
			minetest.set_node(pos1, {name=doora, param2=p4})
			minetest.set_node(pos2, {name=doorb, param2=p4})
		else
			minetest.set_node(pos1, {name=doora, param2=p2})
			minetest.set_node(pos2, {name=doorb, param2=p2})
		end

		if not (minetest.settings:get_bool("creative_mode") or minetest.check_player_privs(placer:get_player_name(), {creative = true})) then
			itemstack:take_item()
		end
		return itemstack
	end

	local function afterdestruct(pos, oldnode)
		minetest.set_node(vector.add(pos, {x=0,y=1,z=0}), {name="air"})
	end

	local function rightclick(pos, node, player, itemstack, pointed_thing)
		local timer = minetest.get_node_timer(pos)
		minetest.set_node(pos, {name=doorc, param2=node.param2})
		minetest.set_node(vector.add(pos, {x=0,y=1,z=0}), {name=doord, param2=node.param2})

		-- Open neighbouring doors
		for i=0,3 do
			local dir = minetest.facedir_to_dir(i)
			local neighbour_pos = vector.add(pos, dir)
			local neighbour = minetest.get_node(neighbour_pos)
			if neighbour.name == "my_misc_doors:door2a" then
				minetest.set_node(neighbour_pos, {name=doorc, param2=neighbour.param2})
				minetest.set_node(vector.add(neighbour_pos, {x=0,y=1,z=0}), {name=doord, param2=neighbour.param2})
			end
		end

		timer:start(3)
	end

	local function afterplace(pos, placer, itemstack, pointed_thing)
		local node = minetest.get_node(pos)
		local timer = minetest.get_node_timer(pos)
		minetest.set_node(vector.add(pos, {x=0,y=1,z=0}), {name=doord, param2=node.param2})
		timer:start(3)
	end

	local function ontimer(pos, elapsed)
		local node = minetest.get_node(pos)
		minetest.set_node(pos, {name=doora, param2=node.param2})
		minetest.set_node(vector.add(pos, {x=0,y=1,z=0}), {name=doorb, param2=node.param2})

		-- Close neighbouring doors
		for i=0,3 do
			local dir = minetest.facedir_to_dir(i)
			local neighbour_pos = vector.add(pos, dir)
			local neighbour = minetest.get_node(neighbour_pos)
			if neighbour.name == "my_misc_doors:door2c" then
				minetest.set_node(neighbour_pos, {name=doora, param2=neighbour.param2})
				minetest.set_node(vector.add(neighbour_pos, {x=0,y=1,z=0}), {name=doorb, param2=neighbour.param2})
			end
		end
	end

	minetest.register_node(doora, {
		description = des.." Sliding Door",
		inventory_image = "myndoors_door"..num.."a_inv.png",
		wield_image = "myndoors_door"..num.."a_inv.png",
		tiles = {
			"myndoors_door"..num.."a_edge.png",
			"myndoors_door"..num.."a_edge.png",
			"myndoors_door"..num.."a_edge.png",
			"myndoors_door"..num.."a_edge.png",
			"myndoors_door"..num.."a_bottom.png",
			"myndoors_door"..num.."a_bottom.png^[transformFX"
		},
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {cracky = 3},
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.0625, 0.5, 0.5, 0.0625}
			}
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.0625, 0.5, 1.5, 0.0625}
			}
		},
		on_rotate = rotate_disallow,

		on_place = onplace,

		after_destruct = afterdestruct,

		on_rightclick = rightclick,
	})
	minetest.register_node(doorb, {
		tiles = {
			"myndoors_door"..num.."a_edge.png",
			"myndoors_door"..num.."a_edge.png",
			"myndoors_door"..num.."a_edge.png",
			"myndoors_door"..num.."a_edge.png",
			"myndoors_door"..num.."a_bottom.png^[transformFY",
			"myndoors_door"..num.."a_bottom.png^[transformFX^[transformFY"
		},
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {cracky = 1},
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.0625, 0.5, 0.5, 0.0625}
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
	minetest.register_node(doorc, {
		tiles = {
			"myndoors_door"..num.."a_edge.png",
			"myndoors_door"..num.."a_edge.png",
			"myndoors_door"..num.."a_edge.png",
			"myndoors_door"..num.."a_edge.png",
			"myndoors_door"..num.."a_bottomo.png",
			"myndoors_door"..num.."a_bottomo.png^[transformFX"
		},
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		drop = doora,
		groups = {cracky = 1},
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.0625, -0.25, 0.5, 0.0625},
			}
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.0625, -0.25, 1.5, 0.0625},
			}
		},
		after_place_node = afterplace,
		after_destruct = afterdestruct,
		on_timer = ontimer,
		on_rotate = rotate_disallow,
	})
	minetest.register_node(doord, {
		tiles = {
			"myndoors_door"..num.."a_edge.png",
			"myndoors_door"..num.."a_edge.png",
			"myndoors_door"..num.."a_edge.png",
			"myndoors_door"..num.."a_edge.png",
			"myndoors_door"..num.."a_bottomo.png^[transformFY",
			"myndoors_door"..num.."a_bottomo.png^[transformFX^[transformFY"
		},
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {cracky = 1},
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.0625, -0.25, 0.5, 0.0625},
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
		output = "my_future_doors:door"..num.."a 2",
		recipe = recipe
	})
end

for i, door in ipairs(doors) do
	add_door(unpack(door))
end
