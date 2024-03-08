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

local craft_ingreds = {
  brick = "default:brick",
  obsidian = "default:obsidian",
  tin = "default:tin_ingot",
  skeletal = "moarmour:boneplate",
  ibrog = "moarmour:ibrogblock",
}


 if minetest.get_modpath("nyancats_plus") then
  craft_ingreds.rainbow = "nyancats_plus:rainbow_shard"
 end

 if minetest.get_modpath("nyancat") then
  craft_ingreds.rainbow = "nyancat:nyancat_rainbow"
 end

 if minetest.get_modpath("waffles") then
  craft_ingreds.waffle = "moarmour:waffleblock"

  minetest.register_craft({
    output = 'moarmour:waffleblock',
    recipe = {
      {'waffles:large_waffle', 'waffles:large_waffle', 'waffles:large_waffle'},
      {'waffles:large_waffle', 'waffles:large_waffle', 'waffles:large_waffle'},
      {'waffles:large_waffle', 'waffles:large_waffle', 'waffles:large_waffle'},
    }
  })
  minetest.register_craft({
    output = 'waffles:large_waffle 9',
    recipe = {
      {'moarmour:waffleblock'},
    }
  })
end

if minetest.get_modpath("farming") then
  craft_ingreds.chocolate = "farming:chocolate_dark"
end

if minetest.get_modpath("nanotech") then
  craft_ingreds.carbonfiber = "nanotech:carbon_plate"
end

if minetest.get_modpath("moreores") then
  craft_ingreds.rhodo = "moreores:rhodochrosite_ingot"
  craft_ingreds.silver = "moreores:silver_ingot"
end

if minetest.get_modpath("even_mosword") then
  craft_ingreds.hero = "even_mosword:hero_ingot"
end

if minetest.get_modpath("candycane") then
  craft_ingreds.cane = "candycane:candy_cane"
end

if minetest.get_modpath("christmas_decor") then
  craft_ingreds.cane = "christmas_decor:candycane_edible"
end

if minetest.get_modpath("sky_tools") then
  craft_ingreds.sky = "sky_tools:crystal"
end

if minetest.get_modpath("emeralds") then
  craft_ingreds.emeralds = "emeralds:emerald_crystal_piece"
end

if minetest.get_modpath("gems") then
  craft_ingreds.emerald = "gems:emerald_gem"
  craft_ingreds.pearl = "gems:pearl_gem"
  craft_ingreds.amethyst = "gems:amethyst_gem"
  craft_ingreds.ruby = "gems:ruby:gem"
  craft_ingreds.sapphire = "gems:sapphire_gem"
  craft_ingreds.shadow = "gems:shadow_gem"
end

if minetest.get_modpath("terumet") then
  craft_ingreds.cgls = "terumet:ingot_cgls"
  craft_ingreds.tcop = "terumet:ingot_tcop"
  craft_ingreds.tcha = "terumet:ingot_tcha"
  craft_ingreds.tgol = "terumet:ingot_tgol"
  craft_ingreds.tste = "terumet:ingot_tste"
end


for k, v in pairs(craft_ingreds) do
  minetest.register_alias("armor_addon:helmet_"..k, "moarmour:helmet_"..k)
  minetest.register_craft({
    output = "moarmour:helmet_"..k,
    recipe = {
      {v,   v,  v},
      {v,  "",  v},
      {"", "", ""},
    },
  })
  minetest.register_alias("armor_addon:chestplate_"..k, "moarmour:chestplate_"..k)
  minetest.register_craft({
    output = "moarmour:chestplate_"..k,
    recipe = {
      {v, "", v},
      {v,  v, v},
      {v,  v, v},
    },
  })
  minetest.register_alias("armor_addon:leggings_"..k, "moarmour:leggings_"..k)
  minetest.register_craft({
    output = "moarmour:leggings_"..k,
    recipe = {
      {v,  v, v},
      {v, "", v},
      {v, "", v},
    },
  })
  minetest.register_alias("armor_addon:boots_"..k, "moarmour:boots_"..k)
  minetest.register_craft({
    output = "moarmour:boots_"..k,
    recipe = {
      {v, "", v},
      {v, "", v},
    },
  })
  minetest.register_alias("armor_addon:shield_"..k, "moarmour:shield_"..k)
  minetest.register_craft({
    output = "moarmour:shield_"..k,
    recipe = {
      {v,  v,  v},
      {v,  v,  v},
      {"", v, ""},
    },
  })
