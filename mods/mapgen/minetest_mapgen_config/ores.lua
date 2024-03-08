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
-- This file contains modifications to the ores for the map/world generation
--

local ores_registered = {}


local function change_ore_layer(ore_config_name, layer, def)
    local config_str_base = "mapgen_conf."..ore_config_name.."_ground_layer"..layer.."_"
    def.clust_scarcity = tonumber(Mapgen_conf.get_setting(config_str_base.."scarcity", def.clust_scarcity))
    def.clust_num_ores = tonumber(Mapgen_conf.get_setting(config_str_base.."num_ores", def.clust_num_ores))
    def.clust_size     = tonumber(Mapgen_conf.get_setting(config_str_base.."clust_size", def.clust_size))
    def.y_max          = tonumber(Mapgen_conf.get_setting(config_str_base.."ymax", def.y_max))
    def.y_min          = tonumber(Mapgen_conf.get_setting(config_str_base.."ymin", def.y_min))
end


local function change_ore_def(base_material, ore_config_name, def)
    if (def.ore == base_material) then
        if ((0 > def.y_min and def.y_min > -31000) or ores_registered[ore_config_name] == nil) then
            change_ore_layer(ore_config_name, 1, def)
        elseif (def.y_min <= -31000) then
            change_ore_layer(ore_config_name, 2, def)
        end
        ores_registered[ore_config_name] = 1
    end
end


local reg_ores = table.copy(minetest.registered_ores)
minetest.clear_registered_ores()

for _, def in pairs(reg_ores) do
    if (def and def.ore) then

        change_ore_def("default:stone_with_tin", "tin", def)
        change_ore_def("default:stone_with_copper", "copper", def)
        change_ore_def("default:stone_with_gold", "gold", def)
        change_ore_def("default:stone_with_iron", "iron", def)
        change_ore_def("default:stone_with_mese", "mese", def)
        change_ore_def("default:mese", "mese_block", def)
        change_ore_def("default:stone_with_diamond", "diamond", def)

        if (def.ore ~= "default:mese" or not minetest.get_modpath("yellow_crystal")) then
            minetest.register_ore(def)
        end

    end
end

