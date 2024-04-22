local textures = {
    gravel = "[combine:16x16^[noalpha^[colorize:#3a3b3c",
    brick = "[combine:16x16^[noalpha^[colorize:#AA4A44",

    metal = {
        steel = {
            ore = "[combine:16x16^[noalpha^[colorize:#D3D3D3",
            ingot = "[combine:16x16^[noalpha^[colorize:#D3D3D3",
            block = "[combine:16x16^[noalpha^[colorize:#D3D3D3",
        },
        gold = {
            ore = "[combine:16x16^[noalpha^[colorize:#FFD700",
            ingot = "[combine:16x16^[noalpha^[colorize:#FFD700",
            block = "[combine:16x16^[noalpha^[colorize:#FFD700",
        },
    },
    glass = {
        pane = "[combine:16x16:" ..
            "0,0=\\[combine\\:1x16\\^[noalpha\\^[colorize\\:#ffffff:" ..
            "0,0=\\[combine\\:16x1\\^[noalpha\\^[colorize\\:#ffffff:" ..
            "0,15=\\[combine\\:16x1\\^[noalpha\\^[colorize\\:#ffffff:" ..
            "15,0=\\[combine\\:1x16\\^[noalpha\\^[colorize\\:#ffffff",
        detail = "[combine:16x16:" ..
            "0,0=\\[combine\\:1x16\\^[noalpha\\^[colorize\\:#ffffff:" ..
            "0,0=\\[combine\\:16x1\\^[noalpha\\^[colorize\\:#ffffff:" ..
            "0,15=\\[combine\\:16x1\\^[noalpha\\^[colorize\\:#ffffff:" ..
            "15,0=\\[combine\\:1x16\\^[noalpha\\^[colorize\\:#ffffff",
    },
    wood = {
        apple = {
            sapling = "[combine:16x16^[noalpha^[colorize:#654321",
            planks = "[combine:16x16^[noalpha^[colorize:#654321",
            trunk_side = "[combine:16x16^[noalpha^[colorize:#654321",
            trunk_top = "[combine:16x16^[noalpha^[colorize:#654321",
            leaves = "[combine:16x16^[noalpha^[colorize:#654321",
        },
        jungle = {
            sapling = "[combine:16x16^[noalpha^[colorize:#563d2d",
            planks = "[combine:16x16^[noalpha^[colorize:#563d2d",
            trunk_side = "[combine:16x16^[noalpha^[colorize:#563d2d",
            trunk_top = "[combine:16x16^[noalpha^[colorize:#563d2d",
            leaves = "[combine:16x16^[noalpha^[colorize:#563d2d",
        },
    },
    water = {
        tile = "[combine:16x16^[noalpha^[colorize:#00008b",
        animated = {
            source = "[combine:16x16^[noalpha^[colorize:#00008b",
            flowing = "[combine:16x16^[noalpha^[colorize:#00008b",
        },
    },
    wool = {
        white = "[combine:16x16^[noalpha^[colorize:#ffffff",
        black = "[combine:16x16^[noalpha^[colorize:#000000",
        grey = "[combine:16x16^[noalpha^[colorize:#313b3c",
        dark_grey = "[combine:16x16^[noalpha^[colorize:#313b3c",
    },
    grass = {
        top = "[combine:16x16^[noalpha^[colorize:#006400",
        side = "[combine:16x16^[noalpha^[colorize:#006400",
        dirt = "[combine:16x16^[noalpha^[colorize:#563d2d",
    },
}

if minetest.get_modpath("default") then
    textures = {
        gravel = "default_gravel.png",
        brick = "default_brick.png",

        metal = {
            steel = {
                ore = "default_iron_lump.png",
                ingot = "default_steel_ingot.png",
                block = "default_steel_block.png",
            },
            gold = {
                ore = "default_gold_lump.png",
                ingot = "default_gold_ingot.png",
                block = "default_gold_block.png",
            },
        },
        glass = {
            pane = "default_glass.png",
            detail = "default_glass_detail.png",
        },
        wood = {
            apple = {
                sapling = "default_sapling.png",
                planks = "default_wood.png",
                trunk_side = "default_tree.png",
                trunk_top = "default_tree_top.png",
                leaves = "default_leaves.png",
            },
            jungle = {
                sapling = "default_junglesapling.png",
                planks = "default_junglewood.png",
                trunk_side = "default_jungletree.png",
                trunk_top = "default_jungletree_top.png",
                leaves = "default_jungleleaves.png",
            },
        },
        water = {
            tile = "default_water.png",
            animated = {
                source = "default_water_source_animated.png",
                flowing = "default_water_flowing_animated.png",
            },
        },
        wool = {
            white = "wool_white.png",
            black = "wool_black.png",
            grey = "wool_grey.png",
            dark_grey = "wool_dark_grey.png",
        },
        grass = {
            top = "default_grass.png",
            side = "default_dirt.png^default_grass_side.png",
            dirt = "default_dirt.png",
        },
    }
elseif minetest.get_modpath("fl_ores") and minetest.get_modpath("fl_stone") then
    textures = {
        gravel = "farlands_gravel.png",
        brick = "farlands_brick.png",

        metal = {
            steel = {
                ore = "farlands_iron_ingot.png",
                ingot = "farlands_iron_ingot.png",
                block = "farlands_iron_block.png",
            },
            gold = {
                ore = "farlands_gold_ore.png",
                ingot = "farlands_gold_ingot.png",
                block = "farlands_gold_block.png",
            },
        },
        glass = {
            pane = "farlands_glass.png",
            detail = "farlands_glass_detail.png",
        },
        wood = {
            apple = {
                sapling = "farlands_apple_sapling.png",
                planks = "farlands_apple_planks.png",
                trunk_side = "farlands_apple_trunk.png",
                trunk_top = "farlands_apple_trunk_top.png",
                leaves = "farlands_apple_leaves.png",
            },
            jungle = {
                sapling = "farlands_jungletree_sapling.png",
                planks = "farlands_jungletree_planks.png",
                trunk_side = "farlands_jungletree_trunk.png",
                trunk_top = "farlands_jungletree_trunk_top.png",
                leaves = "farlands_jungletree_leaves.png",
            },
        },
        water = {
            tile = "farlands_water.png",
            animated = {
                source = "farlands_water_source_animated.png",
                flowing = "farlands_water_flowing_animated.png",
            },
        },
        wool = {
            white = "farlands_wool.png",
            black = "farlands_wool.png",
            grey = "farlands_wool.png",
            dark_grey = "farlands_wool.png",
        },
        grass = {
            top = "farlands_grass.png",
            side = "farlands_dirt.png^farlands_grass_side.png",
            dirt = "farlands_dirt.png",
        },
    }
end

return textures