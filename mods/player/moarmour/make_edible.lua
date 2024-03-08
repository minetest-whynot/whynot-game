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

if minetest.get_modpath("waffles") then
	-- A waffle block is 9 waffles, 8 stamina each. This is huge.
	-- Let's just do 20 for all waffle armor peices.
	ediblestuff.make_armor_edible_while_wearing("moarmour","waffle",20,true)
end
if minetest.get_modpath("farming") and farming.mod == "redo" then
	ediblestuff.make_armor_edible_while_wearing("moarmour","chocolate",2.5)
end
if minetest.get_modpath("candycane") then
	ediblestuff.make_armor_edible_while_wearing("moarmour","cane",3.5)
end
