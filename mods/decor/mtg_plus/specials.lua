local S = minetest.get_translator("mtg_plus")
local deco
if minetest.get_modpath("doc_items") then
	deco = doc.sub.items.temp.deco
end

-- Special: Variant of dirt without the grass/plant spread
minetest.register_node("mtg_plus:graveldirt", {
	description = S("Gravel Dirt"),
	_doc_items_longdesc = S("Gravel dirt is a type of dirt consisting of equal parts of gravel and dirt. It combines some of the properties of gravel and dirt."),
	tiles = {"mtg_plus_graveldirt.png"},
	is_ground_content = true,
	groups = { crumbly = 2, level = 1, soil = 1, },
	sounds = default.node_sound_dirt_defaults(),
	drop = {
		items = {
			{ items = { "default:gravel" } },
			{ items = { "default:dirt" } },
		}
	},
})

minetest.register_craft({
	type = "shapeless",
	output = "mtg_plus:graveldirt",
	recipe = { "default:gravel", "default:dirt" },
})

-- Special: Extremely hard block
minetest.register_node("mtg_plus:harddiamondblock",{
	description = S("Aggregated Diamond Block"),
	_doc_items_longdesc = S("This block is even harder than diamond; diamond pickaxes can't break it. TNT is able to destroy this block."),
	tiles = { "mtg_plus_hard_diamond_block.png" },
	is_ground_content = false,
	groups = { cracky = 1, level = 4 },
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "mtg_plus:harddiamondblock 1",
	type = "shapeless",
	recipe = { "default:diamondblock", "default:diamondblock" }
})

-- Special: Wood that doesn't burn
minetest.register_node("mtg_plus:goldwood", {
	description = S("Goldwood"),
	_doc_items_longdesc = S("Goldwood is a precious artificial kind of wood made by enriching wood with gold. Goldwood is fireproof and notable for its bright yellowy appearance."),
	tiles = {"mtg_plus_goldwood.png"},
	is_ground_content = false,
	groups = {choppy = 2, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_craft({
	output = "mtg_plus:goldwood",
	type = "shapeless",
	recipe = { "group:wood", "default:gold_ingot" },
})

-- Prevent goldwood from being used as furnace fuel
minetest.clear_craft({
	type = "fuel",
	recipe = "mtg_plus:goldwood",
})
