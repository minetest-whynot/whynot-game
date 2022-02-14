-- homedecor_windows_and_treatments, homedecor_lighting
minetest.register_alias('cottages:wool', 'wool:white')

-- homedecor_kitchen
minetest.register_alias('moreblocks:iron_glass', 'default:obsidian_glass')

-- homedecor_kitchen
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

-- homedecor_tables vs ts_furniture
-- homedecor_lighting
-- Solve recipe overlap between homedecor:table and ts_furniture:default_*wood_small_table
-- Now homedecor:table is crafteable by ts_furniture:default_*wood_table
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


-- Migration away to clinew's farming_plus. Aliases to the *2 nodes
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

-- Remove redundant sugar in farming and mtfoods
minetest.unregister_item("mtfoods:sugar")
minetest.clear_craft({output = "mtfoods:sugar"})
minetest.register_alias("mtfoods:sugar", "farming:sugar")

-- If previously the endless_apples was used, now merged to minetest game default mod
minetest.register_alias("endless_apples:apple_mark", "default:apple_mark")

-- Remove the demo skin upright_sprite
if minetest.get_modpath('player_api') and player_api.registered_skins then
	player_api.registered_skins['sprite'] = nil
end

-- Remove bonemeal recipe in favor of the heads
minetest.clear_craft({
	type = "shapeless",
	recipe = {"bones:bones"}
})

-- https://github.com/rubenwardy/food/issues/32
-- food_basic vs food_sweet
-- Replace egg recipe by one with water to avoid conflict with lemon
minetest.clear_craft({output = "food:egg"})
minetest.register_craft({
	output = "food:egg",
	recipe = {
		{"", "default:sand", ""},
		{"default:sand", "bucket:bucket_water", "default:sand"},
		{"", "default:sand", ""}
	},
	replacements = {{"bucket:bucket_water", "bucket:bucket_empty"}},
})
