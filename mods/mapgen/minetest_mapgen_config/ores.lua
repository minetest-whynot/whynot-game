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
-- This file contains modifications to the ores for the whynot map/world generation
--

local function change_ore_def(ore, def)
    if (def.ore == "default:stone_with_"..ore) then
        if (0 > def.y_min and def.y_min > -31000) then
            local prev_ymax = def.y_max
            def.clust_scarcity = tonumber(Mapgen_conf.get_setting("mapgen_conf."..ore.."_ground_layer1_scarcity", def.clust_scarcity))
            def.y_max = tonumber(Mapgen_conf.get_setting("mapgen_conf."..ore.."_ground_layer1_ymax", def.y_max))
            def.y_min = tonumber(Mapgen_conf.get_setting("mapgen_conf."..ore.."_ground_layer1_ymin", def.y_min))
        end
        if (def.y_min <= -31000) then
            local prev_ymax = def.y_max
            def.clust_scarcity = tonumber(Mapgen_conf.get_setting("mapgen_conf."..ore.."_ground_layer2_scarcity", def.clust_scarcity))
            def.y_max = tonumber(Mapgen_conf.get_setting("mapgen_conf."..ore.."_ground_layer2_ymax", def.y_max))
            def.y_min = tonumber(Mapgen_conf.get_setting("mapgen_conf."..ore.."_ground_layer2_ymin", def.y_min))
        end
    end
end


local rores = table.copy(minetest.registered_ores)
minetest.clear_registered_ores()

for _, def in pairs(rores) do
    if (def and def.ore) then

        change_ore_def("tin", def)
        change_ore_def("copper", def)
        change_ore_def("iron", def)
        change_ore_def("mese", def)
        change_ore_def("diamond", def)

        minetest.register_ore(def)

    end
end

