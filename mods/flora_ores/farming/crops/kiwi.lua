
local S = core.get_translator("farming")
local mod_def = core.get_modpath("default")
local mod_mcl = core.get_modpath("mcl_core")
local mod_xfr = core.get_modpath("x_farming")

-- nodes

core.register_node("farming:kiwi_vine", {
	drawtype = "nodebox",
	description = S("Kiwi Vine"),
	tiles = {"x_farming_kiwi_wood.png"},
	sunlight_propagates = true,
	groups = {flammable = 3, choppy = 2, oddly_breakable_by_hand = 1},
	sounds = farming.node_sound_wood_defaults(),
	paramtype = "light",
	paramtype2 = "facedir",
	on_place = core.rotate_node,
	node_box = {type = "fixed", fixed = {-0.5, -0.5, 0.3, 0.5,-0.3, 0.5}}
})

core.register_node("farming:kiwi_wood", {
	description = S("Kiwi Wood"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"x_farming_kiwi_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = farming.node_sound_wood_defaults(),
})

core.register_node("farming:kiwi_leaves", {
	description = S("Kiwi Leaves"),
	drawtype = "plantlike",
	visual_scale = 1.2,
	tiles = {"x_farming_kiwi_leaves.png"},
	inventory_image = "x_farming_kiwi_leaves.png",
	wield_image = "x_farming_kiwi_leaves.png",
	paramtype = "light",
	walkable = false,
	waving = 1,
	groups = {snappy = 3, leafdecay = 3, leaves = 1, flammable = 2},
	drop = {
		max_items = 1,
		items = {
			{items = {"farming:kiwi_sapling"}, rarity = 20},
			{items = {"farming:kiwi_leaves"}}
		}
	},
	sounds = farming.node_sound_leaves_defaults(),
	after_place_node = mod_def and default.after_place_leaves
})

minetest.register_node("farming:kiwi", {
	description = S("Kiwi Fruit"),
	drawtype = "plantlike",
	tiles = {"x_farming_kiwi.png"},
	visual_scale = 0.6,
	inventory_image = "x_farming_kiwi_fruit.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	selection_box = {type = "fixed", fixed = {-3/16, -8/16, -3/16, 3/16, 0, 3/16}},
	groups = {fleshy = 3, dig_immediate = 3, flammable = 2,
		leafdecay = 3, leafdecay_drop = 1, food_kiwi = 1},
	on_use = minetest.item_eat(2),
	sounds = farming.node_sound_leaves_defaults(),

	after_place_node = function(pos, placer, itemstack)
		core.set_node(pos, {name = "farming:kiwi", param2 = 1})
	end
})

-- crafting

core.register_craft({
	output = "farming:kiwi_wood",
	recipe = { {"farming:kiwi_vine"}, {"farming:kiwi_vine"}, {"farming:kiwi_vine"} }
})

-- kiwi vine schematic

local _ = {name = "air", param1 = 0}
local k = {name = "farming:kiwi", param1 = 215}
local L = {name = "farming:kiwi_leaves", param1 = 255}
local l = {name = "farming:kiwi_leaves", param1 = 127}
local t = {name = "farming:kiwi_vine", param1 = 255, param2 = 20}
local T = {name = "farming:kiwi_vine", param1 = 255, param2 = 18, force_place = true}
local h = {name = "farming:kiwi_vine", param1 = 255, param2 = 7, force_place = true}
local H = {name = "farming:kiwi_vine", param1 = 255, param2 = 3}

farming.kiwi_vine = {
	size = {x = 4, y = 4, z = 4},
	data = {
		_,_,_,_,	_,_,_,_,	k,L,L,k,	L,L,L,L,

		_,_,_,_,	_,_,_,_,	L,t,L,L,	L,L,L,L,

		_,T,_,_,	_,_,h,_,	L,T,H,L,	L,L,L,L,

		_,_,_,_,	_,_,_,_,	k,L,L,k,	L,L,L,L,
	}
}

-- grow function

local function add_tree(pos, schem, replace)

	core.remove_node(pos)
	pos.x = pos.x - 1 ; pos.z = pos.z - 2
	core.place_schematic(
			pos, schem, nil, replace, false)--, "place_center_x, place_center_z")
