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


-- Aliases from clinew's farming_plus have expired, as they are 5 years old.
-- See https://github.com/minetest-whynot/whynot-game/issues/97

-- Remove redundant sugar in farming and mtfoods
minetest.unregister_item("mtfoods:sugar")
minetest.clear_craft({output = "mtfoods:sugar"})
minetest.register_alias("mtfoods:sugar", "farming:sugar")

-- If previously the endless_apples was used, now merged to minetest game default mod
minetest.register_alias("endless_apples:apple_mark", "default:apple_mark")

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

--https://github.com/minetest-whynot/whynot-game/issues/49
--https://github.com/mt-mods/homedecor_modpack/issues/17
-- Add lost stairs and slabs back
for _ , material in ipairs({ "Adobe", "fakegrass", "grate", "hardwood",
		"Marble", "Roofing", "smoothglass", "Tar", "woodglass" }) do

	local nodedef = minetest.registered_items["building_blocks:"..material]
	stairs.register_stair_and_slab(
			material,
			nodedef.name,
			table.copy(nodedef.groups),
			table.copy(nodedef.tiles),
			nodedef.description.." stair",
			nodedef.description.." slab",
			nodedef.sounds and table.copy(nodedef.sounds) or nil,
			false,
			nodedef.description.." inner stair",
			nodedef.description.." outer stair" )
end
