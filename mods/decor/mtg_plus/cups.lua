local S = minetest.get_translator("mtg_plus")

-- Cups
local cupnodebox = {
	type = "fixed",
	fixed = {
	{-0.3,-0.5,-0.3,0.3,-0.4,0.3}, -- stand
	{-0.1,-0.4,-0.1,0.1,0,0.1}, -- handle
	{-0.3,0,-0.3,0.3,0.1,0.3}, -- cup (lower part)
	-- the 4 sides of the upper part
	{-0.2,0.1,-0.3,0.2,0.5,-0.2},
	{-0.2,0.1,0.2,0.2,0.5,0.3},
	{-0.3,0.1,-0.3,-0.2,0.5,0.3},
	{0.2,0.1,-0.3,0.3,0.5,0.3},
	}
}

local cupselbox = {
	type = "fixed",
	fixed = {
	{-0.3,-0.5,-0.3,0.3,-0.4,0.3}, -- stand
	{-0.1,-0.4,-0.1,0.1,0,0.1}, -- handle
	{-0.3,0,-0.3,0.3,0.5,0.3}, -- upper part
	}
}

mtg_plus.register_cup = function(subname, description, tiles, craftitem, craft_count, extra_groups, extra_sounds)
	local groups = { dig_immediate=3, falling_node=1, }
	if extra_groups then
		for k,v in pairs(extra_groups) do
			groups[k] = v
		end
	end
	local sounds
	if default.node_sound_metal_defaults then
		sounds = default.node_sound_defaults({
			footstep = { name = "default_metal_footstep", gain = 0.3 },
		})
	else
		sounds = default.node_sound_defaults({
			footstep = { name = "default_hard_footstep", gain = 0.3 },
		})
	end
	if extra_sounds then
		for k,v in pairs(extra_sounds) do
			sounds[k] = v
		end
	end
	local itemstring = "mtg_plus:cup_"..subname
	minetest.register_node(itemstring, {
		description = description,
		_doc_items_longdesc = S("A decorational item which can be placed."),
		tiles = tiles,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = cupnodebox,
		is_ground_content = false,
		selection_box = cupselbox,
		groups = groups,
		sounds = sounds,
	})

	if craftitem ~= nil then
		if craft_count == nil then craft_count = 1 end

		minetest.register_craft({
			output = "mtg_plus:cup_"..subname.." "..craft_count,
			recipe = {
				{craftitem, "", craftitem},
				{"", craftitem, ""},
				{"", craftitem, ""},
			}
		})
	end
end

mtg_plus.register_cup("bronze", S("Bronze Cup"), { "mtg_plus_cup_bronze.png" }, "default:bronze_ingot", 2)
mtg_plus.register_cup("gold", S("Golden Cup"), { "mtg_plus_cup_gold.png" }, "default:gold_ingot", 2)
mtg_plus.register_cup("diamond", S("Diamond Cup"), { "mtg_plus_cup_diamond.png" }, "default:diamond", 1, nil,
	default.node_sound_defaults({ footstep = { name = "default_hard_footstep", gain = 0.3 }}))
