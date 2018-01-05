
-- function to safely remove climbable air
local function remove_air(pos, oldnode)
	local dir = minetest.facedir_to_dir(oldnode.param2)
	local airpos = vector.subtract(pos, dir)

	local north_node = minetest.get_node({x = airpos.x, y = airpos.y, z = airpos.z+1})
	local south_node = minetest.get_node({x = airpos.x, y = airpos.y, z = airpos.z-1})
	local east_node = minetest.get_node({x = airpos.x+1, y = airpos.y, z = airpos.z})
	local west_node = minetest.get_node({x = airpos.x-1, y = airpos.y, z = airpos.z})

	local keep_air =
		(minetest.get_item_group(north_node.name, "handholds") == 1 and
		north_node.param2 == 0) or
		(minetest.get_item_group(south_node.name, "handholds") == 1 and
		south_node.param2 == 2) or
		(minetest.get_item_group(east_node.name, "handholds") == 1 and
		east_node.param2 == 1) or
		(minetest.get_item_group(west_node.name, "handholds") == 1 and
		west_node.param2 == 3)

	if not keep_air then
		minetest.set_node(airpos, {name = "air"})
	end
end


-- remove handholds from nodes buried under falling nodes
local function remove_handholds(pos)
	local north_pos = {x = pos.x, y = pos.y, z = pos.z+1}
	local south_pos = {x = pos.x, y = pos.y, z = pos.z-1}
	local east_pos = {x = pos.x+1, y = pos.y, z = pos.z}
	local west_pos = {x = pos.x-1, y = pos.y, z = pos.z}
	local north_node = minetest.get_node(north_pos)
	local south_node = minetest.get_node(south_pos)
	local east_node = minetest.get_node(east_pos)
	local west_node = minetest.get_node(west_pos)

	local node_pos

	if minetest.get_item_group(north_node.name, "handholds") == 1 and
			north_node.param2 == 0 then
		node_pos = north_pos
	elseif minetest.get_item_group(south_node.name, "handholds") == 1 and
			south_node.param2 == 2 then
		node_pos = south_pos
	elseif minetest.get_item_group(east_node.name, "handholds") == 1 and
			east_node.param2 == 1 then
		node_pos = east_pos
	elseif minetest.get_item_group(west_node.name, "handholds") == 1 and
			west_node.param2 == 3 then
		node_pos = west_pos
	end

	if node_pos then
		local handholds_node = string.split(minetest.get_node(node_pos).name, ":")
		minetest.set_node(node_pos, {name = "default:"..handholds_node[2]})
	end
end


-- climbable air!
minetest.register_node("handholds:climbable_air", {
	description = "Air!",
	drawtype = "airlike",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	pointable = false,
	diggable = false,
	climbable = true,
	drop = "",
	groups = {not_in_creative_inventory = 1},
	on_destruct = function(pos)
		remove_handholds(pos)
	end,
})


-- handholds nodes
minetest.register_node("handholds:stone", {
	description = "Stone Handholds",
	tiles = {
		"default_stone.png", "default_stone.png", 
		"default_stone.png", "default_stone.png", 
		"default_stone.png", "default_stone.png^handholds_holds.png"
	},
	paramtype2 = "facedir",
	on_rotate = function()
		return false
	end,
	groups = {cracky = 3, stone = 1, not_in_creative_inventory = 1, handholds = 1},
	drop = 'default:cobble',
	sounds = default.node_sound_stone_defaults(),
	after_destruct = function(pos, oldnode)
		remove_air(pos, oldnode)
	end,
})

minetest.register_node("handholds:desert_stone", {
	description = "Desert Stone Handholds",
	tiles = {
		"default_desert_stone.png", "default_desert_stone.png", 
		"default_desert_stone.png", "default_desert_stone.png", 
		"default_desert_stone.png", "default_desert_stone.png^handholds_holds.png"
	},
	paramtype2 = "facedir",
	on_rotate = function()
		return false
	end,
	groups = {cracky = 3, stone = 1, not_in_creative_inventory = 1, handholds = 1},
	drop = 'default:desert_cobble',
	sounds = default.node_sound_stone_defaults(),
	after_destruct = function(pos, oldnode)
		remove_air(pos, oldnode)
	end,
})

