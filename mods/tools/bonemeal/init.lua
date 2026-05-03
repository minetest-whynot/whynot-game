
-- MineClonia / VoxeLibre check

local mcl = core.get_modpath("mcl_core")

-- global

bonemeal = {
	item_list = {
		bucket_water = mcl and "mcl_buckets:bucket_water" or "bucket:bucket_water",
		bucket_empty = mcl and "mcl_buckets:bucker_empty" or "bucket:bucket_empty",
		dirt = mcl and "mcl_core:dirt" or "default:dirt",
		torch = mcl and "mcl_torches:torch" or "default:torch",
		coral = mcl and "mcl_ocean:dead_horn_coral_block" or "default:coral_skeleton"
	}
}

-- translation support and vars

local S = core.get_translator("bonemeal")
local a = bonemeal.item_list
local path = core.get_modpath("bonemeal")
local min, max, random = math.min, math.max, math.random

-- creative check helper

local creative_mode_cache = core.settings:get_bool("creative_mode")
function bonemeal.is_creative(name)
	return creative_mode_cache or core.check_player_privs(name, {creative = true})
end

-- API tables

local crops = {}
local saplings = {}
local deco = {}

-- particle effect

local function particle_effect(pos)

	core.add_particlespawner({
		amount = 4,
		time = 0.15,
		minpos = pos,
		maxpos = pos,
		minvel = {x = -1, y = 2, z = -1},
		maxvel = {x = 1, y = 4, z = 1},
		minacc = {x = -1, y = -1, z = -1},
		maxacc = {x = 1, y = 1, z = 1},
		minexptime = 1,
		maxexptime = 1,
		minsize = 1,
		maxsize = 3,
		texture = "bonemeal_particle.png",
		glow = 5
	})
end

-- tree type check

local function grow_tree(pos, object)

	if type(object) == "table" and object.axiom then

		core.remove_node(pos)
		core.spawn_tree(pos, object) -- grow L-system tree

	elseif type(object) == "string" and core.registered_nodes[object] then

		core.set_node(pos, {name = object}) -- place node

	elseif type(object) == "function" then

		object(pos) -- execute function
	end
end

-- sapling check

local function check_sapling(pos, sapling_node, strength, light_ok)

	-- what is sapling placed on?
	local under =  core.get_node({x = pos.x, y = pos.y - 1, z = pos.z}).name

	-- check list for sapling and function
	for n = 1, #saplings do

		if saplings[n][1] == sapling_node then

			local grow_on = saplings[n][3] or ""
			local can_grow = false

			if grow_on == under then
				can_grow = true
			else
				local group = grow_on:match("^group:(.+)") -- strip group:

				-- backwards compatibility check
				if not group and (grow_on == "soil" or grow_on == "sand") then
					group = grow_on
				end

				if group and core.get_item_group(under, group) > 0 then
					can_grow = true
				end
			end

			-- check if we can grow sapling at current light level
			if can_grow and (light_ok or saplings[n][4]) then

				particle_effect(pos)

				if math.random(5 - strength) == 1 then
					grow_tree(pos, saplings[n][2])
				end

				return true
			end
		end
	end
end

-- crops check

local function check_crops(pos, nodename, strength, light_ok)

	-- grow registered crops
	for n = 1, #crops do

		-- check if crop can grow in current light level
		-- [1] = crop, [2] = stages, [3] = seed, [4] = can grow in dark
		if (light_ok or crops[n][4])
		and (nodename == crops[n][3] or nodename:find(crops[n][1])) then

			-- get stage and set next to place
			local stage = tonumber(nodename:match("_(%d+)$")) or 0
			local new_stage = min(stage + strength, crops[n][2])
			local next_nodename = crops[n][1] .. new_stage

			if next_nodename == nodename then return end

			local node_def = core.registered_nodes[next_nodename]

			if not node_def then return end

			core.set_node(pos,
					{name = next_nodename, param2 = node_def.place_param2 or 0})

			particle_effect(pos)

			core.get_node_timer(pos):start(10)

			return true
		end
	end
end

-- check soil for specific decoration placement

