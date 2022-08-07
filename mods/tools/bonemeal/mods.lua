
-- craft bones from animalmaterials into bonemeal
if minetest.get_modpath("animalmaterials") then

	minetest.register_craft({
		output = "bonemeal:bonemeal 2",
		recipe = {{"animalmaterials:bone"}}
	})
end


if farming and farming.mod and farming.mod == "redo" then

	bonemeal:add_crop({
		{"farming:tomato_", 8},
		{"farming:corn_", 8},
		{"farming:melon_", 8},
		{"farming:pumpkin_", 8},
		{"farming:beanpole_", 5},
		{"farming:blueberry_", 4},
		{"farming:raspberry_", 4},
		{"farming:carrot_", 8},
		{"farming:cocoa_", 4},
		{"farming:coffee_", 5},
		{"farming:cucumber_", 4},
		{"farming:potato_", 4},
		{"farming:grapes_", 8},
		{"farming:rhubarb_", 3},
		{"farming:barley_", 7},
		{"farming:hemp_", 8},
		{"farming:chili_", 8},
		{"farming:garlic_", 5},
		{"farming:onion_", 5},
		{"farming:pepper_", 7},
		{"farming:pineapple_", 8},
		{"farming:pea_", 5},
		{"farming:beetroot_", 5},
		{"farming:rye_", 8},
		{"farming:oat_", 8},
		{"farming:rice_", 8},
		{"farming:mint_", 4},
		{"farming:cabbage_", 6},
		{"farming:lettuce_", 5},
		{"farming:blackberry_", 4},
		{"farming:vanilla_", 8},
		{"farming:soy_", 7},
		{"farming:artichoke_", 5},
		{"farming:parsley_", 3},
		{"farming:sunflower_", 8}
	})
end


if minetest.get_modpath("ethereal") then

	bonemeal:add_crop({
		{"ethereal:strawberry_", 8},
		{"ethereal:onion_", 5}
	})

	bonemeal:add_sapling({
		{"ethereal:palm_sapling", ethereal.grow_palm_tree, "soil"},
		{"ethereal:palm_sapling", ethereal.grow_palm_tree, "sand"},
		{"ethereal:yellow_tree_sapling", ethereal.grow_yellow_tree, "soil"},
		{"ethereal:big_tree_sapling", ethereal.grow_big_tree, "soil"},
		{"ethereal:banana_tree_sapling", ethereal.grow_banana_tree, "soil"},
		{"ethereal:frost_tree_sapling", ethereal.grow_frost_tree, "soil"},
		{"ethereal:mushroom_sapling", ethereal.grow_mushroom_tree, "soil"},
		{"ethereal:willow_sapling", ethereal.grow_willow_tree, "soil"},
		{"ethereal:redwood_sapling", ethereal.grow_redwood_tree, "soil"},
		{"ethereal:giant_redwood_sapling", ethereal.grow_giant_redwood_tree, "soil"},
		{"ethereal:orange_tree_sapling", ethereal.grow_orange_tree, "soil"},
		{"ethereal:bamboo_sprout", ethereal.grow_bamboo_tree, "soil"},
		{"ethereal:birch_sapling", ethereal.grow_birch_tree, "soil"},
		{"ethereal:sakura_sapling", ethereal.grow_sakura_tree, "soil"},
		{"ethereal:lemon_tree_sapling", ethereal.grow_lemon_tree, "soil"},
		{"ethereal:olive_tree_sapling", ethereal.grow_olive_tree, "soil"}
	})

	local grass = {"default:grass_3", "default:grass_4", "default:grass_5", ""}

	bonemeal:add_deco({
		{"ethereal:crystal_dirt", {"ethereal:crystalgrass", "", "", "", ""}, {}},
		{"ethereal:fiery_dirt", {"ethereal:dry_shrub", "", "", "", ""}, {}},
		{"ethereal:prairie_dirt", grass, {"flowers:dandelion_white",
			"flowers:dandelion_yellow", "flowers:geranium", "flowers:rose",
			"flowers:tulip", "flowers:viola", "ethereal:strawberry_7"}},
		{"ethereal:gray_dirt", {}, {"ethereal:snowygrass", "", ""}},
		{"ethereal:cold_dirt", {}, {"ethereal:snowygrass", "", ""}},
		{"ethereal:mushroom_dirt", {}, {"flowers:mushroom_red", "flowers:mushroom_brown", "", "", ""}},
		{"ethereal:jungle_dirt", grass, {"default:junglegrass", "", "", ""}},
		{"ethereal:grove_dirt", grass, {"ethereal:fern", "", "", ""}},
		{"ethereal:bamboo_dirt", grass, {}}
	})
