local register_internal_material = function(subname, groups, tiles, subdesc, sounds)
	minetest.register_node("princess:"..subname, {
		description = subdesc,
		drawtype = "normal",
		tiles = tiles,
		groups = groups,
		sounds = sounds
	})
	stairs.register_stair_and_slab(subname, "princess:"..subname, table.copy(groups), tiles,
			subdesc.." Stairs", subdesc.." Slab", sounds)
	if minetest.get_modpath("mcstair") then
		mcstair.register(subname)
		minetest.register_alias("stairs:stair_"..subname.."_outer", "stairs:stair_outer_"..subname)
		minetest.register_alias("stairs:stair_"..subname.."_inner", "stairs:stair_inner_"..subname)
	end
end

minetest.register_node("princess:gold_candle", {
	description = "Gold Candle",
	drawtype = "torchlike",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	tiles = {
		{
			name = "princess_gold_candle_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.5
			}
		},
		{
			name = "princess_gold_candle_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.5
			}
		},
		{
			name = "princess_gold_candle_wall_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.5
			}
		}
	},
	wield_image = "princess_gold_candle.png",
	inventory_image = "princess_gold_candle.png",
	selection_box = {
		type = "wallmounted",
		wall_top = {-0.125, -0.5, -0.125, 0.125, 0, 0.125},
		wall_bottom = {-0.125, -0.5, -0.125, 0.125, 0, 0.125},
		wall_side = {-0.5, -0.5, -0.125, -0.1875, 0.125, 0.125}
	},
	walkable = false,
	groups = {dig_immediate = 3, attached_node = 1},
	light_source = default.LIGHT_MAX - 1
})

minetest.register_node("princess:gold_candle_unlit", {
	description = "Unlit Gold Candle",
	drawtype = "torchlike",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	tiles = {"princess_gold_candle_unlit.png", "princess_gold_candle_unlit.png", "princess_gold_candle_wall_unlit.png"},
	wield_image = "princess_gold_candle_unlit.png",
	inventory_image = "princess_gold_candle_unlit.png",
	selection_box = {
		type = "wallmounted",
		wall_top = {-0.125, -0.5, -0.125, 0.125, 0, 0.125},
		wall_bottom = {-0.125, -0.5, -0.125, 0.125, 0, 0.125},
		wall_side = {-0.5, -0.5, -0.125, -0.1875, 0.125, 0.125}
	},
	walkable = false,
	groups = {dig_immediate = 3, attached_node = 1}
})

minetest.register_node("princess:gold_chandelier", {
	description = "Gold Chandelier",
	drawtype = "plantlike",
	paramtype = "light",
	sunlight_propagates = true,
	tiles = {{
		name = "princess_gold_chandelier_animated.png",
		animation = {
			type = "vertical_frames",
			aspect_w = 16,
			aspect_h = 16,
			length = 2.5
		}
	}},
	wield_image = "princess_gold_chandelier.png",
	inventory_image = "princess_gold_chandelier.png",
	selection_box = {
		type = "fixed",
		fixed = {-0.375, -0.5, -0.375, 0.375, 0.5, 0.375}
	},
	walkable = false,
	groups = {dig_immediate = 2},
	light_source = default.LIGHT_MAX
})

minetest.register_node("princess:gold_chandelier_unlit", {
	description = "Unlit Gold Chandelier",
	drawtype = "plantlike",
	paramtype = "light",
	sunlight_propagates = true,
	tiles = {"princess_gold_chandelier_unlit.png"},
	selection_box = {
		type = "fixed",
		fixed = {-0.375, -0.5, -0.375, 0.375, 0.5, 0.375}
	},
	walkable = false,
	groups = {dig_immediate = 2}
})