minetest.register_node("handholds:sandstone", {
	description = "Sandstone Handholds",
	tiles = {
		"default_sandstone.png", "default_sandstone.png", 
		"default_sandstone.png", "default_sandstone.png", 
		"default_sandstone.png", "default_sandstone.png^handholds_holds.png"
	},
	paramtype2 = "facedir",
	on_rotate = function()
		return false
	end,
	groups = {cracky = 3, stone = 1, not_in_creative_inventory = 1, handholds = 1},
	drop = 'default:sandstone',
	sounds = default.node_sound_stone_defaults(),
	after_destruct = function(pos, oldnode)
		remove_air(pos, oldnode)
	end,
})

minetest.register_node("handholds:ice", {
	description = "Ice Handholds",
	tiles = {
		"default_ice.png", "default_ice.png", 
		"default_ice.png", "default_ice.png", 
		"default_ice.png", "default_ice.png^handholds_holds.png"
	},
	paramtype2 = "facedir",
	on_rotate = function()
		return false
	end,
	groups = {
		cracky = 3, puts_out_fire = 1, cools_lava = 1,
		not_in_creative_inventory = 1, handholds = 1
	},
	drop = 'default:ice',
	sounds = default.node_sound_glass_defaults(),
	after_destruct = function(pos, oldnode)
		remove_air(pos, oldnode)
	end,
})


-- handholds tool
minetest.register_tool("handholds:climbing_pick", {
	description = "Climbing Pick",
	inventory_image = "handholds_tool.png",
	sound = {breaks = "default_tool_breaks"},
	on_use = function(itemstack, player, pointed_thing)
		if not pointed_thing or 
				pointed_thing.type ~= "node" or 
				minetest.is_protected(pointed_thing.under, player:get_player_name()) or
				minetest.is_protected(pointed_thing.above, player:get_player_name()) or
				pointed_thing.under.y + 1 == pointed_thing.above.y or
				pointed_thing.under.y - 1 == pointed_thing.above.y then
			return
		end

		local node_def = 
			minetest.registered_nodes[minetest.get_node(pointed_thing.above).name]
		if not node_def or not node_def.buildable_to then
			return
		end

		local node_name = minetest.get_node(pointed_thing.under).name
		local rotation = minetest.dir_to_facedir(
			vector.subtract(pointed_thing.under, pointed_thing.above))

		if node_name == "default:stone" then
			minetest.set_node(pointed_thing.under,
				{name = "handholds:stone", param2 = rotation})
		elseif node_name == "default:desert_stone" then
			minetest.set_node(pointed_thing.under,
				{name = "handholds:desert_stone", param2 = rotation})
		elseif node_name == "default:sandstone" then
			minetest.set_node(pointed_thing.under,
				{name = "handholds:sandstone", param2 = rotation})
		elseif node_name == "default:ice" then
			minetest.set_node(pointed_thing.under,
				{name = "handholds:ice", param2 = rotation})
		else
			return
		end

		minetest.set_node(pointed_thing.above, {name = "handholds:climbable_air"})
		minetest.sound_play(
			"default_dig_cracky",
			{pos = pointed_thing.above, gain = 0.5, max_hear_distance = 8}
		)

		if not minetest.setting_getbool("creative_mode") then
			local wdef = itemstack:get_definition()
			itemstack:add_wear(256)
			if itemstack:get_count() == 0 and wdef.sound and wdef.sound.breaks then
				minetest.sound_play(wdef.sound.breaks,
					{pos = pointed_thing.above, gain = 0.5})
			end
			return itemstack
		end
	end
})

minetest.register_craft({
	output = "handholds:climbing_pick",
	recipe = {
		{'default:diamond', 'default:diamond', 'default:diamond'},
		{'group:stick', '', ''},
		{'group:stick', '', ''},
	},
})
