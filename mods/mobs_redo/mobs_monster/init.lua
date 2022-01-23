
-- Load support for intllib.
local path = minetest.get_modpath(minetest.get_current_modname()) .. "/"

local S

-- Check for translation method
local S
if minetest.get_translator ~= nil then
	S = minetest.get_translator("mobs_monster") -- 5.x translation function
else
	if minetest.get_modpath("intllib") then
		dofile(minetest.get_modpath("intllib") .. "/init.lua")
		if intllib.make_gettext_pair then
			gettext, ngettext = intllib.make_gettext_pair() -- new gettext method
		else
			gettext = intllib.Getter() -- old text file method
		end
		S = gettext
	else -- boilerplate function
		S = function(str, ...)
			local args = {...}
			return str:gsub("@%d+", function(match)
				return args[tonumber(match:sub(2))]
			end)
		end
	end
end

mobs.intllib_monster = S


-- Check for custom mob spawn file
local input = io.open(path .. "spawn.lua", "r")

if input then
	mobs.custom_spawn_monster = true
	input:close()
	input = nil
end


-- Monsters
dofile(path .. "dirt_monster.lua") -- PilzAdam
dofile(path .. "dungeon_master.lua")
dofile(path .. "oerkki.lua")
dofile(path .. "sand_monster.lua")
dofile(path .. "stone_monster.lua")
dofile(path .. "tree_monster.lua")
dofile(path .. "lava_flan.lua") -- Zeg9
dofile(path .. "mese_monster.lua")
dofile(path .. "spider.lua") -- AspireMint
dofile(path .. "land_guard.lua")
dofile(path .. "fire_spirit.lua")


-- Load custom spawning
if mobs.custom_spawn_monster then
	dofile(path .. "spawn.lua")
end


-- Lucky Blocks
dofile(path .. "lucky_block.lua")


print ("[MOD] Mobs Redo Monsters loaded")
