local S = moarmour.get_translator

local craft_ingreds = {
  rainbow = "nyancats_plus:rainbow_shard",
        waffle = "moarmour:waffleblock",
        obsidian = "default:obsidian",
        chocolate = "farming:chocolate_dark",
        carbonfiber = "nanotech:carbon_plate",
        rhodo = "moreores:rhodochrosite_ingot",
        tin = "default:tin_ingot",
        ibrog = "moarmour:ibrogblock",
        hero = "even_mosword:hero_ingot",
        cane = "candycane:candy_cane",
        cane = "christmas_decor:candycane_edible",
        skeletal = "moarmour:boneplate",
        brick = "default:brick",
        silver = "moreores:silver_ingot",
        sky = "sky_tools:crystal",
        emeralds = "emeralds:emerald_crystal_piece",
        emerald = "gems:emerald_gem",
        pearl = "gems:pearl_gem",
        amethyst = "gems:amethyst_gem",
        ruby = "gems:ruby:gem",
        sapphire = "gems:sapphire_gem",
        shadow = "gems:shadow_gem",
        cgls = "terumet:ingot_cgls",
        tcop = "terumet:ingot_tcop",
        tcha = "terumet:ingot_tcha",
        tgol = "terumet:ingot_tgol",
        tste = "terumet:ingot_tste",
}

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
