--File name: init.lua
--Project name: Biofuel, a Mod for Minetest
--License: General Public License, version 3 or later
--Original Work Copyright (C) 2016 cd2 (cdqwertz) <cdqwertz@gmail.com>
--Modified Work Copyright (C) 2017 Vitalie Ciubotaru <vitalie at ciubotaru dot tk>
--Modified Work Copyright (C) 2018 - 2021 Lokrates
--Modified Work Copyright (C) 2018 naturefreshmilk
--Modified Work Copyright (C) 2019 OgelGames
--Modified Work Copyright (C) 2020 6r1d
--Modified Work Copyright (C) 2021 nixnoxus


-- Load support for MT game translation.
local S = minetest.get_translator("biofuel")

-- hopper compat
if minetest.get_modpath("hopper") then
	hopper:add_container({
		{"top", "biofuel:refinery", "dst"},
		{"bottom", "biofuel:refinery", "src"},
		{"side", "biofuel:refinery", "src"},
		{"top", "biofuel:refinery_active", "dst"},
		{"bottom", "biofuel:refinery_active", "src"},
		{"side", "biofuel:refinery_active", "src"},
	})
end


-- pipeworks compat
local has_pipeworks = minetest.get_modpath("pipeworks")
local tube_entry = ""

if has_pipeworks then
	tube_entry = "^pipeworks_tube_connection_metallic.png"
end


minetest.log('action', 'MOD: Biofuel ' .. "loading...")
biofuel_version = '0.7'

food_fuel = minetest.settings:get_bool("food_fuel")				-- Enables the conversion of food into fuel (settingtypes.txt)
if food_fuel == nil then food_fuel = false end 					-- default false


biomass = {}
biomass.convertible_groups = {
								'flora', 'leaves', 'flower', 'sapling', 'tree', 'wood', 'stick', 'plant', 'seed',
								'leafdecay', 'leafdecay_drop', 'mushroom', 'vines'
							  }
biomass.convertible_nodes = {
							'default:cactus', 'default:large_cactus_seedling',												-- default cactus
							'default:bush_stem', 'default:pine_bush_stem', 'default:acacia_bush_stem',						-- default bush stem
							'farming:cotton', 'farming:string', 'farming:wheat', 'farming:straw',							-- farming
							'farming:hemp_leaf', 'farming:hemp_block', 'farming:hemp_fibre', 'farming:hemp_rope', 			-- farming_redo hemp
							'farming:barley', 'farming:jackolantern',
							'default:papyrus', 'default:dry_shrub', 'default:marram_grass_1', 'default:sand_with_kelp',		-- default
							'pooper:poop_turd', 'pooper:poop_pile',															-- pooper
							'cucina_vegana:flax', 'cucina_vegana:flax_roasted', 'cucina_vegana:sunflower',					-- cucina_vegana
							'cucina_vegana:soy', 'cucina_vegana:chives', 
							'vines:vines', 'vines:rope', 'vines:rope_block',												-- Vines
							'trunks:moss_plain_0', 'trunks:moss_with_fungus_0', 'trunks:twig_1', 
							'bushes:BushLeaves1', 'bushes:BushLeaves2', 
							'dryplants:grass', 'dryplants:hay', 'dryplants:reed', 'dryplants:reedmace_sapling', 'dryplants:wetreed',
							'poisonivy:climbing', 'poisonivy:seedling', 'poisonivy:sproutling',
							}

