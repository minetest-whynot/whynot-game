--------------------------------------------------------------------------------
--
--  Minetest -- moarmour -- Adds many new armours types
--  Copyright (C) 2020-2022  Olivier Dragon
--  Copyright (C) 2017-2018  ChemGuy99 aka Chem871
--  And contributers (see Git logs)
--
--  This program is free software: you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation, either version 3 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program.  If not, see <https://www.gnu.org/licenses/>.
--
--------------------------------------------------------------------------------

local S = moarmour.get_translator

minetest.register_alias("armor_addon:ibrogblock", "moarmour:ibrogblock")
minetest.register_node("moarmour:ibrogblock", {
  description = S("Ibrog"),
  drawtype = "glasslike_framed_optional",
  tiles = {"moarmour_ibrogblock.png"},
  paramtype = "light",
  is_ground_content = false,
  sunlight_propagates = true,
  sounds = default.node_sound_glass_defaults(),
  groups = {cracky = 3},
})

if minetest.get_modpath("waffles") then
  minetest.register_alias("armor_addon:waffleblock", "moarmour:waffleblock")
  minetest.register_node("moarmour:waffleblock", {
    description = S("Waffle Block"),
    tiles = {"moarmour_waffleblock.png"},
    is_ground_content = true,
    groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
    drop = 'moarmour:waffleblock',
    sounds = default.node_sound_wood_defaults(),
  })
end