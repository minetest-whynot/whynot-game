local S = minetest.get_translator("mtg_plus")

-- Walls
walls.register("mtg_plus:wall_sandstone_cobble", S("Cobbled Sandstone Wall"), "mtg_plus_sandstone_cobble.png", "mtg_plus:sandstone_cobble", default.node_sound_stone_defaults())
walls.register("mtg_plus:wall_desert_sandstone_cobble", S("Cobbled Desert Sandstone Wall"), "mtg_plus_desert_sandstone_cobble.png", "mtg_plus:desert_sandstone_cobble", default.node_sound_stone_defaults())
walls.register("mtg_plus:wall_silver_sandstone_cobble", S("Cobbled Silver Sandstone Wall"), "mtg_plus_silver_sandstone_cobble.png", "mtg_plus:silver_sandstone_cobble", default.node_sound_stone_defaults())
walls.register("mtg_plus:wall_jungle_cobble", S("Jungle Cobblestone Wall"), "mtg_plus_jungle_cobble.png", "mtg_plus:jungle_cobble", default.node_sound_stone_defaults())
walls.register("mtg_plus:wall_ice_tile16", S("Dense Ice Tile Wall"), "mtg_plus_ice_tile16.png", "mtg_plus:ice_tile16", default.node_sound_glass_defaults())
walls.register("mtg_plus:wall_gravel_cobble", S("Cobbled Gravel Wall"), "mtg_plus_gravel_cobble.png", "mtg_plus:gravel_cobble", default.node_sound_stone_defaults())


do
	local longdesc = S("A piece of wall creates simple barriers that connect to neighbor blocks. Walls can be jumped over.")

	local groups = minetest.registered_items["mtg_plus:wall_ice_tile16"].groups
	groups.stone = nil
	groups.slippery = 1
	minetest.override_item("mtg_plus:wall_ice_tile16", { groups = groups, _doc_items_longdesc = longdesc })

	groups = minetest.registered_items["mtg_plus:wall_sandstone_cobble"].groups
	groups.stone = nil
	minetest.override_item("mtg_plus:wall_sandstone_cobble", { groups = groups, _doc_items_longdesc = longdesc })

	minetest.override_item("mtg_plus:wall_desert_sandstone_cobble", { _doc_items_longdesc = longdesc })
	minetest.override_item("mtg_plus:wall_silver_sandstone_cobble", { _doc_items_longdesc = longdesc })
	minetest.override_item("mtg_plus:wall_jungle_cobble", { _doc_items_longdesc = longdesc })
	minetest.override_item("mtg_plus:wall_gravel_cobble", { _doc_items_longdesc = longdesc })
end

-- Fences
default.register_fence("mtg_plus:fence_goldwood", {
	description = S("Goldwood Fence"),
	_doc_items_longdesc = S("This is a fence made out of precious goldwood. The fence will neatly connect to its neighbors, making it easy to build nice-looking fence structures. The fence can be jumped over."),
	texture = "mtg_plus_goldwood.png",
	material = "mtg_plus:goldwood",
	sounds = minetest.registered_nodes["mtg_plus:goldwood"].sounds,
	groups = {choppy=2, },
})

default.register_fence_rail("mtg_plus:fence_rail_goldwood", {
	description = S("Goldwood Fence Rail"),
	_doc_items_longdesc = S("This is a fence rail made out of precious goldwood. It will neatly connect to its neighbors, but without creating fence posts. It can be jumped over."),
	texture = "mtg_plus_fence_rail_goldwood.png",
	inventory_image = "default_fence_rail_overlay.png^mtg_plus_goldwood.png^" ..
		"default_fence_rail_overlay.png^[makealpha:255,126,126",
	wield_image = "default_fence_rail_overlay.png^mtg_plus_goldwood.png^" ..
		"default_fence_rail_overlay.png^[makealpha:255,126,126",
	material = "mtg_plus:goldwood",
	groups = {choppy = 2, },
	sounds = minetest.registered_nodes["mtg_plus:goldwood"].sounds,
})