biomass.convertible_food = {
							'farming:bread', 'farming:flour',																-- default food
							'farming:mint_leaf','farming:garlic', 'farming:peas',											-- farming_redo crops
							'farming:pepper', 'farming:pineapple', 'farming:pineapple_ring', 'farming:potato',
							'farming:rye', 'farming:oat', 'farming:rice', 'farming:rice_flour', 'farming:blueberry_pie',
							'farming:bread_multigrain', 'farming:flour_multigrain', 'farming:baked_potato',					-- farming_redo
							'farming:beetroot_soup', 'farming:bread_slice', 'farming:chili_bowl', 'farming:chocolate_block',
							'farming:chocolate_dark', 'farming:cookie', 'farming:corn_cob', 'farming:cornstarch',
							'farming:muffin_blueberry', 'farming:pea_soup', 'farming:potato_salad', 'farming:pumpkin_bread',
							'farming:pumpkin_dough', 'farming:rhubarb_pie', 'farming:rice_bread', 'farming:toast',
							'farming:toast_sandwich', 'farming:garlic_braid', 'farming:onion_soup', 
							'farming:sugar', 'farming:turkish_delight', 'farming:garlic_bread', 'farming:donut',			-- farming_redo food
							'farming:donut_chocolate', 'farming:donut_apple', 'farming:porridge', 'farming:jaffa_cake',
							'farming:apple_pie', 'farming:pasta', 'farming:spaghetti', 'farming:bibimbap',
							'wine:agave_syrup', 																			-- Wine
							'cucina_vegana:asparagus', 'cucina_vegana:asparagus_hollandaise', 								-- cucina_vegana
							'cucina_vegana:asparagus_hollandaise_cooked', 'cucina_vegana:asparagus_rice', 'cucina_vegana:asparagus_rice_cooked',
							'cucina_vegana:asparagus_soup_cooked', 'cucina_vegana:asparagus_soup', 'cucina_vegana:blueberry_jam',
							'cucina_vegana:blueberry_pot', 'cucina_vegana:blueberry_pot_cooked', 'cucina_vegana:blueberry_puree',
							'cucina_vegana:bowl_rice', 'cucina_vegana:bowl_rice_cooked', 'cucina_vegana:ciabatta_bread', 
							'cucina_vegana:ciabatta_dough', 'cucina_vegana:dandelion_honey', 'cucina_vegana:dandelion_suds',
							'cucina_vegana:dandelion_suds_cooking', 'cucina_vegana:edamame', 'cucina_vegana:edamame_cooked',
							'cucina_vegana:fish_parsley_rosemary', 'cucina_vegana:fish_parsley_rosemary_cooked', 'cucina_vegana:fryer',
							'cucina_vegana:fryer_raw', 'cucina_vegana:imitation_butter', 'cucina_vegana:imitation_cheese',
							'cucina_vegana:imitation_fish', 'cucina_vegana:imitation_meat', 'cucina_vegana:imitation_poultry',
							'cucina_vegana:kohlrabi', 'cucina_vegana:kohlrabi_roasted', 'cucina_vegana:kohlrabi_soup',
							'cucina_vegana:kohlrabi_soup_cooked', 'cucina_vegana:lettuce', 'cucina_vegana:molasses', 'cucina_vegana:parsley',
							'cucina_vegana:peanut', 'cucina_vegana:peanut_butter', 'cucina_vegana:pizza_dough', 'cucina_vegana:pizza_funghi',
							'cucina_vegana:pizza_funghi_raw', 'cucina_vegana:pizza_vegana', 'cucina_vegana:pizza_vegana_raw',
							'cucina_vegana:rice', 'cucina_vegana:rice_flour', 'cucina_vegana:rosemary', 'cucina_vegana:salad_bowl', 
							'cucina_vegana:salad_hollandaise', 'cucina_vegana:sauce_hollandaise', 'cucina_vegana:soy_milk',
							'cucina_vegana:soy_soup', 'cucina_vegana:soy_soup_cooked', 'cucina_vegana:sunflower_seeds_bread',
							'cucina_vegana:sunflower_seeds_dough', 'cucina_vegana:sunflower_seeds_flour', 'cucina_vegana:sunflower_seeds_roasted',
							'cucina_vegana:tofu', 'cucina_vegana:tofu_cooked', 'cucina_vegana:tofu_chives_rosemary',
							'cucina_vegana:tofu_chives_rosemary_cooked', 'cucina_vegana:vegan_sushi'
}





biomass.convertible_items = {}
for _, v in pairs(biomass.convertible_nodes) do
	biomass.convertible_items[v] = true
end


biomass.food_waste = {}
for _, v in pairs(biomass.convertible_food) do
	biomass.food_waste[v] = true
end


local function is_convertible(input)
		if biomass.convertible_items[input] then
			return true
		end
	if food_fuel then
		if biomass.food_waste[input] then
			return true
		end
	else end
	for _, v in pairs(biomass.convertible_groups) do
		if minetest.get_item_group(input, v) > 0 then
			return true
		end
	end
	return false
end

plants_input = tonumber(minetest.settings:get("biomass_input")) or 4		-- The number of biomass required for fuel production (settingtypes.txt)

