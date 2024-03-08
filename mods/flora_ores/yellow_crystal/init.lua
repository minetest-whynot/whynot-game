--------------------------------------------------------------------------------
--
--  Minetest -- Yellow Crystals -- Adds crystal formations
--  Copyright (C) 2022  Olivier Dragon
--  Copyright (C) 2015  Maciej Kasatkin aka RealBadAngel
--
--  This program is free software: you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation, either version 3 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program.  If not, see <https://www.gnu.org/licenses/>.
--
--------------------------------------------------------------------------------

local S = minetest.get_translator(minetest.get_current_modname())

-- Compatibility with original mese_crystal
minetest.register_alias("yellow_crystals:mese_crystal_ore1", "mese_crystals:mese_crystal_ore1")
minetest.register_alias("yellow_crystals:mese_crystal_ore2", "mese_crystals:mese_crystal_ore2")
minetest.register_alias("yellow_crystals:mese_crystal_ore3", "mese_crystals:mese_crystal_ore3")
minetest.register_alias("yellow_crystals:mese_crystal_ore4", "mese_crystals:mese_crystal_ore4")
minetest.register_alias("yellow_crystals:crystaline_bell", "mese_crystals:crystaline_bell")
minetest.register_alias("yellow_crystals:mese_crystal_seed", "mese_crystals:mese_crystal_seed")

minetest.register_node("yellow_crystals:mese_crystal_ore1", {
	description = S("Mese Crystal Ore"),
	mesh = "mese_crystal_ore1.obj",
	tiles = {"crystal.png"},
	paramtype = "light",
	drawtype = "mesh",
	groups = {cracky = 1},
	drop = "default:mese_crystal 1",
	use_texture_alpha = true,
	sounds = default.node_sound_stone_defaults(),
	light_source = 7,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
})

minetest.register_node("yellow_crystals:mese_crystal_ore2", {
	description = S("Mese Crystal Ore"),
	mesh = "mese_crystal_ore2.obj",
	tiles = {"crystal.png"},
	paramtype = "light",
	drawtype = "mesh",
	groups = {cracky = 1},
	drop = "default:mese_crystal 2",
	use_texture_alpha = true,
	sounds = default.node_sound_stone_defaults(),
	light_source = 8,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
})

minetest.register_node("yellow_crystals:mese_crystal_ore3", {
	description = S("Mese Crystal Ore"),
	mesh = "mese_crystal_ore3.obj",
	tiles = {"crystal.png"},
	paramtype = "light",
	drawtype = "mesh",
	groups = {cracky = 1},
	drop = "default:mese_crystal 3",
	use_texture_alpha = true,
	sounds = default.node_sound_stone_defaults(),
	light_source = 9,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
})

minetest.register_node("yellow_crystals:mese_crystal_ore4", {
	description = S("Mese Crystal Ore"),
	mesh = "mese_crystal_ore4.obj",
	tiles = {"crystal.png"},
	paramtype = "light",
	drawtype = "mesh",
	groups = {cracky = 1},
	drop = "default:mese_crystal 4",
	use_texture_alpha = true,
	sounds = default.node_sound_stone_defaults(),
	light_source = 10,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
})

minetest.register_tool("yellow_crystals:crystaline_bell", {
	description = S("Crystaline Bell"),
	inventory_image = "crystalline_bell.png",
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
		local pos = pointed_thing.under
		local node = minetest.get_node(pos)
		local growth_stage = 0
		if node.name == "yellow_crystals:mese_crystal_ore4" then
			growth_stage = 4
		elseif node.name == "yellow_crystals:mese_crystal_ore3" then
			growth_stage = 3
		elseif node.name == "yellow_crystals:mese_crystal_ore2" then
			growth_stage = 2
		elseif node.name == "yellow_crystals:mese_crystal_ore1" then
			growth_stage = 1
		end
		if growth_stage == 4 then
			node.name = "yellow_crystals:mese_crystal_ore3"
			minetest.swap_node(pos, node)
		elseif growth_stage == 3 then
			node.name = "yellow_crystals:mese_crystal_ore2"
			minetest.swap_node(pos, node)
		elseif growth_stage == 2 then
			node.name = "yellow_crystals:mese_crystal_ore1"
			minetest.swap_node(pos, node)
		end
		if growth_stage > 1 then
			itemstack:add_wear(65535 / 100)
			local player_inv = user:get_inventory()
			local stack = ItemStack("default:mese_crystal")
			if player_inv:room_for_item("main", stack) then
				player_inv:add_item("main", stack)
			end
			return itemstack
		end
	end,
})