minetest.register_node("princess:princess_chest", {
	description = "Princess Chest",
	drawtype = "normal",
	paramtype2 = "facedir",
	tiles = {"princess_chest_top.png", "princess_chest_top.png", "princess_chest_side.png",
			"princess_chest_side.png", "princess_chest_side.png", "princess_chest_front.png"},
	groups = {cracky = 3},
	sounds = default.node_sound_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", "size[8,9]"..default.gui_bg..default.gui_bg_img..default.gui_slots..
				"list[current_name;main;0,0.3;8,4;]list[current_player;main;0,4.85;8,1;]"..
				"list[current_player;main;0,6.08;8,3;8]listring[current_name;main]listring[current_player;main]"..
				default.get_hotbar_bg(0,4.85))
		meta:set_string("infotext", "Princess Chest")
		local inv = meta:get_inventory()
		inv:set_size("main", 32)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name().." moves stuff in princess chest at "..minetest.pos_to_string(pos))
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name().." moves "..stack:get_name().." to princess chest at "..minetest.pos_to_string(pos))
	end,
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name().." takes "..stack:get_name().." from princess chest at "..minetest.pos_to_string(pos))
	end,
	on_blast = function(pos)
		local drops = {}
		default.get_inventory_drops(pos, "main", drops)
		drops[#drops+1] = "princess:princess_chest"
		minetest.remove_node(pos)
		return drops
	end,
})

minetest.register_node("princess:throne", {
	description = "Princess Throne",
	drawtype = "nodebox",
	tiles = {"princess_throne_top.png", "princess_white_material.png", "princess_white_material.png",
			"princess_white_material.png", "princess_white_material.png", "princess_throne_front.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.5, 0.1875, -0.1875, -0.0625, 0.3125},
			{0.1875, -0.5, 0.1875, 0.3125, -0.0625, 0.3125},
			{-0.3125, -0.5, -0.3125, -0.1875, -0.0625, -0.1875},
			{0.1875, -0.5, -0.3125, 0.3125, -0.0625, -0.1875},
			{-0.3125, -0.0625, -0.3125, 0.3125, 0.0625, 0.3125},
			{-0.3125, 0.0625, 0.1875, 0.3125, 0.9375, 0.3125},
			{-0.3125, 0.9375, 0.1875, -0.1875, 1, 0.3125},
			{0.1875, 0.9375, 0.1875, 0.3125, 1, 0.3125}
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.5, -0.3125, 0.3125, 0.0625, 0.3125},
			{-0.3125, 0.0625, 0.1875, 0.3125, 1, 0.3125}
		}
	},
	groups = {cracky = 3},
	sounds = default.node_sound_defaults()
})

beds.register_bed("princess:princess_bed", {
	description = "Princess Bed",
	inventory_image = "princess_bed.png",
	wield_image = "princess_bed.png",
	tiles = {
		bottom = {"princess_bed_bottom_top.png", "princess_white_material.png", "princess_bed_bottom_side.png",
				"princess_bed_bottom_side.png^[transformFX", "princess_white_material.png"},
		top = {"princess_bed_top_top.png", "princess_white_material.png", "princess_bed_top_side.png",
				"princess_bed_top_side.png^[transformFX", "princess_white_material.png"}
	},
	nodebox = {
		bottom = {
			{-0.5, -0.375, -0.5, 0.5, 0.0625, 0.5},
			{-0.5, -0.5, 0.375, -0.3125, -0.375, 0.5},
			{0.3125, -0.5, 0.375, 0.5, -0.375, 0.5},
			{-0.5, -0.5, -0.5, -0.3125, -0.375, -0.25},
			{0.3125, -0.5, -0.5, 0.5, -0.375, -0.25},
			{-0.5, 0.0625, -0.5, -0.375, 0.3125, -0.375},
			{0.375, 0.0625, -0.5, 0.5, 0.3125, -0.375},
			{-0.375, 0.0625, -0.5, 0.375, 0.25, -0.4375}
		},
		top = {
			{-0.5, -0.375, -0.5, 0.5, 0.0625, 0.5},
			{-0.5, -0.5, 0.25, -0.3125, -0.375, 0.5},
			{0.3125, -0.5, 0.25, 0.5, -0.375, 0.5},
			{-0.5, -0.5, -0.5, -0.3125, -0.375, -0.375},
			{0.3125, -0.5, -0.5, 0.5, -0.375, -0.375},
			{-0.5, 0.0625, 0.375, -0.375, 0.4375, 0.5},
			{0.375, 0.0625, 0.375, 0.5, 0.4375, 0.5},
			{-0.375, 0.0625, 0.4375, 0.375, 0.375, 0.5},
			{-0.25, 0.375, 0.4375, 0.25, 0.5, 0.5}
		}
	},
	selectionbox = {
		{-0.5, -0.5, -0.5, 0.5, 0.0625, 1.5},
		{-0.5, 0.0625, 1.375, 0.5, 0.4375, 1.5},
		{-0.5, 0.0625, -0.5, 0.5, 0.3125, -0.375}
	},
	recipe = {
		{"wool:pink", "wool:pink", "wool:white"},
		{"princess:princess_white_material", "princess:princess_white_material", "princess:princess_white_material"}
	}
})