end


if minetest.get_modpath("moretrees") then

	-- special fir check for snow
	local function fir_grow(pos)

		if minetest.find_node_near(pos, 1,
			{"default:snow", "default:snowblock", "default:dirt_with_snow"}) then

			moretrees.grow_fir_snow(pos)
		else
			moretrees.grow_fir(pos)
		end
	end

	bonemeal:add_sapling({
		{"moretrees:beech_sapling", moretrees.spawn_beech_object, "soil"},
		{"moretrees:apple_tree_sapling", moretrees.spawn_apple_tree_object, "soil"},
		{"moretrees:oak_sapling", moretrees.spawn_oak_object, "soil"},
		{"moretrees:sequoia_sapling", moretrees.spawn_sequoia_object, "soil"},
		{"moretrees:birch_sapling", moretrees.grow_birch, "soil"},
		{"moretrees:palm_sapling", moretrees.spawn_palm_object, "soil"},
		{"moretrees:palm_sapling", moretrees.spawn_palm_object, "sand"},
		{"moretrees:date_palm_sapling", moretrees.spawn_date_palm_object, "soil"},
		{"moretrees:date_palm_sapling", moretrees.spawn_date_palm_object, "sand"},
		{"moretrees:spruce_sapling", moretrees.grow_spruce, "soil"},
		{"moretrees:cedar_sapling", moretrees.spawn_cedar_object, "soil"},
		{"moretrees:poplar_sapling", moretrees.spawn_poplar_object, "soil"},
		{"moretrees:willow_sapling", moretrees.spawn_willow_object, "soil"},
		{"moretrees:rubber_tree_sapling", moretrees.spawn_rubber_tree_object, "soil"},
		{"moretrees:fir_sapling", fir_grow, "soil"}
	})

elseif minetest.get_modpath("technic_worldgen") then

	bonemeal:add_sapling({
		{"moretrees:rubber_tree_sapling", technic.rubber_tree_model, "soil"}
	})
end


if minetest.get_modpath("caverealms") then

	local fil = minetest.get_modpath("caverealms") .. "/schematics/shroom.mts"
	local add_shroom = function(pos)

		minetest.swap_node(pos, {name = "air"})

		minetest.place_schematic(
			{x = pos.x - 5, y = pos.y, z = pos.z - 5}, fil, 0, nil, false)
	end

	bonemeal:add_sapling({
		{"caverealms:mushroom_sapling", add_shroom, "soil"}
	})
end


local function y_func(grow_func)
	return function(pos)
		grow_func({x = pos.x, y = pos.y - 1, z = pos.z})
	end
end

if minetest.get_modpath("ferns") then

	bonemeal:add_sapling({
		{"ferns:sapling_giant_tree_fern", y_func(abstract_ferns.grow_giant_tree_fern), "soil"},
		{"ferns:sapling_giant_tree_fern", y_func(abstract_ferns.grow_giant_tree_fern), "sand"},
		{"ferns:sapling_tree_fern", y_func(abstract_ferns.grow_tree_fern), "soil"}
	})
end

if minetest.get_modpath("dryplants") then

	bonemeal:add_sapling({
		{"dryplants:reedmace_sapling", y_func(abstract_dryplants.grow_reedmace), "soil"}
	})
end