bottle_output = minetest.settings:get_bool("refinery_output")				-- Change of refinery output between vial or bottle (settingtypes.txt)
if bottle_output == nil then bottle_output = false end 					-- default false


local function formspec(pos)
	local spos = pos.x..','..pos.y..','..pos.z
	local formspec =
		'size[8,8.5]'..
		default.gui_bg..
		default.gui_bg_img..
		default.gui_slots..
		'list[nodemeta:'..spos..';src;0.5,0.5;3,3;]'..
		'list[nodemeta:'..spos..';dst;5,1;2,2;]'..
		'list[current_player;main;0,4.25;8,1;]'..
		'list[current_player;main;0,5.5;8,3;8]'..
		'listring[nodemeta:'..spos ..';dst]'..
		'listring[current_player;main]'..
		'listring[nodemeta:'..spos ..';src]'..
		'listring[current_player;main]'..
		default.get_hotbar_bg(0, 4.25)
	return formspec
end


local function swap_node(pos, name)
	local node = minetest.get_node(pos)
	if node.name == name then
		return
	end
	node.name = name
	minetest.swap_node(pos, node)
end

local function count_input(pos)
	local q = 0
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local stacks = inv:get_list('src')
	for k in pairs(stacks) do
		q = q + inv:get_stack('src', k):get_count()
	end
	return q
end

local function count_output(pos)
	local q = 0
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local stacks = inv:get_list('dst')
	for k in pairs(stacks) do
		q = q + inv:get_stack('dst', k):get_count()
	end
	return q
end

