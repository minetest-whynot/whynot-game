-- SPDX-License-Identifier: MIT
-- SPDX-FileCopyrightText: 2016-2019
-- SPDX-FileContributor: Jean-Patrick Guerrero and contributors
-- SPDX-FileCopyrightText: 2020-2022
-- SPDX-FileContributor: pauloue
-- SPDX-FileCopyrightText: 2022-2026
-- SPDX-FileContributor: dacmot

local S = minetest.get_translator(minetest.get_current_modname())
local modpath = minetest.get_modpath(minetest.get_current_modname())

sfcg = {
	modpath = modpath,
	get_translator = S,
	player_data = {},
	init_items = {},
	recipes_cache = {},
	usages_cache = {},
}

function sfcg.get_usages(data, item)
	return sfcg.usages_cache[item]
end

function sfcg.get_recipes(data, item)
	return sfcg.recipes_cache[item]
end

-- Loading components

dofile(modpath.."/craftguide.lua")

if (minetest.get_modpath("doc") and minetest.get_modpath("doc_items")) then
	dofile(modpath.."/reveal.lua")
end

if (minetest.get_modpath("sfinv") and minetest.global_exists("sfinv")) and sfinv.enabled then
	dofile(modpath.."/sfinv.lua")
end