default.register_fence("princess:princess_pink_material_fence", {
	description = "Pink Princess Material Stuff Fence",
	texture = "princess_pink_material.png",
	material = "princess:princess_pink_material",
	groups = {cracky = 3},
	sounds = default.node_sound_defaults()
})

default.register_fence("princess:princess_white_material_fence", {
	description = "White Princess Material Stuff Fence",
	texture = "princess_white_material.png",
	material = "princess:princess_white_material",
	groups = {cracky = 3},
	sounds = default.node_sound_defaults()
})

doors.register_door("princess:princess_pink_material_door", {
	description = "Pink Princess Material Stuff Door",
	inventory_image = "princess_pink_material_door_inv.png",
	tiles = {"princess_pink_material_door.png"},
	recipe = {
		{"princess:princess_pink_material", "princess:princess_pink_material"},
		{"princess:princess_pink_material", "princess:princess_pink_material"},
		{"princess:princess_pink_material", "princess:princess_pink_material"}
	},
	groups = {cracky = 3},
	sounds = default.node_sound_defaults(),
	protected = false
})

doors.register_door("princess:princess_white_material_door", {
	description = "White Princess Material Stuff Door",
	inventory_image = "princess_white_material_door_inv.png",
	tiles = {"princess_white_material_door.png"},
	recipe = {
		{"princess:princess_white_material", "princess:princess_white_material"},
		{"princess:princess_white_material", "princess:princess_white_material"},
		{"princess:princess_white_material", "princess:princess_white_material"}
	},
	groups = {cracky = 3},
	sounds = default.node_sound_defaults(),
	protected = false
})

doors.register_fencegate("princess:princess_pink_material_fence_gate", {
	description = "Pink Princess Material Stuff Fence Gate",
	texture = "princess_pink_material.png",
	material = "princess:princess_pink_material",
	groups = {cracky = 3},
	sounds = default.node_sound_defaults()
})

doors.register_fencegate("princess:princess_white_material_fence_gate", {
	description = "White Princess Material Stuff Fence Gate",
	texture = "princess_white_material.png",
	material = "princess:princess_white_material",
	groups = {cracky = 3},
	sounds = default.node_sound_defaults()
})

walls.register("princess:princess_pink_material_wall", "Pink Princess Material Stuff Wall", "princess_pink_material.png",
		"princess:princess_pink_material", default.node_sound_defaults())
walls.register("princess:princess_rose_cobble_wall", "Rose Cobblestone Wall", "default_cobble.png^princess_rose_cobble.png",
		"princess:princess_rose_cobble", default.node_sound_stone_defaults())
walls.register("princess:princess_white_material_wall", "White Princess Material Stuff Wall", "princess_white_material.png",
		"princess:princess_white_material", default.node_sound_defaults())

