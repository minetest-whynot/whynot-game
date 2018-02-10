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

food.support("orange", "ethereal:orange")
food.support("strawberry", "ethereal:strawberry")
food.support("banana", "ethereal:banana")

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

-- Remove redundant sugar
-- mtfoods:sugar is already food_sugar
minetest.unregister_item("farming:sugar")
minetest.register_alias("farming:sugar", "mtfoods:sugar")