if minetest.get_modpath("dye") then

	local bonemeal_dyes = {
			bonemeal = "white", fertiliser = "green", mulch = "brown"}

	for mat, dye in pairs(bonemeal_dyes) do

		minetest.register_craft({
			output = "dye:" .. dye .. " 4",
			recipe = {
				{"bonemeal:" .. mat}
			},
		})
	end
end


if minetest.get_modpath("df_trees") then

	local function spore_tree_fix(pos)
		minetest.set_node(pos, {name = "air"})
		df_trees.spawn_spore_tree(pos)
	end

	local function fungiwood_fix(pos)
		minetest.set_node(pos, {name = "air"})
		df_trees.spawn_fungiwood(pos)
	end

	bonemeal:add_sapling({
		{"df_trees:black_cap_sapling", df_trees.spawn_black_cap, "soil", true},
		{"df_trees:fungiwood_sapling", fungiwood_fix, "soil", true},
		{"df_trees:goblin_cap_sapling", df_trees.spawn_goblin_cap, "soil", true},
		{"df_trees:spore_tree_sapling", spore_tree_fix, "soil", true},
		{"df_trees:tower_cap_sapling", df_trees.spawn_tower_cap, "soil", true},
		{"df_trees:tunnel_tube_sapling", df_trees.spawn_tunnel_tube, "soil", true},
		{"df_trees:nether_cap_sapling", df_trees.spawn_nether_cap, "group:nether_cap", true},
		{"df_trees:nether_cap_sapling", df_trees.spawn_nether_cap, "group:cools_lava", true}
	})
end


if minetest.get_modpath("df_farming") then

	bonemeal:add_crop({
		{"df_farming:cave_wheat_", 8, "df_farming:cave_wheat_seed", true},
		{"df_farming:dimple_cup_", 4, "df_farming:dimple_cup_seed", true},
		{"df_farming:pig_tail_", 8, "df_farming:pig_tail_seed", true},
		{"df_farming:plump_helmet_", 4, "df_farming:plump_helmet_spawn", true},
		{"df_farming:quarry_bush_", 5, "df_farming:quarry_bush_seed", true},
		{"df_farming:sweet_pod_", 6, "df_farming:sweet_pod_seed", true}
	})
end


if minetest.get_modpath("df_primordial_items") then

	local function mush_fix(pos)
		minetest.set_node(pos, {name = "air"})
		mapgen_helper.place_schematic(pos,
			df_primordial_items.get_primordial_mushroom(), (math.random(1,4)-1)*90)
	end

	local function fern_fix(pos)
		minetest.set_node(pos, {name = "air"})
		local rotations = {0, 90, 180, 270}
		mapgen_helper.place_schematic(pos,
			df_primordial_items.get_fern_schematic(), rotations[math.random(1,#rotations)])
	end

	bonemeal:add_sapling({
		{"df_primordial_items:jungle_mushroom_sapling",
			df_primordial_items.spawn_jungle_mushroom, "soil", true},
		{"df_primordial_items:jungletree_sapling",
			df_primordial_items.spawn_jungle_tree, "soil", true},
		{"df_primordial_items:mush_sapling", mush_fix, "soil", true},
		{"df_primordial_items:fern_sapling", fern_fix, "soil", true}
	})

	local jgrass = {
		"df_primordial_items:jungle_grass_1",
		"df_primordial_items:jungle_grass_2",
		"df_primordial_items:jungle_grass_3",
		"df_primordial_items:fern_1",
		"df_primordial_items:fern_2",
		"", "", "", ""
	}

	local jdeco = {
		"df_primordial_items:jungle_mushroom_1",
		"df_primordial_items:jungle_mushroom_2",
		"df_primordial_items:glow_plant_1",
		"df_primordial_items:glow_plant_2",
		"df_primordial_items:glow_plant_3",
		"", "", ""
	}

	bonemeal:add_deco({
		{"df_primordial_items:dirt_with_jungle_grass", jgrass, jdeco}
	})
end