minetest.register_node("princess:ghost_princess_dungeon_brick", {
	description = "Secret dungeon door.",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = false,
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
	},
	drop = "princess:princess_dungeon_brick",
	tiles = {"blank.png", "blank.png", "blank.png", "blank.png", "blank.png", "princess_dungeon_brick.png"},
	groups = {cracky = 2, not_in_creative_inventory = 1},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("princess:rose_bush", {
	description = "Rose Bush",
	drawtype = "allfaces_optional",
	waving = 1,
	paramtype = "light",
	tiles = {"default_leaves.png^princess_rose_cobble.png"},
	groups = {snappy = 3},
	sounds = default.node_sound_leaves_defaults()
})

register_internal_material("princess_brick_blue", {cracky = 3}, {"princess_brick_blue.png"},
		"Blue Princess Brick", default.node_sound_stone_defaults())
register_internal_material("princess_brick_yellow", {cracky = 3}, {"princess_brick_yellow.png"},
		"Yellow Princess Brick", default.node_sound_stone_defaults())
register_internal_material("princess_brick", {cracky = 3}, {"princess_brick.png"},
		"Princess Brick", default.node_sound_stone_defaults())
register_internal_material("princess_dungeon_brick", {cracky = 2}, {"princess_dungeon_brick.png"},
		"Princess Dungeon Brick", default.node_sound_stone_defaults())
register_internal_material("princess_mossy_dungeon_brick", {cracky = 2}, {"princess_mossy_dungeon_brick.png"},
		"Mossy Princess Dungeon Brick", default.node_sound_stone_defaults())
register_internal_material("princess_pink_material", {cracky = 3}, {"princess_pink_material.png"},
		"Pink Princess Material Stuff", default.node_sound_defaults())
register_internal_material("princess_rose_cobble", {cracky = 3, stone = 2}, {"default_cobble.png^princess_rose_cobble.png"},
		"Rose Cobblestone", default.node_sound_stone_defaults())
register_internal_material("princess_tower_brick", {cracky = 2}, {"princess_tower_brick.png"},
		"Princess Tower Brick", default.node_sound_stone_defaults())
register_internal_material("princess_tower_crack_brick", {cracky = 3}, {"princess_tower_crack_brick.png"},
		"cracked Princess Tower Brick", default.node_sound_stone_defaults())
register_internal_material("princess_white_material", {cracky = 3}, {"princess_white_material.png"},
		"White Princess Material Stuff", default.node_sound_defaults())

if minetest.get_modpath("furniture") then
	furniture.register_wooden("princess:princess_pink_material", {
		tiles_chair = {"princess_pink_material.png"},
		tiles_table = {"princess_pink_material.png"}
	})
	furniture.register_stone("princess:princess_rose_cobble", {})
	furniture.register_wooden("princess:princess_white_material", {
		tiles_chair = {"princess_white_material.png"},
		tiles_table = {"princess_white_material.png"}
	})
	furniture.register_seat("princess:throne")
end

if minetest.get_modpath("viaduct") then
	viaduct.register_wood_bridge("princess:princess_pink_material", {})
	viaduct.register_wood_bridge("princess:princess_white_material", {})
end

minetest.register_craft({
	output = "princess:gold_candle",
	recipe = {
		{"default:torch"},
		{"default:gold_ingot"}
	}
})

minetest.register_craft({
	output = "princess:gold_candle_unlit",
	recipe = {
		{"group:stick"},
		{"default:gold_ingot"}
	}
})

minetest.register_craft({
	output = "princess:gold_chandelier",
	recipe = {
		{"", "default:gold_ingot", ""},
		{"default:torch", "default:gold_ingot", "default:torch"}
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "princess:princess_brick",
	recipe = {"default:brick", "default:mese_crystal", "dye:pink"}
})

minetest.register_craft({
	type = "shapeless",
	output = "princess:princess_brick_blue",
	recipe = {"princess:princess_brick", "dye:cyan"}
})

minetest.register_craft({
	type = "shapeless",
	output = "princess:princess_brick_yellow",
	recipe = {"princess:princess_brick", "dye:yellow"}
})

minetest.register_craft({
	output = "princess:princess_chest",
	recipe = {
		{"princess:princess_pink_material", "princess:princess_pink_material", "princess:princess_pink_material"},
		{"princess:princess_pink_material", "", "princess:princess_pink_material"},
		{"princess:princess_pink_material", "princess:princess_pink_material", "princess:princess_pink_material"}
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "princess:princess_dungeon_brick",
	recipe = {"default:stonebrick", "default:mese_crystal_fragment"}
})

minetest.register_craft({
	type = "shapeless",
	output = "princess:princess_mossy_dungeon_brick",
	recipe = {"default:mossycobble", "princess:princess_dungeon_brick"},
	replacements = {
		{"default:mossycobble", "default:cobble"}
	}
})

minetest.register_craft({
	output = "princess:princess_pink_material",
	recipe = {
		{"default:tin_lump", "default:tin_lump", "default:tin_lump"},
		{"default:tin_lump", "dye:pink", "default:tin_lump"},
		{"default:tin_lump", "default:tin_lump", "default:tin_lump"},
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "princess:princess_tower_brick",
	recipe = {"default:stonebrick", "default:mese_crystal"}
})

minetest.register_craft({
	type = "cooking",
	output = "princess:princess_tower_brick",
	recipe = "princess:princess_tower_crack_brick",
	cooktime = 3
})

minetest.register_craft({
	type = "shapeless",
	output = "princess:princess_tower_crack_brick",
	recipe = {"princess:princess_tower_brick"}
})

minetest.register_craft({
	output = "princess:princess_white_material",
	recipe = {
		{"default:tin_lump", "default:tin_lump", "default:tin_lump"},
		{"default:tin_lump", "dye:white", "default:tin_lump"},
		{"default:tin_lump", "default:tin_lump", "default:tin_lump"},
	}
})

minetest.register_craft({
	output = "princess:gold_chandelier_unlit",
	recipe = {
		{"", "default:gold_ingot", ""},
		{"group:stick", "default:gold_ingot", "group:stick"}
	}
})

minetest.register_craft({
	output = "princess:throne",
	recipe = {
		{"princess:princess_white_material", ""},
		{"princess:princess_white_material", "wool:pink"},
		{"princess:princess_white_material", "princess:princess_white_material"}
	}
})

minetest.register_craft({
	output = "princess:throne",
	recipe = {
		{"", "princess:princess_white_material"},
		{"wool:pink", "princess:princess_white_material"},
		{"princess:princess_white_material", "princess:princess_white_material"}
	}
})

minetest.register_craft({
	output = "princess:princess_rose_cobble",
	recipe = {
		{"", "flowers:rose", ""},
		{"flowers:rose", "default:cobble", "flowers:rose"},
		{"", "flowers:rose", ""}
	}
})

minetest.register_craft({
	output = "princess:rose_bush",
	recipe = {
		{"", "flowers:rose", ""},
		{"flowers:rose", "default:bush_leaves", "flowers:rose"},
		{"", "flowers:rose", ""}
	}
})

if minetest.get_modpath("mymillwork") then
	mymillwork.register_all(
		"princess_pink_material",
		"Pink Princess Material Stuff",
		"princess_pink_material.png",
		{cracky = 2, not_in_creative_inventory = 1},
		"princess:princess_pink_material"
	)

	mymillwork.register_all(
		"princess_rose_cobble",
		"Rose Cobblestone",
		"default_cobble.png^princess_rose_cobble.png",
		{cracky = 3, not_in_creative_inventory = 1},
		"princess:princess_rose_cobble"
	)

	mymillwork.register_all(
		"princess_white_material",
		"White Princess Material Stuff",
		"princess_white_material.png",
		{cracky = 2, not_in_creative_inventory = 1},
		"princess:princess_white_material"
	)
end

if minetest.get_modpath("treasurer") then
	treasurer.register_treasure("princess:gold_candle",0.002,7,{1,5},nil,"light")
	treasurer.register_treasure("princess:gold_candle_unlit",0.001,3,{1,5})
	treasurer.register_treasure("princess:gold_chandelier",0.002,7,1,nil,"light")
	treasurer.register_treasure("princess:gold_chandelier_unlit",0.001,3,1)
	treasurer.register_treasure("princess:ghost_princess_dungeon_brick",0.000001,10,{1,2})
	treasurer.register_treasure("princess:princess_brick_blue",0.006,9,{1,8},nil,"building_block")
	treasurer.register_treasure("princess:princess_brick_yellow",0.006,9,{1,8},nil,"building_block")
	treasurer.register_treasure("princess:princess_brick",0.006,9,{1,8},nil,"building_block")
	treasurer.register_treasure("princess:princess_dungeon_brick",0.002,5,{1,5},nil,"building_block")
	treasurer.register_treasure("princess:princess_mossy_dungeon_brick",0.001,5,1,nil,"building_block")
	treasurer.register_treasure("princess:princess_pink_material",0.008,5,{1,16},nil,"building_block")
	treasurer.register_treasure("princess:princess_pink_material_door",0.002,5,1,nil,"building_block")
	treasurer.register_treasure("princess:princess_rose_cobble",0.005,1,{1,5},nil,"building_block")
	treasurer.register_treasure("princess:princess_tower_brick",0.002,9,{1,5},nil,"building_block")
	treasurer.register_treasure("princess:princess_tower_crack_brick",0.001,8,1,nil,"building_block")
	treasurer.register_treasure("princess:princess_white_material",0.008,5,{1,16},nil,"building_block")
	treasurer.register_treasure("princess:princess_white_material_door",0.002,5,1,nil,"building_block")
	treasurer.register_treasure("princess:throne",0.0005,6,1,nil,"deco")
end
