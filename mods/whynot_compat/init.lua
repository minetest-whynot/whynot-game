-- Homedecor Recipes
minetest.register_alias('cottages:wool', 'wool:white')
minetest.register_alias('moreblocks:iron_glass', 'default:obsidian_glass')

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

minetest.register_alias('homedecor:glowlight_small', 'homedecor:glowlight_small_cube')