minetest.register_craftitem("yellow_crystals:mese_crystal_seed", {
	description = S("Mese Crystal Seed"),
	inventory_image = "mese_crystal_seed.png",
	on_place = function(itemstack, user, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
		local pos = pointed_thing.under
		local node = minetest.get_node(pos)
		if node.name == "default:obsidian" then
			local pos1 = pointed_thing.above
			local node1 = minetest.get_node(pos1)
			if node1.name == "air" then 
				itemstack:take_item()
				node.name = "yellow_crystals:mese_crystal_ore1"
				minetest.place_node(pos1, node)
				return itemstack
			end
		end
	end,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "yellow_crystals:mese_crystal_ore1",
	wherein        = "default:stone",
	clust_scarcity = tonumber(minetest.settings:get("yellow_crystals.ore1_scarcity")) or (18 * 18 * 18),
	clust_num_ores = 1,
	clust_size     = 1,
	y_max          = tonumber(minetest.settings:get("yellow_crystals.ore1_ymax")) or -150,
	y_min          = tonumber(minetest.settings:get("yellow_crystals.ore1_ymin")) or -500,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "yellow_crystals:mese_crystal_ore2",
	wherein        = "default:stone",
	clust_scarcity = tonumber(minetest.settings:get("yellow_crystals.ore2_scarcity")) or (20 * 20 * 20),
	clust_num_ores = 1,
	clust_size     = 1,
	y_max          = tonumber(minetest.settings:get("yellow_crystals.ore2_ymax")) or -250,
	y_min          = tonumber(minetest.settings:get("yellow_crystals.ore2_ymin")) or -31000,
})
	
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "yellow_crystals:mese_crystal_ore3",
	wherein        = "default:stone",
	clust_scarcity = tonumber(minetest.settings:get("yellow_crystals.ore3_scarcity")) or (20 * 20 * 20),
	clust_num_ores = 1,
	clust_size     = 1,
	y_max          = tonumber(minetest.settings:get("yellow_crystals.ore3_ymax")) or -350,
	y_min          = tonumber(minetest.settings:get("yellow_crystals.ore3_ymin")) or -31000,
})
	
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "yellow_crystals:mese_crystal_ore4",
	wherein        = "default:stone",
	clust_scarcity = tonumber(minetest.settings:get("yellow_crystals.ore4_scarcity")) or (20 * 20 * 20),
	clust_num_ores = 1,
	clust_size     = 1,
	y_max          = tonumber(minetest.settings:get("yellow_crystals.ore4_ymax")) or -450,
	y_min          = tonumber(minetest.settings:get("yellow_crystals.ore4_ymin")) or -31000,
})

function check_lava (pos)
	local name = minetest.get_node(pos).name
	if name == "default:lava_source" or name == "default:lava_flowing" then 
		return 1
	else
		return 0
	end
end

function grow_mese_crystal_ore(pos, node)
	local pos1 = {x = pos.x, y = pos.y, z = pos.z}
	pos1.y = pos1.y - 1
	local name = minetest.get_node(pos1).name
	if name ~= "default:obsidian" then
		return
	end

	local lava_count = 0
	pos1.z = pos.z - 1
	lava_count = lava_count + check_lava(pos1)
	pos1.z = pos.z + 1
	lava_count = lava_count + check_lava(pos1)
	pos1.z = pos.z
	pos1.x = pos.x - 1
	lava_count = lava_count + check_lava(pos1)
	pos1.x = pos.x + 1
	lava_count = lava_count + check_lava(pos1)
	if lava_count < 2 then
		return
	end

	if node.name == "yellow_crystals:mese_crystal_ore3" then
		node.name = "yellow_crystals:mese_crystal_ore4"
		minetest.swap_node(pos, node)
	elseif node.name == "yellow_crystals:mese_crystal_ore2" then
		node.name = "yellow_crystals:mese_crystal_ore3"
		minetest.swap_node(pos, node)
	elseif node.name == "yellow_crystals:mese_crystal_ore1" then
		node.name = "yellow_crystals:mese_crystal_ore2"
		minetest.swap_node(pos, node)
	end

end

minetest.register_abm({
	nodenames = {"yellow_crystals:mese_crystal_ore1", "yellow_crystals:mese_crystal_ore2",
		"yellow_crystals:mese_crystal_ore3"},
	neighbors = {"default:obsidian", "default:lava_source"},
	interval = 80,
	chance = 20,
	action = function(...)
		grow_mese_crystal_ore(...)
	end
})

minetest.register_craft({
	output = "yellow_crystals:mese_crystal_seed",
	recipe = {
		{'default:mese_crystal','default:mese_crystal','default:mese_crystal'},
		{'default:mese_crystal','default:obsidian_shard','default:mese_crystal'},
		{'default:mese_crystal','default:mese_crystal','default:mese_crystal'},
	}
})

minetest.register_craft({
	output = "yellow_crystals:crystaline_bell",
	recipe = {
		{'default:diamond'},
		{'default:glass'},
		{'default:stick'},
	}
})