local function is_empty(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local stacks = inv:get_list('src')
	for k in pairs(stacks) do
		if not inv:get_stack('src', k):is_empty() then
			return false
		end
	end
	stacks = inv:get_list('dst')
	for k in pairs(stacks) do
		if not inv:get_stack('dst', k):is_empty() then
			return false
		end
	end
	return true
end

local function update_nodebox(pos)
	if is_empty(pos) then
		swap_node(pos, "biofuel:refinery")
	else
		swap_node(pos, "biofuel:refinery_active")
	end
end


local function update_timer(pos)
	local timer = minetest.get_node_timer(pos)
	local meta = minetest.get_meta(pos)
	local has_output_space = (4 * 99) > count_output(pos)
	if not has_output_space then
		if timer:is_started() then
			timer:stop()
			meta:set_string('infotext', S("Output is full "))
			meta:set_int('progress', 0)
		end
		return
	end
	local count = count_input(pos)
	local refinery_time = minetest.settings:get("fuel_production_time") or 10 		-- Timebase (settingtypes.txt)
	if not timer:is_started() and count >= plants_input then        	  			-- Input
		timer:start((refinery_time)/5)   											-- Timebase
		meta:set_int('progress', 0)
		meta:set_string('infotext', S("progress: @1%", "0"))
		return
	end
	if timer:is_started() and count < plants_input then     		        		-- Input
		timer:stop()
		meta:set_string('infotext', S("To start fuel production add biomass "))
		meta:set_int('progress', 0)
	end
end

local function create_biofuel(pos)
	local dirt_count = count_output(pos)
	local q = plants_input															-- Input
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local stacks = inv:get_list('src')
	for k in pairs(stacks) do
		local stack = inv:get_stack('src', k)
		if not stack:is_empty() then
			local count = stack:get_count()
			if count <= q then
				inv:set_stack('src', k, '')
				q = q - count
			else
				inv:set_stack('src', k, stack:get_name() .. ' ' .. (count - q))
				q = 0
				break
			end
		end
	end
	stacks = inv:get_list('dst')
	for k in pairs(stacks) do
		local stack = inv:get_stack('dst', k)
		local count = stack:get_count()
		if 99 > count then
			if bottle_output then
				inv:set_stack('dst', k, 'biofuel:bottle_fuel ' .. (count + 1))
			else
				inv:set_stack('dst', k, 'biofuel:phial_fuel ' .. (count + 1))
			end
			break
		end
	end
end

local function on_timer(pos)
	local timer = minetest.get_node_timer(pos)
	local meta = minetest.get_meta(pos)
	local progress = meta:get_int('progress') + 20  							--Progresss in %
	if progress >= 100 then
		create_biofuel(pos)
		meta:set_int('progress', 0)
	else
		meta:set_int('progress', progress)
	end
	if (4 * 99) <= count_output(pos) then
		timer:stop()
		meta:set_string('infotext', S("Output is full "))
		meta:set_int('progress', 0)
		return false
	end
	if count_input(pos) >= plants_input then									--Input
		meta:set_string('infotext', S("progress: @1%", progress))
		return true
	else
		timer:stop()
		meta:set_string('infotext', S("To start fuel production add biomass "))
		meta:set_int('progress', 0)
		return false
	end
end

local function on_construct(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	inv:set_size('src', 9)                                     					-- Input Fields
	inv:set_size('dst', 4)                                     					-- Output Fields
	meta:set_string('infotext', S("To start fuel production add biomass "))
	meta:set_int('progress', 0)
end

local function on_rightclick(pos, node, clicker, itemstack)
	minetest.show_formspec(
		clicker:get_player_name(),
		'biofuel:refinery',
		formspec(pos)
	)
end

local function can_dig(pos,player)

	if player and player:is_player() and minetest.is_protected(pos, player:get_player_name()) then
		-- protected
		return false
	end

	local meta = minetest.get_meta(pos)
	local inv  = meta:get_inventory()
	if inv:is_empty('src') and inv:is_empty('dst') then
		return true
	else
		return false
	end
end

local tube = {
	insert_object = function(pos, node, stack, direction)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local convertible = is_convertible(stack:get_name())
		if not convertible then
			return stack
		end

		local result = inv:add_item("src", stack)
		update_timer(pos)
		update_nodebox(pos)
		return result
	end,
	can_insert = function(pos, node, stack, direction)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		stack = stack:peek_item(1)

		return is_convertible(stack:get_name()) and inv:room_for_item("src", stack)
	end,
	input_inventory = "dst",
	connect_sides = {left = 1, right = 1, back = 1, front = 1, bottom = 1, top = 1}
}


local function allow_metadata_inventory_take(pos, listname, index, stack, player)
	if player and player:is_player() and minetest.is_protected(pos, player:get_player_name()) then
		-- protected
		return 0
	end

	return stack:get_count()
end

local function allow_metadata_inventory_put(pos, listname, index, stack, player)

	if player and player:is_player() and minetest.is_protected(pos, player:get_player_name()) then
		-- protected
		return 0
	end

	if listname == 'src' and is_convertible(stack:get_name()) then
		return stack:get_count()
	else
		return 0
	end
end

local function on_metadata_inventory_put(pos, listname, index, stack, player)
	update_timer(pos)
	update_nodebox(pos)
	minetest.log('action', player:get_player_name() .. " moves stuff to refinery at " .. minetest.pos_to_string(pos))
	return
end

local function on_metadata_inventory_take(pos, listname, index, stack, player)
	update_timer(pos)
	update_nodebox(pos)
	minetest.log('action', player:get_player_name() .. " takes stuff from refinery at " .. minetest.pos_to_string(pos))
	return
end

local function allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)

	if player and player:is_player() and minetest.is_protected(pos, player:get_player_name()) then
		-- protected
		return 0
	end

	local inv = minetest.get_meta(pos):get_inventory()
	if from_list == to_list then
		return inv:get_stack(from_list, from_index):get_count()
	else
		return 0
	end
end

minetest.register_node("biofuel:refinery", {
	description = S("Biofuel Refinery"),
	drawtype = "nodebox",
		tiles = {
			"biofuel_tb.png" .. tube_entry, -- top
			"biofuel_tb.png" .. tube_entry, -- bottom
			"biofuel_fr.png",       	 	-- right
			"biofuel_bl.png",       	 	-- left
			"biofuel_bl.png",       		-- back
			"biofuel_fr.png"        	 	-- front
		},
	use_texture_alpha = "clip",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, 0.4375, 0.4375, 0.4375, 0.5, 0.5}, -- NodeBox1
			{0.4375, 0.4375, -0.4375, 0.5, 0.5, 0.4375}, -- NodeBox2
			{-0.4375, 0.4375, -0.5, 0.4375, 0.5, -0.4375}, -- NodeBox3
			{-0.5, 0.4375, -0.4375, -0.4375, 0.5, 0.4375}, -- NodeBox4
			{0.4375, -0.375, 0.4375, 0.5, 0.5, 0.5}, -- NodeBox5
			{0.4375, -0.375, -0.5, 0.5, 0.5, -0.4375}, -- NodeBox6
			{-0.5, -0.375, -0.5, -0.4375, 0.5, -0.4375}, -- NodeBox7
			{-0.5, -0.375, 0.4375, -0.4375, 0.5, 0.5}, -- NodeBox8
			{-0.5, -0.5, -0.5, 0.5, -0.375, 0.5}, -- NodeBox9
			{-0.4375, -0.375, -0.4375, 0, 0.3125, 0}, -- NodeBox10
			{0, -0.375, 0.1875, 0.375, 0.3125, 0.1875}, -- NodeBox11
			{0.1875, -0.375, 0, 0.1875, 0.3125, 0.375}, -- NodeBox12
			{-0.25, 0.3125, -0.25, 0.25, 0.4375, 0.25}, -- NodeBox13
		}
	},
	selection_box = {
	    type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
	collision_box = {
	    type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {cracky = 3, oddly_breakable_by_hand=1, tubedevice=1, tubedevice_receiver=1},
	sounds = default.node_sound_metal_defaults(),
	on_timer = on_timer,
	on_construct = on_construct,
	on_rightclick = on_rightclick,
	can_dig = can_dig,
	tube = tube,
	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	allow_metadata_inventory_take = allow_metadata_inventory_take,
	on_metadata_inventory_put = on_metadata_inventory_put,
	on_metadata_inventory_take = on_metadata_inventory_take,
})