local function check_soil(pos, nodename, strength)

	-- set radius according to strength
	local side = strength - 1
	local tall = max(strength - 2, 0)

	-- get area of land with free space above
	local dirt = core.find_nodes_in_area_under_air(
		{x = pos.x - side, y = pos.y - tall, z = pos.z - side},
		{x = pos.x + side, y = pos.y + tall, z = pos.z + side}, {nodename})

	if #dirt == 0 then return end

	local grass, decor = {}, {}

	-- choose grass and decoration to use on dirt patch
	for n = 1, #deco do

		-- do we have a grass match?
		if nodename == deco[n][1] then

			grass = deco[n][2] or {}
			decor = deco[n][3] or {} ; break
		end
	end

	if #grass == 0 and #decor == 0 then return end

	-- loop through found dirt and place plants
	for i = 1, #dirt do

		local p = dirt[i] ; p.y = p.y + 1
		local nod

		if #decor > 0 and random(5) == 5 then
			nod = decor[random(#decor)]
		elseif #grass > 0 then
			nod = grass[random(#grass)]
		end

		if nod and nod ~= "" then

			local def = core.registered_nodes[nod]
			local p2 = (def and def.place_param2) or 0

			core.set_node(p, {name = nod, param2 = p2})

			particle_effect(p)
		end
	end
end

-- helper function

local function use_checks(user, pointed_thing)

	if pointed_thing.type ~= "node" then return end

	-- get position and node info
	local pos = pointed_thing.under
	local node = core.get_node(pos)
	local def = core.registered_items[node.name]
	local dirt = def and def.groups

	if not dirt then return end

	-- if we're using on ground, move position up
	if dirt.soil or dirt.sand or dirt.can_bonemeal then
		pos = pointed_thing.above
	end

	-- check if protected
	if core.is_protected(pos, user:get_player_name()) then return end

	return node
end

--= Global functions

-- add to sapling list
-- {sapling node, schematic or function name, "soil"|"sand"|specific_node|"group:"}
--e.g. {"default:sapling", default.grow_new_apple_tree, "soil"}

function bonemeal:add_sapling(list)

	for n = 1, #list do
		saplings[#saplings + 1] = list[n]
	end
end

-- add to crop list to force grow
-- {crop name start_, growth steps, seed node (if required)}
-- e.g. {"farming:wheat_", 8, "farming:seed_wheat"}

function bonemeal:add_crop(list)

	for n = 1, #list do
		crops[#crops + 1] = list[n]
	end
end

-- helpers

local function check_for(look_inside, look_for)

	for _,item in pairs(look_inside) do

		if item == look_for then
--print("-- found dupe item", look_for)
			return true
		end
	end
end

local function add_new(add_to, items)

	for _,item in pairs(items) do

		if item ~= "" and not check_for(add_to, item) then
--print("-- added", item)
			add_to[#add_to + 1] = item
		end
	end
end

-- add grass and flower/plant decoration for specific dirt types
--  {dirt_node, {grass_nodes}, {flower_nodes}
-- e.g. {"default:dirt_with_dry_grass", dry_grass, flowers}
-- if an entry already exists for a given dirt type, it will add new entries and all empty
-- entries, allowing to both add decorations and decrease their frequency.

function bonemeal:add_deco(list)

	for i = 1, #list do

		local found

		for j = 1, #deco do -- go through existing

			if list[i][1] == deco[j][1] then
--print("-- found dupe grass", list[i][1])
				add_new(deco[j][2], list[i][2]) -- grass
				add_new(deco[j][3], list[i][3]) -- flowers

				found = true ; break
			end
		end

		if not found then
			deco[#deco + 1] = list[i]
		end
	end
end

-- definitively set a decration scheme
-- this function will either add a new entry as is, or replace the existing one

function bonemeal:set_deco(list)

	for l = 1, #list do

		for n = 1, #deco do

			-- replace existing entry
			if list[l][1] == deco[n][1] then

				deco[n][2] = list[l][2]
				deco[n][3] = list[l][3]

				list[l] = false

				break
			end
		end

		if list[l] then
			deco[#deco + 1] = list[l]
		end
	end
end

-- global on_use function for bonemeal

function bonemeal:on_use(pos, strength, node)

	-- get node pointed at
	local node = node or core.get_node(pos)

	-- return if nothing there
	if node.name == "ignore" then return end

	-- make sure strength is between 1 and 4
	strength = strength or 1
	strength = max(strength, 1)
	strength = min(strength, 4)

	-- papyrus and cactus
	if node.name == "default:papyrus" then

		default.grow_papyrus(pos, node)

		particle_effect(pos) ; return true

	elseif node.name == "default:cactus" then

		default.grow_cactus(pos, node)

		particle_effect(pos) ; return true

	elseif node.name == "default:dry_dirt" and strength == 1 then

		core.set_node(pos, {name = "default:dry_dirt_with_dry_grass"})

		particle_effect(pos) ; return true
	end

	-- grow grass and flowers
	if core.get_item_group(node.name, "soil") > 0
	or core.get_item_group(node.name, "sand") > 0
	or core.get_item_group(node.name, "can_bonemeal") > 0 then

		check_soil(pos, node.name, strength)

		return true
	end

	-- light check depending on strength (strength of 4 = no light needed)
	local light_ok = true

	if (core.get_node_light(pos) or 0) < (12 - (strength * 3)) then
		light_ok = nil
	end

	-- check for sapling growth
	if check_sapling(pos, node.name, strength, light_ok) then
		return true
	end

	-- check for crop growth
	if check_crops(pos, node.name, strength, light_ok) then
		return true
	end
end

--= Items

-- Helper

local function on_use(itemstack, user, pointed_thing, strength)

	local node = use_checks(user, pointed_thing) -- do checks and return pos and node

	if node then

		local used = bonemeal:on_use(pointed_thing.under, strength, node)

		if used and not bonemeal.is_creative(user:get_player_name()) then
			itemstack:take_item()
		end
	end

	return itemstack
end

-- mulch (strength 1)

core.register_craftitem("bonemeal:mulch", {
	description = S("Mulch"),
	inventory_image = "bonemeal_mulch.png",

	on_use = function(itemstack, user, pointed_thing)
		return on_use(itemstack, user, pointed_thing, 1)
	end
})

-- bonemeal (strength 2)

core.register_craftitem("bonemeal:bonemeal", {
	description = S("Bone Meal"),
	inventory_image = "bonemeal_item.png",

	on_use = function(itemstack, user, pointed_thing)
		return on_use(itemstack, user, pointed_thing, 2)
	end
})

-- fertiliser (strength 3)

core.register_craftitem("bonemeal:fertiliser", {
	description = S("Fertiliser"),
	inventory_image = "bonemeal_fertiliser.png",

	on_use = function(itemstack, user, pointed_thing)
		return on_use(itemstack, user, pointed_thing, 3)
	end
})

-- bone

core.register_craftitem("bonemeal:bone", {
	description = S("Bone"),
	inventory_image = "bonemeal_bone.png",
	groups = {bone = 1}
})

-- gelatin powder

core.register_craftitem("bonemeal:gelatin_powder", {
	description = S("Gelatin Powder"),
	inventory_image = "bonemeal_gelatin_powder.png",
	groups = {food_gelatin = 1, flammable = 2}
})

--= Recipes

-- gelatin powder

core.register_craft({
	output = "bonemeal:gelatin_powder 4",
	recipe = {
		{"group:bone", "group:bone", "group:bone"},
		{a.bucket_water, a.bucket_water, a.bucket_water},
		{a.bucket_water, a.torch, a.bucket_water}
	},
	replacements = {
		{a.bucket_water, a.bucket_empty .. " 5"}
	}
})

-- bonemeal (from bone)

core.register_craft({
	type = "cooking",
	output = "bonemeal:bonemeal 2",
	recipe = "group:bone",
	cooktime = 4
})

-- bonemeal (from player bones)

if core.settings:get_bool("bonemeal.disable_deathbones_recipe") ~= true then

	core.register_craft({
		output = "bonemeal:bone 2",
		recipe = {{"bones:bones"}}
	})
end

-- bonemeal (from coral skeleton)

core.register_craft({
	output = "bonemeal:bonemeal 2",
	recipe = {{a.coral}}
})

-- mulch

core.register_craft({
	output = "bonemeal:mulch 4",
	recipe = {
		{"group:tree", "group:leaves", "group:leaves"},
		{"group:leaves", "group:leaves", "group:leaves"},
		{"group:leaves", "group:leaves", "group:leaves"}
	}
})

core.register_craft({
	output = "bonemeal:mulch",
	recipe = {
		{"group:seed", "group:seed", "group:seed"},
		{"group:seed", "group:seed", "group:seed"},
		{"group:seed", "group:seed", "group:seed"}
	}
})

-- fertiliser

core.register_craft({
	output = "bonemeal:fertiliser 2",
	recipe = {{"bonemeal:bonemeal", "bonemeal:mulch"}}
})

-- add bones to dirt

if core.registered_items[a.dirt] then

	core.override_item(a.dirt, {
		drop = {
			max_items = 1,
			items = {
				{items = {"bonemeal:bone"}, rarity = 40},
				{items = {a.dirt}}
			}
		}
	})
end

-- add support for mods

dofile(path .. "/mods.lua")

-- lucky block support

if core.get_modpath("lucky_block") then
	dofile(path .. "/lucky_block.lua")
end


print ("[MOD] Bonemeal loaded")