end

function farming.grow_kiwi_vine(pos)
	add_tree(pos, farming.kiwi_vine)
end

local function can_grow(pos)

	local light = core.get_node_light(pos) or 0
	local under = core.get_node({x = pos.x, y = pos.y - 1, z = pos.z})
	local udef = core.registered_nodes[under.name]

	if not udef or not udef.groups or not udef.groups.soil or light < 13 then return end

	return true
end

-- sapling

minetest.register_node("farming:kiwi_sapling", {
	description = S("Kiwi Sapling"),
	drawtype = "plantlike",
	tiles = {"x_farming_kiwi_sapling.png"},
	inventory_image = "x_farming_kiwi_sapling.png",
	wield_image = "x_farming_kiwi_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {type = "fixed", fixed = {-4/16, -0.5, -4/16, 4/16, 7/16, 4/16}},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2, attached_node = 1, sapling = 1},
	sounds = farming.node_sound_leaves_defaults(),

	on_timer = function(pos)
		if can_grow(pos) then
			farming.grow_kiwi_vine(pos)
		else
			core.get_node_timer(pos):start(500) -- give it another 5 mins
		end
	end,

	on_construct = function(pos)
		core.get_node_timer(pos):start(math.random(300, 1500))
	end,

	on_place = function(itemstack, placer, pointed_thing)

		if pointed_thing.type ~= "node" then return end

		if mod_def then

			itemstack = default.sapling_on_place(itemstack, placer, pointed_thing,
				"farming:kiwi_sapling", {x = -2, y = 1, z = -2}, {x = 2, y = 4, z = 2},	4)

		else -- quick placement function for all other [games]
			local pos = pointed_thing.under
			local nod = core.get_node(pos)
			local def = core.registered_nodes[nod.name]

			if not def or not def.buildable_to then
				pos = pointed_thing.above
			end

			if not core.is_protected(pos, placer:get_player_name()) then

				local item = placer:get_wielded_item()

				itemstack:take_item() ; placer:set_wielded_item(item)

				core.set_node(pos, {name = "farming:kiwi_sapling"})
			end
		end

		return itemstack
	end,
})

-- leaf decay
if mod_def then

	default.register_leafdecay({trunks = {"farming:kiwi_vine"},
			leaves = {"farming:kiwi_leaves", "farming:kiwi"}, radius = 3})
end

-- mapgen

def = {
	name = 'farming:kiwi_tree',
	deco_type = 'schematic',
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = farming.kiwi,
		spread = {x = 250, y = 250, z = 250},
		seed = 2,
		octaves = 3,
		persist = 0.66
	},
	biomes = {"savanna"},
	y_min = 1, y_max = 100, place_offset_y = 1,
	schematic = farming.kiwi_vine,
	flags = 'place_center_x, place_center_z', rotation = 'random',
	num_spawn_by = 8
}

if mod_mcl then
	def.place_on = "mcl_core:dirt_with_grass"
elseif mod_def then
	def.place_on = "default:dry_dirt_with_dry_grass"
end

def.spawn_by = def.place_on

core.register_decoration(def)

-- compatibility

if not mod_xfr then
	core.register_alias("x_farming:kiwi_tree", "farming:kiwi_vine")
	core.register_alias("x_farming:kiwi_leaves", "farming:kiwi_leaves")
	core.register_alias("x_farming:kiwi_sapling", "farming:kiwi_sapling")
	core.register_alias("x_farming:kiwi", "farming:kiwi")
	core.register_alias("x_farming:kiwi_mark", "farming:kiwi")
	core.register_alias("x_farming:kiwi_fruit", "farming:kiwi")
	core.register_alias("x_farming:kiwi_wood", "farming:kiwi_wood")
end