minetest.register_node("biofuel:refinery_active", {
	description = S("Biofuel Refinery Active"),
	drawtype = "nodebox",
		tiles = {
			"biofuel_tb.png" .. tube_entry,         -- top
			"biofuel_tb.png" .. tube_entry,         -- bottom
			"biofuel_fr_active.png",       			-- right
			"biofuel_bl_active.png",      			-- left
			"biofuel_bl_active.png",       			-- back
			"biofuel_fr_active.png"        			-- front
		},
	use_texture_alpha = "clip",
	node_box = {
		type = "fixed",
		fixed = {
		{-0.4375, 0.4375, 0.4375, 0.4375, 0.5, 0.5}, -- NodeBox1
			{0.4375, 0.4375, -0.4375, 0.5, 0.5, 0.4375}, -- NodeBox2
			{-0.4375, 0.4375, -0.5, 0.4375, 0.5, -0.4375}, -- NodeBox3
			{-0.5, 0.4375, -0.4375, -0.4375, 0.5, 0.4375}, -- NodeBox4
			{0.4375, -0.375, 0.4375, 0.5, 0.5, 0.5}, -- NodeBox5
			{0.4375, -0.375, -0.5, 0.5, 0.5, -0.4375}, -- NodeBox6
			{-0.5, -0.375, -0.5, -0.4375, 0.5, -0.4375}, -- NodeBox7
			{-0.5, -0.375, 0.4375, -0.4375, 0.5, 0.5}, -- NodeBox8
			{-0.5, -0.5, -0.5, 0.5, -0.375, 0.5}, -- NodeBox9
			{-0.4375, -0.375, -0.4375, 0, 0.3125, 0}, -- NodeBox10
			{0, -0.375, 0.1875, 0.375, 0.3125, 0.1875}, -- NodeBox11
			{0.1875, -0.375, 0, 0.1875, 0.3125, 0.375}, -- NodeBox12
			{-0.25, 0.3125, -0.25, 0.25, 0.4375, 0.25}, -- NodeBox13
		}
	},
	selection_box = {
	    type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
	collision_box = {
	    type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {cracky = 3, oddly_breakable_by_hand=1, not_in_creative_inventory = 1, tubedevice=1, tubedevice_receiver=1},
	sounds = default.node_sound_metal_defaults(),
	on_timer = on_timer,
	on_construct = on_construct,
	on_rightclick = on_rightclick,
	can_dig = can_dig,
	tube = tube,
	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	allow_metadata_inventory_take = allow_metadata_inventory_take,
	on_metadata_inventory_put = on_metadata_inventory_put,
	on_metadata_inventory_take = on_metadata_inventory_take,
})

minetest.register_craft({
	output = "biofuel:refinery",
	recipe = {
		{"default:tin_ingot", "default:tin_ingot", "default:tin_ingot"},
		{"default:glass", "default:glass", "default:glass"},
		{"default:tin_ingot", "default:tin_ingot", "default:tin_ingot"}
	}
})


minetest.log('action', "MOD: Biofuel version " .. biofuel_version .. " loaded.")
