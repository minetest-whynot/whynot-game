local materials = {
    sand = "basenodes:sand",
    gravel = "basenodes:gravel",
    stone = "basenodes:stone",
    cobble = "basenodes:cobble",
    jungle_leaves = "basenodes:jungleleaves",
    jungle_log = "basenodes:jungletree",
    desert_sand = "basenodes:desert_sand",
    desert_stone = "basenodes:desert_stone",
    dirt = "basenodes:dirt",
    dirt_with_grass = "basenodes:dirt_with_grass",
    water_source = "basenodes:water_source",
    water_flowing = "basenodes:water_flowing",
    apple_leaves = "basenodes:leaves",
    apple_log = "basenodes:tree",
    coal_lump = "unittests:coal_lump",
    iron_lump = "unittests:iron_lump",
    steel_ingot = "unittests:steel_ingot",
    axe_steel = "basetools:axe_steel",
    axe_stone = "basetools:axe_stone",
    axe_wood = "basetools:axe_wood",
    pick_steel = "basetools:pick_steel",
    mese = "unittests:steel_ingot",
    mese_crystal = "unittests:steel_ingot",
    mese_crystal_fragment = "unittests:steel_ingot",
    empty_bucket = "bucket:bucket",
    water_bucket = "basenodes:water_source",
    stick = "unittests:stick",
    torch = "unittests:torch",
    string = "testpathfinder:testpathfinder",
    glass = "testnodes:glasslike",
    glass_block = "testnodes:glasslike_framed",
    glass_bottle = "testnodes:glassliquid",
    obsidian_glass = "testnodes:glasslike_framed_no_detail",
    chest = "chest:chest",
    brick = "tiled:tiled",
    paper = "testnodes:nodebox_leveled",
    book = "testtools:item_meta_editor",
    slab_stone = "stairs:slab_stone",
    birch_leaves = "basenodes:pine_needles",
    birch_log = "basenodes:pine_tree",
    silicon = "mesecons_materials:silicon",
}

if minetest.get_modpath("moreores") then
    materials.tin_ingot = "moreores:tin_ingot"
    materials.tin_block = "moreores:tin_block"
    materials.silver_ingot = "moreores:silver_ingot"
end

if minetest.get_modpath("technic") then
	materials.lead_ingot = "technic:lead_ingot"
	materials.carbon_steel_ingot = "technic:carbon_steel_ingot"
	materials.stainless_steel_ingot = "technic:stainless_steel_ingot"
end

return materials
