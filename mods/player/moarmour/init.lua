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

local S = minetest.get_translator(minetest.get_current_modname())
local moarmour_path = minetest.get_modpath(minetest.get_current_modname())

moarmour = {
  path = moarmour_path,
  get_translator = S
}

-- Loading the files --
dofile(moarmour_path.."/nodes.lua")
dofile(moarmour_path.."/crafts.lua")
dofile(moarmour_path.."/armour.lua")
-- Optional mod-specific stuff --
if minetest.get_modpath("ediblestuff_api") then
	dofile(moarmour_path.."/make_edible.lua")
end
