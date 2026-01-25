-- crafts for common items that are used by more than one home decor component

local S = core.get_translator("homedecor_common")

-- items

core.register_craftitem(":homedecor:roof_tile_terracotta", {
        description = S("Terracotta Roof Tile"),
        inventory_image = "homedecor_roof_tile_terracotta.png",
})

core.register_craftitem(":homedecor:drawer_small", {
        description = S("Small Wooden Drawer"),
        inventory_image = "homedecor_drawer_small.png",
})

-- cooking/fuel

core.register_craft({
        type = "cooking",
        output = "homedecor:roof_tile_terracotta",
        recipe = "basic_materials:terracotta_base",
})

core.register_craft({
        type = "fuel",
        recipe = "homedecor:shingles_wood",
        burntime = 30,
})


-- crafing

core.register_craft( {
        output = "homedecor:shingles_terracotta",
        recipe = {
                { "homedecor:roof_tile_terracotta", "homedecor:roof_tile_terracotta"},
                { "homedecor:roof_tile_terracotta", "homedecor:roof_tile_terracotta"},
        },
})

core.register_craft( {
        output = "homedecor:roof_tile_terracotta 8",
        recipe = {
			{ "homedecor:shingles_terracotta", "homedecor:shingles_terracotta" }
		}
})

core.register_craft( {
        output = "homedecor:shingles_wood 12",
        recipe = {
                { "group:stick", "group:wood"},
                { "group:wood", "group:stick"},
        },
})

core.register_craft( {
        output = "homedecor:shingles_wood 12",
        recipe = {
                { "group:wood", "group:stick"},
                { "group:stick", "group:wood"},
        },
})

core.register_craft( {
        output = "homedecor:shingles_asphalt 6",
        recipe = {
                { "building_blocks:gravel_spread", "dye:black", "building_blocks:gravel_spread" },
                { "group:sand", "dye:black", "group:sand" },
                { "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
        },
})

