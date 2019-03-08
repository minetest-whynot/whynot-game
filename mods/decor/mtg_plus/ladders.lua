local S = minetest.get_translator("mtg_plus")

local metal_sounds
if default.node_sound_metal_defaults then
	metal_sounds = default.node_sound_metal_defaults()
else
	metal_sounds = default.node_sound_stone_defaults()
end

-- Ladders
minetest.register_node("mtg_plus:ladder_papyrus", {
	description = S("Papyrus Ladder"),
	_doc_items_longdesc = S("A particulary strong piece of ladder which allows you to move vertically."),
	drawtype = "signlike",
	tiles = {"mtg_plus_ladder_papyrus.png"},
	inventory_image = "mtg_plus_ladder_papyrus.png",
	wield_image = "mtg_plus_ladder_papyrus.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	climbable = true,
	is_ground_content = false,
	selection_box = { type = "wallmounted", },
	groups = { snappy = 2, choppy = 1, flammable = 2 },
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_craft({
	output = "mtg_plus:ladder_papyrus 2",
	recipe = { {"default:papyrus", "", "default:papyrus"},
	{"farming:string", "default:papyrus", "farming:string"},
	{"default:papyrus", "", "default:papyrus"}},
})

minetest.register_craft({
	type = "fuel",
	recipe = "mtg_plus:ladder_papyrus",
	burntime = 2,
})

minetest.register_node("mtg_plus:ladder_gold", {
	description = S("Golden Ladder"),
	_doc_items_longdesc = S("A luxurious piece of ladder which allows you to move vertically."),
	drawtype = "signlike",
	tiles = {"mtg_plus_ladder_gold.png"},
	inventory_image = "mtg_plus_ladder_gold.png",
	wield_image = "mtg_plus_ladder_gold.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	climbable = true,
	is_ground_content = false,
	selection_box = { type = "wallmounted", },
	groups = { cracky = 3, },
	sounds = metal_sounds,
})

minetest.register_craft({
	output = "mtg_plus:ladder_gold 15",
	recipe = { {"default:gold_ingot", "", "default:gold_ingot"},
	{"default:gold_ingot", "default:gold_ingot", "default:gold_ingot"},
	{"default:gold_ingot", "", "default:gold_ingot"}},
})
