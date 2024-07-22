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

--
-- This file contains modifications to the biomes for the map/world generation
--

local function copy_biome(def, variant_suffix)
    local old_name = def and def.name or "zzzunknown"
    local def = table.copy(def or minetest.registered_biomes[old_name])
    def.name = old_name.."_"..variant_suffix

    return def
end


local mountaintops_altitude = tonumber(Mapgen_conf.get_setting("mapgen_conf.mountaintops_altitude", 80))
local hills_to_mountain_vertical_blend = tonumber(Mapgen_conf.get_setting("mapgen_conf.hills_to_mountain_vertical_blend", 30))
local top_layer_thickness = tonumber(Mapgen_conf.get_setting("mapgen_conf.top_layer_thickness", 1))
local filler_layer_thickness = tonumber(Mapgen_conf.get_setting("mapgen_conf.filler_layer_thickness", 20))
local ocean_floor_thickness = tonumber(Mapgen_conf.get_setting("mapgen_conf.ocean_floor_thickness", 5))
local riverbed_thickness = tonumber(Mapgen_conf.get_setting("mapgen_conf.riverbed_thickness", 5))
local lower_atmosphere_biome_ymax = tonumber(Mapgen_conf.get_setting("mapgen_conf.lower_atmosphere_biome_ymax", 1000))
local floatlands_biomes_ymax = tonumber(Mapgen_conf.get_setting("mapgen_conf.floatlands_biomes_ymax", 5000))
local floatlands_biomes_exclusions = Mapgen_conf.get_setting("mapgen_conf.floatlands_biomes_exclusions", "tundra icesheet cold_desert grassland_dunes snowy_grassland")

minetest.log("info", "Mapgen config: modifying biomes...")

local rbiomes = table.copy(minetest.registered_biomes)
minetest.clear_registered_biomes()

