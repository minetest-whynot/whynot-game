-- Boilerplate to support localized strings if intllib mod is installed.
local S
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
else
	S = function(s) return s end
end
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
-- FIXME: Goldwood can be used as furnace fuel because of group:wood recipe

minetest.register_craft({
	output = "mtg_plus:goldwood",
	type = "shapeless",
	recipe = { "group:wood", "default:gold_ingot" },
})

-- Special: Being an absurd luxury. :D
minetest.register_node("mtg_plus:goldapple", {
	description = S("Golden Decor Apple"),
	_doc_items_longdesc = S("A decorative golden object which is shaped like an apple. It is inedible."),
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"mtg_plus_goldapple.png"},
	inventory_image = "mtg_plus_goldapple.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.2, -0.5, -0.2, 0.2, 0, 0.2}
	},
	groups = { dig_immediate = 3, attached_node = 1 },
	sounds = default.node_sound_defaults(),
})


minetest.register_craft({
	output = "mtg_plus:goldapple",
	type = "shapeless",
	recipe = { "default:apple", "default:gold_ingot" },
})
