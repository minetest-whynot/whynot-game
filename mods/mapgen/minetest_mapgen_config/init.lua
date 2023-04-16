--------------------------------------------------------------------------------
--
-- Minetest -- Map generation customisation configuration parameters for Minetest Game
-- Copyright 2023 Olivier Dragon

-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at

--     http://www.apache.org/licenses/LICENSE-2.0

-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
--------------------------------------------------------------------------------

Mapgen_conf = {}

-- Add logs when accessing settings. Useful for debugging.
function Mapgen_conf.get_setting(name, default)
    local value = minetest.settings:get(name)
    if (not value) then
        minetest.log("info", "Mapgen Config: Setting '"..name.."' could not be found")
        value = default
    end
    value = value or ""
    minetest.log("verbose", "Mapgen Config: Setting '"..name.."' = "..value)
    return value
end


local modpath = minetest.get_modpath(minetest.get_current_modname())
Mapgen_conf.modpath = modpath

dofile(modpath.."/biomes.lua")
--
-- Ores and decorations must be modified after biomes. From lua_api.txt
--     * Warning: Clearing and re-registering biomes alters the biome to biome ID
--       correspondences, so any decorations or ores using the 'biomes' field must
--       afterwards be cleared and re-registered.
--
dofile(modpath.."/ores.lua")
dofile(modpath.."/decorations.lua")

local function rnd10(num)
    return math.round(num * 10) / 10
end

if (Mapgen_conf.get_setting("mapgen_conf.debug_biomes", false)) then
    Mapgen_conf.globalstep = 0
    minetest.register_globalstep(function(dtime)
        Mapgen_conf.globalstep = Mapgen_conf.globalstep + dtime
        if (Mapgen_conf.globalstep >= 5) then
            local player = minetest.get_player_by_name("singleplayer")
            if (player) then
                local pos = player:get_pos()
                local biome_data = minetest.get_biome_data(pos)
                minetest.log("verbose", math.floor(pos.x)..","..math.floor(pos.y)..","..math.floor(pos.z).." in "..minetest.get_biome_name(biome_data.biome)..", heat "..rnd10(biome_data.heat)..", humidity "..rnd10(biome_data.humidity))
            end
            Mapgen_conf.globalstep = 0
        end
    end)
end