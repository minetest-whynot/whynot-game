-- Used in (Homedecor) Recipes
if not minetest.get_modpath('cottages') then
	minetest.register_alias('cottages:wool', 'wool:white')
end

if not minetest.get_modpath('moreblocks') then
	minetest.register_alias('moreblocks:iron_glass', 'default:obsidian_glass')
end

if minetest.get_modpath('building_blocks') and not minetest.get_modpath('stairsplus') and minetest.get_modpath('stairs') then
	stairs.register_stair_and_slab(
		"granite",
		"technic:granite",
		{cracky = 1},
		{"technic_granite.png"},
		"Granite Stair",
		"Granite Slab",
		default.node_sound_stone_defaults()
	)
	minetest.register_alias('technic:slab_granite_1', 'stairs:slab_granite')
end

-- https://github.com/minetest-mods/homedecor_modpack/pull/402 (rejected)
-- Solve recipe overlap between homedecor:table and ts_furniture:default_*wood_small_table
-- Now homedecor:table is crafteable by ts_furniture:default_*wood_table
if minetest.get_modpath("ts_furniture") and minetest.get_modpath("homedecor") then
	minetest.clear_craft({output = "homedecor:table"})
	for _, ts_table in ipairs( { "ts_furniture:default_wood_table",
			"ts_furniture:default_acacia_wood_table",
			"ts_furniture:default_aspen_wood_table",
			"ts_furniture:default_junglewood_table",
			"ts_furniture:default_pine_wood_table"}) do
		minetest.register_craft({
			type = "shapeless",
			output = "homedecor:table",
			recipe = {
				ts_table,
				"default:stick" ,
				"dye:orange",
			},
		})
		minetest.register_craft({
			type = "shapeless",
			output = "homedecor:table_mahogany",
			recipe = {
				ts_table,
				"default:stick" ,
				"dye:brown",
			},
		})
		minetest.register_craft({
			type = "shapeless",
			output = "homedecor:table_mahogany",
			recipe = {
				ts_table,
				"default:stick" ,
				"unifieddyes:dark_orange",
			},
		})
		minetest.register_craft({
			type = "shapeless",
			output = "homedecor:table_white",
			recipe = {
				ts_table,
				"default:stick" ,
				"dye:white",
			},
		})
	end
end

if minetest.get_modpath('farming') and not minetest.get_modpath('farming_plus') then
-- Migration away to clinew's farming_plus. Aliases to the *2 nodes
	-- Rejected by ten in https://github.com/tenplus1/farming/pull/39
	minetest.register_alias("farming_plus:seed_carrot2", "farming:carrot")
	minetest.register_alias("farming_plus:carrot2_1", "farming:carrot_1")
	minetest.register_alias("farming_plus:carrot2_2", "farming:carrot_4")
	minetest.register_alias("farming_plus:carrot2_3", "farming:carrot_6")
	minetest.register_alias("farming_plus:carrot2_4", "farming:carrot_8")
	minetest.register_alias("farming_plus:carrot2", "farming:carrot")

	minetest.register_alias("farming_plus:potato2_1", "farming:potato_1")
	minetest.register_alias("farming_plus:potato2_2", "farming:potato_2")
	minetest.register_alias("farming_plus:potato2_3", "farming:potato_3")
	minetest.register_alias("farming_plus:potato2_4", "farming:potato_3")
	minetest.register_alias("farming_plus:potato2", "farming:potato")
	minetest.register_alias("farming_plus:seed_potato2", "farming:potato")

	minetest.register_alias("farming_plus:seed_rhubarb2", "farming:rhubarb")
	minetest.register_alias("farming_plus:rhubarb2_1", "farming:rhubarb_1")
	minetest.register_alias("farming_plus:rhubarb2_2", "farming:rhubarb_2")
	minetest.register_alias("farming_plus:rhubarb2_3", "farming:rhubarb_3")
	minetest.register_alias("farming_plus:rhubarb2", "farming:rhubarb")

	minetest.register_alias("farming_plus:strawberry2_1", "farming:raspberry_1")
	minetest.register_alias("farming_plus:strawberry2_2", "farming:raspberry_2")
	minetest.register_alias("farming_plus:strawberry2_3", "farming:raspberry_3")
	minetest.register_alias("farming_plus:strawberry2_4", "farming:raspberry_3")
	minetest.register_alias("farming_plus:strawberry2", "farming:raspberry_4")

	minetest.register_alias("farming_plus:seed_tomato2", "farming:tomato")
	minetest.register_alias("farming_plus:tomato2", "farming:tomato")
	minetest.register_alias("farming_plus:tomato2_1", "farming:tomato_2")
	minetest.register_alias("farming_plus:tomato2_2", "farming:tomato_4")
	minetest.register_alias("farming_plus:tomato2_3", "farming:tomato_6")
	minetest.register_alias("farming_plus:tomato2_4", "farming:tomato_7")

	minetest.register_alias("farming_plus:weed", "default:grass_2")
end


if minetest.get_modpath('farming') and minetest.get_modpath('mtfoods') then
	-- Remove redundant sugar in farming and mtfoods
	minetest.unregister_item("mtfoods:sugar")
	minetest.clear_craft({output = "mtfoods:sugar"})
	minetest.register_alias("mtfoods:sugar", "farming:sugar")
end

-- If previously the endless_apples was used, now merged to minetest game default mod
minetest.register_alias("endless_apples:apple_mark", "default:apple_mark")

-- Remove the demo skin upright_sprite
if minetest.get_modpath('player_api') and player_api.registered_skins then
	player_api.registered_skins['sprite'] = nil
end

if minetest.get_modpath('bonemeal') and minetest.get_modpath('heads') then
	-- Remove redundant sugar in farming and mtfoods
	minetest.clear_craft({
		type = "shapeless",
		recipe = {"bones:bones"}
	})
end
