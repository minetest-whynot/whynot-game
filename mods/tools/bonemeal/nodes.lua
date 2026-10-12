
local S = core.get_translator "bonemeal"

-- bone block

core.register_node("bonemeal:bone_block", {
	description = S("Bone Block"),
	tiles = {"bonemeal_bone_block_top.png", "bonemeal_bone_block.png", "bonemeal_bone_block.png"},
	groups = {oddly_breakable_by_hand = 3, cracky = 3},
	is_ground_content = false,
	paramtype2 = "facedir",
	sounds = default.node_sound_stone_defaults(),
	on_place = core.rotate_node
})

core.register_craft {
	output = "bonemeal:bone_block",
	recipe = {
		{"bonemeal:bone", "bonemeal:bone", "bonemeal:bone"},
		{"bonemeal:bone", "bonemeal:bone", "bonemeal:bone"},
		{"bonemeal:bone", "bonemeal:bone", "bonemeal:bone"}
	}
}

-- bone brick

core.register_node("bonemeal:bone_brick", {
	description = S("Bone Brick"),
	tiles = {"bonemeal_bone_brick.png"},
	groups = {oddly_breakable_by_hand = 3, cracky = 3},
	is_ground_content = false,
	paramtype2 = "facedir",
	sounds = default.node_sound_stone_defaults(),
	on_place = core.rotate_node
})

core.register_craft {
	output = "bonemeal:bone_brick 4",
	recipe = {
		{"bonemeal:bone_block", "bonemeal:bone_block"},
		{"bonemeal:bone_block", "bonemeal:bone_block"}
	}
}

-- tiled bone

core.register_node("bonemeal:bone_tile", {
	description = S("Bone Tile"),
	tiles = {"bonemeal_bone_tile.png"},
	groups = {oddly_breakable_by_hand = 3, cracky = 3},
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults()
})

core.register_craft {
	output = "bonemeal:bone_tile 9",
	recipe = {
		{"bonemeal:bone_block", "bonemeal:bone_block", "bonemeal:bone_block"},
		{"bonemeal:bone_block", "bonemeal:bone_block", "bonemeal:bone_block"},
		{"bonemeal:bone_block", "bonemeal:bone_block", "bonemeal:bone_block"}
	}
}

-- blocks back to bone

core.register_craft { output = "bonemeal:bone 9", recipe = {{"bonemeal:bone_block"}} }
core.register_craft { output = "bonemeal:bone 9", recipe = {{"bonemeal:bone_brick"}} }
core.register_craft { output = "bonemeal:bone 9", recipe = {{"bonemeal:bone_tile"}} }