for name, def in pairs(rbiomes) do

    -- Last layer before mountain tops
    if (def.y_max >= lower_atmosphere_biome_ymax) then

        if (name ~= "tundra_highland") then

            -- Ensure it has some vertical blend so it doesn't look like a bowl haircut
            def.vertical_blend = hills_to_mountain_vertical_blend
            def.y_max = mountaintops_altitude - 1

            -- Change the depth of materials before hitting the rock layer
            if (def.depth_top) then
                def.depth_top = math.max(def.depth_top, top_layer_thickness / 2)
            end
            if (def.depth_filler) then
                def.depth_filler = math.max(def.depth_filler, filler_layer_thickness / 2)
            end
            if (def.depth_riverbed) then
                def.depth_riverbed = math.max(def.depth_riverbed, riverbed_thickness / 2)
            end

        else
            -- Create mountain tops by re-purposing tundra_highland
            def.node_top = "default:ice"
            def.depth_top = 1
            def.node_filler = "default:snowblock"
            def.depth_filler = 3
            def.y_max = lower_atmosphere_biome_ymax - 1
            def.y_min = mountaintops_altitude
        end

    -- Ocean, surface and hills
    elseif (def.y_max < lower_atmosphere_biome_ymax) then

        -- Change the depth of materials before hitting the rock layer
        if (def.depth_top) then
            def.depth_top = top_layer_thickness
        end
        if (def.depth_filler) then
            def.depth_filler = filler_layer_thickness
        end
        if (def.depth_water_top or string.find(name, "ocean")) then
            def.depth_water_top = ocean_floor_thickness
        end
        if (def.depth_riverbed) then
            def.depth_riverbed = riverbed_thickness
        end

        -- Because of the highlands, tundra has an extra intermediate layer.
        -- Make sure its vertical settings match.
        if (name == "tundra") then
            def.vertical_blend = hills_to_mountain_vertical_blend
            def.y_max = mountaintops_altitude - 1
        end

    end

    -- Vary dungeons materials based on biome, or improve existing dungeon materials
    -- Better with mtg_plus

    if (string.find(name, "standstone_desert")) then

        if (minetest.get_modpath("mtg_plus")) then
            minetest.log("verbose", "mapgen_conf dungeon: "..name.." mtg_plus")
            def.node_dungeon = "default:sandstonebrick"
            def.node_dungeon_alt = "mtg_plus:sandstone_cobble"
            def.node_dungeon_stair = "stairs:stair_sandstone_cobble"
        else
            minetest.log("verbose", "mapgen_conf dungeon: "..name)
            def.node_dungeon = "default:sandstonebrick"
            def.node_dungeon_alt = "default:sand"
            def.node_dungeon_stair = "stairs:stair_sandstone"
        end

    elseif (string.find(name, "cold_desert")) then

        if (minetest.get_modpath("mtg_plus")) then
            minetest.log("verbose", "mapgen_conf dungeon: "..name.." mtg_plus")
            def.node_dungeon = "mtg_plus:silver_sandstone_brick_gold"
            def.node_dungeon_alt = "mtg_plus:silver_sandstone_cobble"
            def.node_dungeon_stair = "stairs:stair_silver_standstone_cobble"
        else
            minetest.log("verbose", "mapgen_conf dungeon: "..name)
            def.node_dungeon = "default:silver_sandstone_brick"
            def.node_dungeon_alt = "default:silver_sand"
            def.node_dungeon_stair = "stairs:stair_silver_standstone"
        end

    elseif (string.find(name, "desert")) then
        -- Order is important for this one. It needs to come after the other types of deserts
        if (minetest.get_modpath("mtg_plus")) then
            minetest.log("verbose", "mapgen_conf dungeon: "..name.." mtg_plus")
            def.node_dungeon = "mtg_plus:desert_stonebrick_gold"
            def.node_dungeon_alt = "default:desert_cobble"
            def.node_dungeon_stair = "stairs:stair_desert_cobble"
        else
            minetest.log("verbose", "mapgen_conf dungeon: "..name)
            def.node_dungeon = "default:desert_stonebrick"
            def.node_dungeon_alt = "default:desert_cobble"
            def.node_dungeon_stair = "stairs:stair_desert_cobble"
        end

    elseif (string.find(name, "savanna")) then

        minetest.log("verbose", "mapgen_conf dungeon: "..name)
        def.node_dungeon = "default:desert_sandstone_brick"
        def.node_dungeon_alt = "default:desert_sandstone"
        def.node_dungeon_stair = "stairs:stair_desert_standstone"

    elseif (string.find(name, "rainforest")) then

        if (minetest.get_modpath("mtg_plus")) then
            minetest.log("verbose", "mapgen_conf dungeon: "..name.." mtg_plus")
            def.node_dungeon = "mtg_plus:jungle_cobble"
            def.node_dungeon_stair = "stairs:stair_jungle_cobble"
            def.node_dungeon_alt = "default:mossycobble"
        end

    elseif (string.find(name, "tundra")) then

        minetest.log("verbose", "mapgen_conf dungeon: "..name)
        def.node_dungeon = "default:obsidianbrick"
        def.node_dungeon_alt = "default:obsidian"
        def.node_dungeon_stair = "stairs:stair_obsidianbrick"

    elseif (string.find(name, "icesheet")) then

        if (minetest.get_modpath("mtg_plus")) then
            minetest.log("verbose", "mapgen_conf dungeon: "..name.." mtg_plus")
            def.node_dungeon = "mtg_plus:hard_snow_brick"
            def.node_dungeon_alt = "mtg_plus:ice_snow_brick"
            def.node_dungeon_stair = "stairs:stair_snowblock"
        end

    end

    minetest.register_biome(def)


    -- Don't duplicate the biomes depth variants
    if (not (string.find(name, "_ocean") or string.find(name, "_beach") or string.find(name, "_under") or string.find(name, "_highland"))) then
        -- Remove boring biomes in floatlands
        local stripped_name = name
        local stripped_name = stripped_name:gsub("_ocean", "")
        local stripped_name = stripped_name:gsub("_beach", "")
        local stripped_name = stripped_name:gsub("_under", "")
        local stripped_name = stripped_name:gsub("_highland", "")
        if (not string.find(floatlands_biomes_exclusions, stripped_name)) then
            local floatlands_biome = copy_biome(def, "floatlands")
            floatlands_biome.y_max = floatlands_biomes_ymax - 1
            floatlands_biome.y_min = lower_atmosphere_biome_ymax

            minetest.register_biome(floatlands_biome)
        end
    end

end