end




minetest.register_craft({
  output = 'moarmour:ibrogblock',
  recipe = {
    {'default:obsidian_glass',        'xpanes:bar_flat',  'default:obsidian_glass'},
    {       'xpanes:bar_flat', 'default:obsidian_glass',         'xpanes:bar_flat'},
    {'default:obsidian_glass',        'xpanes:bar_flat',  'default:obsidian_glass'},
  }
})

minetest.register_craftitem ("moarmour:bonepile", {
  description = S("Bone Pile"),
  inventory_image = "moarmour_bone_pile.png"
})
minetest.register_craft ({
  type = "shapeless",
  output = 'moarmour:bonepile',
  recipe = {"bonemeal:bone", "bonemeal:bone", "bonemeal:bone"}
})
minetest.register_craft ({
  output = 'moarmour:bonepile 4',
  recipe = {
    {"bones:bones", "bones:bones"},
    {"bones:bones", "bones:bones"}
  }
})
minetest.register_alias("armor_addon:bone", "moarmour:boneplate")
minetest.register_craftitem ("moarmour:boneplate", {
  description = S("Bone Plate"),
  inventory_image = "moarmour_bone_plate.png"
})
minetest.register_craft ({
  output = 'moarmour:boneplate 9',
  recipe = {
    {   'moarmour:bonepile', 'default:diamondblock',    'moarmour:bonepile'},
    {'default:diamondblock',    'moarmour:bonepile', 'default:diamondblock'},
    {   'moarmour:bonepile', 'default:diamondblock',    'moarmour:bonepile'},
  }
})


if (minetest.get_modpath("nyancat") or minetest.get_modpath("nyancats_plus")) and minetest.get_modpath("tac_nayn") and minetest.get_modpath("waffles") then
  minetest.register_craft({
    output = 'moarmour:boots_tacnayn',
    recipe = {
      {   'moarmour:boots_waffle',  '',    'moarmour:boots_rainbow'},
      {'tac_nayn:tacnayn_rainbow',  '',  'tac_nayn:tacnayn_rainbow'},
    }
  })
  minetest.register_craft({
    output = 'moarmour:chestplate_tacnayn',
    recipe = {
      {  'tac_nayn:tacnayn_rainbow',                         '',       'tac_nayn:tacnayn_rainbow'},
      {'moarmour:chestplate_waffle', 'tac_nayn:tacnayn_rainbow',    'moarmour:chestplate_rainbow'},
      {  'tac_nayn:tacnayn_rainbow', 'tac_nayn:tacnayn_rainbow',       'tac_nayn:tacnayn_rainbow'},
    }
  })
  minetest.register_craft({
    output = 'moarmour:helmet_tacnayn',
    recipe = {
      {  'moarmour:helmet_waffle', 'tac_nayn:tacnayn_rainbow',    'moarmour:helmet_rainbow'},
      {'tac_nayn:tacnayn_rainbow',                         '',   'tac_nayn:tacnayn_rainbow'},
    }
  })
  minetest.register_craft({
    output = 'moarmour:leggings_tacnayn',
    recipe = {
      {'tac_nayn:tacnayn_rainbow',  'tac_nayn:tacnayn_rainbow',   'tac_nayn:tacnayn_rainbow'},
      {  'moarmour:helmet_waffle',                          '',    'moarmour:helmet_rainbow'},
      {'tac_nayn:tacnayn_rainbow',                          '',   'tac_nayn:tacnayn_rainbow'},
    }
  })
  minetest.register_craft({
    output = 'moarmour:shield_tacnayn',
    recipe = {
      {  'moarmour:shield_waffle', 'tac_nayn:tacnayn_rainbow',  'moarmour:shield_rainbow'},
      {'tac_nayn:tacnayn_rainbow',         'tac_nayn:tacnayn', 'tac_nayn:tacnayn_rainbow'},
      {                        '', 'tac_nayn:tacnayn_rainbow',                         ''},
    }
  })
end

