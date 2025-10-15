assert(core.is_creative_enabled, "API requirement is not met. Please update Luanti/Minetest.")

local S = minetest.get_translator(minetest.get_current_modname())

minetest.register_alias("castle:orb_day", "orbs_of_time:orb_day")
minetest.register_alias("castle:orb_night", "orbs_of_time:orb_night")

local function generic_on_use(itemstack, user, sound2)
	core.sound_play("orbs_ding", {pos=user:get_pos(), loop=false})
	core.set_timeofday(0.5)
	core.sound_play(sound2, {pos=user:get_pos(), loop=false})
	if not core.is_creative_enabled(user:get_player_name()) then
		itemstack:add_wear(65535/8)
	end
	return itemstack
end

minetest.register_tool("orbs_of_time:orb_day", {
	description = S("Orb of Midday"),
	_doc_items_longdesc = S("This magical orb grants you the power to " ..
		"bring the Sun to the zenith of the sky."),
	_doc_items_usagehelp = S("When weilded, use this item and the Sun will jump to its highest point. "..
		"The day will then progress normally from " ..
		"there. This orb can be used eight times - once for each diamond that " ..
		"was used to craft it."),
	tiles = {"orbs_orb_day.png"},
	inventory_image = "orbs_orb_day.png",
	wield_image = "orbs_orb_day_weild.png",
	stack_max=1,
	groups = { tool=1 },
	on_use = function(itemstack, user)
		return generic_on_use(itemstack, user, "orbs_birds")
	end,
})

minetest.register_tool("orbs_of_time:orb_night",{
	description = S("Orb of Midnight"),
	_doc_items_longdesc = S("This magical orb grants you the power to " ..
		"banish the Sun to the bottom of the world."),
	_doc_items_usagehelp = S("When weilded, use this item and the Moon will jump to its highest point. " ..
		"The night will then progress normally from there. This orb can be used " ..
		"eight times - once for each diamond that was used to craft it."),
	tiles = {"orbs_orb_night.png"},
	inventory_image = "orbs_orb_night.png",
	wield_image = "orbs_orb_night_weild.png",
	stack_max=1,
	groups = { tool=1 },
	on_use = function(itemstack, user)
		return generic_on_use(itemstack, user, "orbs_owl")
	end,
})


minetest.register_tool("orbs_of_time:orb_dawn", {
	description = S("Orb of Dawn"),
	_doc_items_longdesc = S("This magical orb grants you the power to " ..
		"bring the Sun to eastern horizon."),
	_doc_items_usagehelp = S("When weilded, use this item and day will break. " ..
		"The day will then progress normally from there. This orb can be used " ..
		"eight times - once for each diamond that was used to craft it."),
	tiles = {"orbs_orb_day.png"},
	inventory_image = "orbs_orb_day.png^[lowpart:50:orbs_orb_night.png",
	wield_image = "orbs_orb_day_weild.png^[lowpart:75:orbs_orb_night_weild.png",
	stack_max=1,
	on_use = function(itemstack, user)
		return generic_on_use(itemstack, user, "orbs_birds")
	end,
})

minetest.register_tool("orbs_of_time:orb_dusk",{
	description = S("Orb of Dusk"),
	_doc_items_longdesc = S("This magical orb grants you the power to send the Sun to western horizon."),
	_doc_items_usagehelp = S("When weilded, use this item and night will fall. " ..
		"The night will then progress normally from there. This orb can be used " ..
		"eight times - once for each diamond that was used to craft it."),
	tiles = {"orbs_orb_night.png"},
	inventory_image = "orbs_orb_night.png^[lowpart:50:orbs_orb_day.png",
	wield_image = "orbs_orb_night_weild.png^[lowpart:75:orbs_orb_day_weild.png",
	stack_max=1,
	on_use = function(itemstack, user)
		return generic_on_use(itemstack, user, "orbs_owl")
	end,
})

-----------
--Crafting
-----------

local mat_diamond, mat_light_item, mat_dark_item
if minetest.get_modpath("mcl_core") then
	mat_diamond    = "mcl_core:diamond"
	mat_light_item = "mesecons:redstone"
	mat_dark_item  = "mcl_dye:black"
else
	-- Assume Minetest Game
	mat_diamond    = "default:diamond"
	mat_light_item = "default:mese_crystal_fragment"
	mat_dark_item  = "default:obsidian_shard"
end

minetest.register_craft({
	output = "orbs_of_time:orb_day",
	recipe = {
		{mat_diamond, mat_diamond,    mat_diamond},
		{mat_diamond, mat_light_item, mat_diamond},
		{mat_diamond, mat_diamond,    mat_diamond}
	},
})

minetest.register_craft({
	output = "orbs_of_time:orb_night",
	recipe = {
		{mat_diamond, mat_diamond,   mat_diamond},
		{mat_diamond, mat_dark_item, mat_diamond},
		{mat_diamond, mat_diamond,   mat_diamond}
	},
})

minetest.register_craft({
	output = "orbs_of_time:orb_dawn 2",
	recipe = {
		{"orbs_of_time:orb_day"},
		{"orbs_of_time:orb_night"},
	},
})

minetest.register_craft({
	output = "orbs_of_time:orb_dusk 2",
	recipe = {
		{"orbs_of_time:orb_night"},
		{"orbs_of_time:orb_day"},
	},
})

-----------
--Loot mod support
-----------

if minetest.get_modpath("loot") then
	loot.register_loot({
		weights = { generic = 10, valuable= 10 },
		payload = {
			stack = ItemStack("orbs_of_time:orb_day"),
			min_size = 1,
			max_size = 1,
		},
	})

	loot.register_loot({
		weights = { generic = 10, valuable= 10 },
		payload = {
			stack = ItemStack("orbs_of_time:orb_night"),
			min_size = 1,
			max_size = 1,
		},
	})

	loot.register_loot({
		weights = { generic = 10, valuable= 10 },
		payload = {
			stack = ItemStack("orbs_of_time:orb_dawn"),
			min_size = 1,
			max_size = 1,
		},
	})

	loot.register_loot({
		weights = { generic = 10, valuable= 10 },
		payload = {
			stack = ItemStack("orbs_of_time:orb_dusk"),
			min_size = 1,
			max_size = 1,
		},
	})

end
