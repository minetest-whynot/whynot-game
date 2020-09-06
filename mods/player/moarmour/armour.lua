local S = moarmour.get_translator

-- Armours --
  minetest.register_tool("moarmour:helmet_obsidian", {
    description = S("Obsidian Helmet"),
    inventory_image = "moarmour_inv_helmet_obsidian.png",
    groups = {armor_head=22.5, armor_heal=18, armor_use=300},
    wear = 0,
  })
  minetest.register_tool("moarmour:chestplate_obsidian", {
    description = S("Obsidian Chestplate"),
    inventory_image = "moarmour_inv_chestplate_obsidian.png",
    groups = {armor_torso=30, armor_heal=18, armor_use=300},
    wear = 0,
  })
  minetest.register_tool("moarmour:leggings_obsidian", {
    description = S("Obsidian Leggings"),
    inventory_image = "moarmour_inv_leggings_obsidian.png",
    groups = {armor_legs=30, armor_heal=18, armor_use=300},
    wear = 0,
  })
  minetest.register_tool("moarmour:boots_obsidian", {
    description = S("Obsidian Boots"),
    inventory_image = "moarmour_inv_boots_obsidian.png",
    groups = {armor_feet=22.5, armor_heal=18, armor_use=300},
    wear = 0,
  })
  minetest.register_tool("moarmour:shield_obsidian", {
    description = S("Obsidian Shield"),
    inventory_image = "moarmour_inv_shield_obsidian.png",
    groups = {armor_shield=22.5, armor_heal=18, armor_use=300},
    wear = 0,
  })

  minetest.register_tool("moarmour:helmet_tin", {
    description = S("Tin Helmet"),
    inventory_image = "moarmour_inv_helmet_tin.png",
    groups = {armor_head=6, armor_heal=0, armor_use=800},
    wear = 0,
  })
  minetest.register_tool("moarmour:chestplate_tin", {
    description = S("Tin Chestplate"),
    inventory_image = "moarmour_inv_chestplate_tin.png",
    groups = {armor_torso=12, armor_heal=0, armor_use=800},
    wear = 0,
  })
  minetest.register_tool("moarmour:leggings_tin", {
    description = S("Tin Leggings"),
    inventory_image = "moarmour_inv_leggings_tin.png",
    groups = {armor_legs=12, armor_heal=0, armor_use=800},
    wear = 0,
  })
  minetest.register_tool("moarmour:boots_tin", {
    description = S("Tin Boots"),
    inventory_image = "moarmour_inv_boots_tin.png",
    groups = {armor_feet=6, armor_heal=0, armor_use=800},
    wear = 0,
  })
  minetest.register_tool("moarmour:shield_tin", {
    description = S("Tin Shield"),
    inventory_image = "moarmour_inv_shield_tin.png",
    groups = {armor_shield=6, armor_heal=0, armor_use=800},
    wear = 0,
  })

  minetest.register_tool("moarmour:helmet_brick", {
    description = S("Brick Helmet"),
    inventory_image = "moarmour_inv_helmet_brick.png",
    groups = {armor_head=12, armor_heal=4, armor_use=1100, physics_speed=-0.10, physics_jump=-0.05},
    wear = 0,
  })
  minetest.register_tool("moarmour:chestplate_brick", {
    description = S("Brick Chestplate"),
    inventory_image = "moarmour_inv_chestplate_brick.png",
    groups = {armor_torso=15, armor_heal=4, armor_use=1100, physics_speed=-0.10, physics_jump=-0.05},
    wear = 0,
  })
  minetest.register_tool("moarmour:leggings_brick", {
    description = S("Brick Leggings"),
    inventory_image = "moarmour_inv_leggings_brick.png",
    groups = {armor_legs=15, armor_heal=4, armor_use=1100, physics_speed=-0.10, physics_jump=-0.05},
    wear = 0,
  })
  minetest.register_tool("moarmour:boots_brick", {
    description = S("Brick Boots"),
    inventory_image = "moarmour_inv_boots_brick.png",
    groups = {armor_feet=12, armor_heal=4, armor_use=1100, physics_speed=-0.10, physics_jump=-0.05},
    wear = 0,
  })
  minetest.register_tool("moarmour:shield_brick", {
    description = S("Brick Shield"),
    inventory_image = "moarmour_inv_shield_brick.png",
    groups = {armor_shield=12, armor_heal=4, armor_use=1100, physics_speed=-0.10, physics_jump=-0.05},
    wear = 0,
  })

if minetest.get_modpath("moreores") then

  minetest.register_tool("moarmour:helmet_silver", {
    description = S("Silver Helmet"),
    inventory_image = "moarmour_inv_helmet_silver.png",
    groups = {armor_head=10, armor_heal=5, armor_use=700},
    wear = 0,
  })
  minetest.register_tool("moarmour:chestplate_silver", {
    description = S("Silver Chestplate"),
    inventory_image = "moarmour_inv_chestplate_silver.png",
    groups = {armor_torso=15, armor_heal=5, armor_use=700},
    wear = 0,
  })
  minetest.register_tool("moarmour:leggings_silver", {
    description = S("Silver Leggings"),
    inventory_image = "moarmour_inv_leggings_silver.png",
    groups = {armor_legs=15, armor_heal=5, armor_use=700},
    wear = 0,
  })
  minetest.register_tool("moarmour:boots_silver", {
    description = S("Silver Boots"),
    inventory_image = "moarmour_inv_boots_silver.png",
    groups = {armor_feet=10, armor_heal=5, armor_use=700},
    wear = 0,
  })
  minetest.register_tool("moarmour:shield_silver", {
    description = S("Silver Shield"),
    inventory_image = "moarmour_inv_shield_silver.png",
    groups = {armor_shield=10, armor_heal=5, armor_use=700},
    wear = 0,
  })

  minetest.register_tool("moarmour:helmet_rhodo", {
    description = S("Rhodochrosite Helmet"),
    inventory_image = "moarmour_inv_helmet_rhodo.png",
    groups = {armor_head=15, armor_heal=12, armor_use=200},
    wear = 0,
  })
  minetest.register_tool("moarmour:chestplate_rhodo", {
    description = S("Rhodochrosite Chestplate"),
    inventory_image = "moarmour_inv_chestplate_rhodo.png",
    groups = {armor_torso=20, armor_heal=12, armor_use=200},
    wear = 0,
  })
  minetest.register_tool("moarmour:leggings_rhodo", {
    description = S("Rhodochrosite Leggings"),
    inventory_image = "moarmour_inv_leggings_rhodo.png",
    groups = {armor_legs=20, armor_heal=12, armor_use=200},
    wear = 0,
  })
  minetest.register_tool("moarmour:boots_rhodo", {
    description = S("Rhodochrosite Boots"),
    inventory_image = "moarmour_inv_boots_rhodo.png",
    groups = {armor_feet=15, armor_heal=12, armor_use=200},
    wear = 0,
  })
  minetest.register_tool("moarmour:shield_rhodo", {
    description = S("Rhodochrosite Shield"),
    inventory_image = "moarmour_inv_shield_rhodo.png",
    groups = {armor_shield=15, armor_heal=12, armor_use=200},
    wear = 0,
  })

end

if minetest.get_modpath("nyancats_plus") then

  minetest.register_tool("moarmour:helmet_rainbow", {
    description = S("Rainbow Helmet"),
    inventory_image = "moarmour_inv_helmet_rainbow.png",
    groups = {armor_head=16.5, armor_heal=12, armor_use=0},
    wear = 0,
  })
  minetest.register_tool("moarmour:chestplate_rainbow", {
    description = S("Rainbow Chestplate"),
    inventory_image = "moarmour_inv_chestplate_rainbow.png",
    groups = {armor_torso=22, armor_heal=12, armor_use=0},
    wear = 0,
  })
  minetest.register_tool("moarmour:leggings_rainbow", {
    description = S("Rainbow Leggings"),
    inventory_image = "moarmour_inv_leggings_rainbow.png",
    groups = {armor_legs=22, armor_heal=12, armor_use=0},
    wear = 0,
  })
  minetest.register_tool("moarmour:boots_rainbow", {
    description = S("Rainbow Boots"),
    inventory_image = "moarmour_inv_boots_rainbow.png",
    groups = {armor_feet=16.5, armor_heal=12, armor_use=0},
    wear = 0,
  })
  minetest.register_tool("moarmour:shield_rainbow", {
    description = S("Rainbow Shield"),
    inventory_image = "moarmour_inv_shield_rainbow.png",
    groups = {armor_shield=16.5, armor_heal=12, armor_use=0},
    wear = 0,
  })

end

if minetest.get_modpath("waffles") then

  minetest.register_tool("moarmour:helmet_waffle", {
    description = S("Waffle Helmet"),
    inventory_image = "moarmour_inv_helmet_waffle.png",
    groups = {armor_head=15, armor_heal=12, armor_use=200},
    wear = 0,
  })
  minetest.register_tool("moarmour:chestplate_waffle", {
    description = S("Waffle Chestplate"),
    inventory_image = "moarmour_inv_chestplate_waffle.png",
    groups = {armor_torso=20, armor_heal=12, armor_use=200},
    wear = 0,
  })
  minetest.register_tool("moarmour:leggings_waffle", {
    description = S("Waffle Leggings"),
    inventory_image = "moarmour_inv_leggings_waffle.png",
    groups = {armor_legs=20, armor_heal=12, armor_use=200},
    wear = 0,
  })
  minetest.register_tool("moarmour:boots_waffle", {
    description = S("Waffle Boots"),
    inventory_image = "moarmour_inv_boots_waffle.png",
    groups = {armor_feet=15, armor_heal=12, armor_use=200},
    wear = 0,
  })
  minetest.register_tool("moarmour:shield_waffle", {
    description = S("Waffle Shield"),
    inventory_image = "moarmour_inv_shield_waffle.png",
    groups = {armor_shield=15, armor_heal=12, armor_use=200},
    wear = 0,
  })

end

if minetest.get_modpath("farming") then

  minetest.register_tool("moarmour:helmet_chocolate", {
    description = S("Chocolate Helmet"),
    inventory_image = "moarmour_inv_helmet_chocolate.png",
    groups = {armor_head=10, armor_heal=5, armor_use=800},
    wear = 0,
  })
  minetest.register_tool("moarmour:chestplate_chocolate", {
    description = S("Chocolate Chestplate"),
    inventory_image = "moarmour_inv_chestplate_chocolate.png",
    groups = {armor_torso=15, armor_heal=5, armor_use=800},
    wear = 0,
  })
  minetest.register_tool("moarmour:leggings_chocolate", {
    description = S("Chocolate Leggings"),
    inventory_image = "moarmour_inv_leggings_chocolate.png",
    groups = {armor_legs=15, armor_heal=5, armor_use=800},
    wear = 0,
  })
  minetest.register_tool("moarmour:boots_chocolate", {
    description = S("Chocolate Boots"),
    inventory_image = "moarmour_inv_boots_chocolate.png",
    groups = {armor_feet=10, armor_heal=5, armor_use=800},
    wear = 0,
  })
  minetest.register_tool("moarmour:shield_chocolate", {
    description = S("Chocolate Shield"),
    inventory_image = "moarmour_inv_shield_chocolate.png",
    groups = {armor_shield=10, armor_heal=5, armor_use=800},
    wear = 0,
  })

end

if minetest.get_modpath("nanotech") then

  minetest.register_tool("moarmour:helmet_carbonfiber", {
    description = S("Carbonfiber Helmet"),
    inventory_image = "moarmour_inv_helmet_carbonfiber.png",
    groups = {armor_head=22.5, armor_heal=18, armor_use=165},
    wear = 0,
  })
  minetest.register_tool("moarmour:chestplate_carbonfiber", {
    description = S("Carbonfiber Chestplate"),
    inventory_image = "moarmour_inv_chestplate_carbonfiber.png",
    groups = {armor_torso=30, armor_heal=18, armor_use=165},
    wear = 0,
  })
  minetest.register_tool("moarmour:leggings_carbonfiber", {
    description = S("Carbonfiber Leggings"),
    inventory_image = "moarmour_inv_leggings_carbonfiber.png",
    groups = {armor_legs=30, armor_heal=18, armor_use=165},
    wear = 0,
  })
  minetest.register_tool("moarmour:boots_carbonfiber", {
    description = S("Carbonfiber Boots"),
    inventory_image = "moarmour_inv_boots_carbonfiber.png",
    groups = {armor_feet=22.5, armor_heal=18, armor_use=165},
    wear = 0,
  })
  minetest.register_tool("moarmour:shield_carbonfiber", {
    description = S("Carbonfiber Shield"),
    inventory_image = "moarmour_inv_shield_carbonfiber.png",
    groups = {armor_shield=22.5, armor_heal=18, armor_use=165},
    wear = 0,
  })

end

if minetest.get_modpath("xpanes") then

  minetest.register_tool("moarmour:helmet_ibrog", {
    description = S("Ibrog Helmet"),
    inventory_image = "moarmour_inv_helmet_ibrog.png",
    groups = {armor_head=15, armor_heal=12, armor_use=200},
    wear = 0,
  })
  minetest.register_tool("moarmour:chestplate_ibrog", {
    description = S("Ibrog Chestplate"),
    inventory_image = "moarmour_inv_chestplate_ibrog.png",
    groups = {armor_torso=20, armor_heal=12, armor_use=200},
    wear = 0,
  })
  minetest.register_tool("moarmour:leggings_ibrog", {
    description = S("Ibrog Leggings"),
    inventory_image = "moarmour_inv_leggings_ibrog.png",
    groups = {armor_legs=20, armor_heal=12, armor_use=200},
    wear = 0,
  })
  minetest.register_tool("moarmour:boots_ibrog", {
    description = S("Ibrog Boots"),
    inventory_image = "moarmour_inv_boots_ibrog.png",
    groups = {armor_feet=15, armor_heal=12, armor_use=200},
    wear = 0,
  })
  minetest.register_tool("moarmour:shield_ibrog", {
    description = S("Ibrog Shield"),
    inventory_image = "moarmour_inv_shield_ibrog.png",
    groups = {armor_shield=15, armor_heal=12, armor_use=200},
    wear = 0,
  })

end

if minetest.get_modpath("even_mosword") then

  minetest.register_tool("moarmour:helmet_hero", {
    description = S("Hero Mese Helmet"),
    inventory_image = "moarmour_inv_helmet_hero.png",
    groups = {armor_head=56, armor_heal=45, armor_use=150, physics_jump=0.20,physics_speed=0.20,},
    wear = 0,
  })
  minetest.register_tool("moarmour:chestplate_hero", {
    description = S("Hero Mese Chestplate"),
    inventory_image = "moarmour_inv_chestplate_hero.png",
    groups = {armor_torso=75, armor_heal=45, armor_use=150, physics_jump=0.20,physics_speed=0.20,},
    wear = 0,
  })
  minetest.register_tool("moarmour:leggings_hero", {
    description = S("Hero Mese Leggings"),
    inventory_image = "moarmour_inv_leggings_hero.png",
    groups = {armor_legs=75, armor_heal=45, armor_use=150, physics_jump=0.20,physics_speed=0.20,},
    wear = 0,
  })
  minetest.register_tool("moarmour:boots_hero", {
    description = S("Hero Mese Boots"),
    inventory_image = "moarmour_inv_boots_hero.png",
    groups = {armor_feet=56, armor_heal=45, armor_use=150, physics_jump=0.20,physics_speed=0.20,},
    wear = 0,
  })
  minetest.register_tool("moarmour:shield_hero", {
    description = S("Hero Mese Shield"),
    inventory_image = "moarmour_inv_shield_hero.png",
    groups = {armor_shield=56, armor_heal=45, armor_use=150, physics_jump=0.20,physics_speed=0.20,},
    wear = 0,
  })

end

if minetest.get_modpath("candycane") then

  minetest.register_tool("moarmour:helmet_cane", {
    description = S("Candycane Helmet"),
    inventory_image = "moarmour_inv_helmet_cane.png",
    groups = {armor_head=15, armor_heal=12, armor_use=200},
    wear = 0,
  })
  minetest.register_tool("moarmour:chestplate_cane", {
    description = S("Candycane Chestplate"),
    inventory_image = "moarmour_inv_chestplate_cane.png",
    groups = {armor_torso=20, armor_heal=12, armor_use=200},
    wear = 0,
  })
  minetest.register_tool("moarmour:leggings_cane", {
    description = S("Candycane Leggings"),
    inventory_image = "moarmour_inv_leggings_cane.png",
    groups = {armor_legs=20, armor_heal=12, armor_use=200},
    wear = 0,
  })
  minetest.register_tool("moarmour:boots_cane", {
    description = S("Candycane Boots"),
    inventory_image = "moarmour_inv_boots_cane.png",
    groups = {armor_feet=15, armor_heal=12, armor_use=200},
    wear = 0,
  })
  minetest.register_tool("moarmour:shield_cane", {
    description = S("Candycane Shield"),
    inventory_image = "moarmour_inv_shield_cane.png",
    groups = {armor_shield=15, armor_heal=12, armor_use=200},
    wear = 0,
  })

end

if minetest.get_modpath("bones") then

  minetest.register_tool("moarmour:helmet_skeletal", {
    description = S("Skeletal Helmet"),
    inventory_image = "moarmour_inv_helmet_skeletal.png",
    groups = {armor_head=30, armor_heal=15, armor_use=80},
    wear = 0,
  })
  minetest.register_tool("moarmour:chestplate_skeletal", {
    description = S("Skeletal Chestplate"),
    inventory_image = "moarmour_inv_chestplate_skeletal.png",
    groups = {armor_torso=40, armor_heal=15, armor_use=80},
    wear = 0,
  })
  minetest.register_tool("moarmour:leggings_skeletal", {
    description = S("Skeletal Leggings"),
    inventory_image = "moarmour_inv_leggings_skeletal.png",
    groups = {armor_legs=40, armor_heal=15, armor_use=80},
    wear = 0,
  })
  minetest.register_tool("moarmour:boots_skeletal", {
    description = S("Skeletal Boots"),
    inventory_image = "moarmour_inv_boots_skeletal.png",
    groups = {armor_feet=30, armor_heal=15, armor_use=80},
    wear = 0,
  })
  minetest.register_tool("moarmour:shield_skeletal", {
    description = S("Skeletal Shield"),
    inventory_image = "moarmour_inv_shield_skeletal.png",
    groups = {armor_shield=30, armor_heal=15, armor_use=80},
    wear = 0,
  })

end

if minetest.get_modpath("nyancats_plus") and minetest.get_modpath("waffles") and minetest.get_modpath("tac_nayn") then

  minetest.register_tool("moarmour:helmet_tacnayn", {
    description = S("Tac Nayn Helmet"),
    inventory_image = "moarmour_inv_helmet_tacnayn.png",
    groups = {armor_head=30, armor_heal=30, armor_use=0, physics_jump=0.05, physics_speed=0.10, radiation=40, armor_fire=5},
    wear = 0,
  })
  minetest.register_tool("moarmour:chestplate_tacnayn", {
    description = S("Tac Nayn Chestplate"),
    inventory_image = "moarmour_inv_chestplate_tacnayn.png",
    groups = {armor_torso=40, armor_heal=30, armor_use=0, physics_jump=0.05, physics_speed=0.10, radiation=40, armor_fire=5},
    wear = 0,
  })
  minetest.register_tool("moarmour:leggings_tacnayn", {
    description = S("Tac Nayn Leggings"),
    inventory_image = "moarmour_inv_leggings_tacnayn.png",
    groups = {armor_legs=40, armor_heal=30, armor_use=0, physics_jump=0.05, physics_speed=0.10, radiation=40, armor_fire=5},
    wear = 0,
  })
  minetest.register_tool("moarmour:boots_tacnayn", {
    description = S("Tac Nayn Boots"),
    inventory_image = "moarmour_inv_boots_tacnayn.png",
    groups = {armor_feet=30, armor_heal=30, armor_use=0, physics_jump=0.05, physics_speed=0.10, radiation=40, armor_fire=5},
    wear = 0,
  })
  minetest.register_tool("moarmour:shield_tacnayn", {
    description = S("Tac Nayn Shield"),
    inventory_image = "moarmour_inv_shield_tacnayn.png",
    groups = {armor_shield=30, armor_heal=30, armor_use=0, physics_jump=0.05, physics_speed=0.10, radiation=40, armor_fire=5},
    wear = 0,
  })

end

if minetest.get_modpath("sky_tools") then

  minetest.register_tool("moarmour:helmet_sky", {
    description = S("Sky Helmet"),
    inventory_image = "moarmour_inv_helmet_sky.png",
    groups = {armor_head=15, armor_heal=14, armor_use=175},
    wear = 0,
  })
  minetest.register_tool("moarmour:chestplate_sky", {
    description = S("Sky Chestplate"),
    inventory_image = "moarmour_inv_chestplate_sky.png",
    groups = {armor_torso=20, armor_heal=14, armor_use=175},
    wear = 0,
  })
  minetest.register_tool("moarmour:leggings_sky", {
    description = S("Sky Leggings"),
    inventory_image = "moarmour_inv_leggings_sky.png",
    groups = {armor_legs=20, armor_heal=14, armor_use=175},
    wear = 0,
  })
  minetest.register_tool("moarmour:boots_sky", {
    description = S("Sky Boots"),
    inventory_image = "moarmour_inv_boots_sky.png",
    groups = {armor_feet=15, armor_heal=14, armor_use=175},
    wear = 0,
  })
  minetest.register_tool("moarmour:shield_sky", {
    description = S("Sky Shield"),
    inventory_image = "moarmour_inv_shield_sky.png",
    groups = {armor_shield=15, armor_heal=14, armor_use=175},
    wear = 0,
  })

end

if minetest.get_modpath("emeralds") then

  minetest.register_tool("moarmour:helmet_emeralds", {
    description = S("Emeralds Helmet"),
    inventory_image = "moarmour_inv_helmet_emeralds.png",
    groups = {armor_head=10, armor_heal=5, armor_use=70},
    wear = 0,
  })
  minetest.register_tool("moarmour:chestplate_emeralds", {
    description = S("Emeralds Chestplate"),
    inventory_image = "moarmour_inv_chestplate_emeralds.png",
    groups = {armor_torso=15, armor_heal=5, armor_use=70},
    wear = 0,
  })
  minetest.register_tool("moarmour:leggings_emeralds", {
    description = S("Emeralds Leggings"),
    inventory_image = "moarmour_inv_leggings_emeralds.png",
    groups = {armor_legs=15, armor_heal=5, armor_use=70},
    wear = 0,
  })
  minetest.register_tool("moarmour:boots_emeralds", {
    description = S("Emeralds Boots"),
    inventory_image = "moarmour_inv_boots_emeralds.png",
    groups = {armor_feet=10, armor_heal=5, armor_use=70},
    wear = 0,
  })
  minetest.register_tool("moarmour:shield_emeralds", {
    description = S("Emeralds Shield"),
    inventory_image = "moarmour_inv_shield_emeralds.png",
    groups = {armor_shield=10, armor_heal=5, armor_use=70},
    wear = 0,
  })

end

if minetest.get_modpath("gems") then

  minetest.register_tool("moarmour:helmet_emerald", {
    description = S("Emerald Helmet"),
    inventory_image = "moarmour_inv_helmet_emerald.png",
    groups = {armor_head=10, armor_heal=5, armor_use=70, radiation=15},
    wear = 0,
  })
  minetest.register_tool("moarmour:chestplate_emerald", {
    description = S("Emerald Chestplate"),
    inventory_image = "moarmour_inv_chestplate_emerald.png",
    groups = {armor_torso=15, armor_heal=5, armor_use=70, radiation=15},
    wear = 0,
  })
  minetest.register_tool("moarmour:leggings_emerald", {
    description = S("Emerald Leggings"),
    inventory_image = "moarmour_inv_leggings_emerald.png",
    groups = {armor_legs=15, armor_heal=5, armor_use=70, radiation=15},
    wear = 0,
  })
  minetest.register_tool("moarmour:boots_emerald", {
    description = S("Emerald Boots"),
    inventory_image = "moarmour_inv_boots_emerald.png",
    groups = {armor_feet=10, armor_heal=5, armor_use=70, radiation=15},
    wear = 0,
  })
  minetest.register_tool("moarmour:shield_emerald", {
    description = S("Emerald Shield"),
    inventory_image = "moarmour_inv_shield_emerald.png",
    groups = {armor_shield=10, armor_heal=5, armor_use=70, radiation=15},
    wear = 0,
  })

  minetest.register_tool("moarmour:helmet_pearl", {
    description = S("Pearl Helmet"),
    inventory_image = "moarmour_inv_helmet_pearl.png",
    groups = {armor_head=10, armor_heal=5, armor_use=70, armor_water=1},
    wear = 0,
  })
  minetest.register_tool("moarmour:chestplate_pearl", {
    description = S("Pearl Chestplate"),
    inventory_image = "moarmour_inv_chestplate_pearl.png",
    groups = {armor_torso=15, armor_heal=5, armor_use=70, armor_water=1},
    wear = 0,
  })
  minetest.register_tool("moarmour:leggings_pearl", {
    description = S("Pearl Leggings"),
    inventory_image = "moarmour_inv_leggings_pearl.png",
    groups = {armor_legs=15, armor_heal=5, armor_use=70, armor_water=1},
    wear = 0,
  })
  minetest.register_tool("moarmour:boots_pearl", {
    description = S("Pearl Boots"),
    inventory_image = "moarmour_inv_boots_pearl.png",
    groups = {armor_feet=10, armor_heal=5, armor_use=70, armor_water=1},
    wear = 0,
  })
  minetest.register_tool("moarmour:shield_pearl", {
    description = S("Pearl Shield"),
    inventory_image = "moarmour_inv_shield_pearl.png",
    groups = {armor_shield=10, armor_heal=5, armor_use=70, armor_water=1},
    wear = 0,
  })

  minetest.register_tool("moarmour:helmet_amethyst", {
    description = S("Amethyst Helmet"),
    inventory_image = "moarmour_inv_helmet_amethyst.png",
    groups = {armor_head=10, armor_heal=5, armor_use=70, physics_speed=0.20},
    wear = 0,
  })
  minetest.register_tool("moarmour:chestplate_amethyst", {
    description = S("Amethyst Chestplate"),
    inventory_image = "moarmour_inv_chestplate_amethyst.png",
    groups = {armor_torso=15, armor_heal=5, armor_use=70, physics_speed=0.20},
    wear = 0,
  })
  minetest.register_tool("moarmour:leggings_amethyst", {
    description = S("Amethyst Leggings"),
    inventory_image = "moarmour_inv_leggings_amethyst.png",
    groups = {armor_legs=15, armor_heal=5, armor_use=70, physics_speed=0.20},
    wear = 0,
  })
  minetest.register_tool("moarmour:boots_amethyst", {
    description = S("Amethyst Boots"),
    inventory_image = "moarmour_inv_boots_amethyst.png",
    groups = {armor_feet=10, armor_heal=5, armor_use=70, physics_speed=0.20},
    wear = 0,
  })
  minetest.register_tool("moarmour:shield_amethyst", {
    description = S("Amethyst Shield"),
    inventory_image = "moarmour_inv_shield_amethyst.png",
    groups = {armor_shield=10, armor_heal=5, armor_use=70, physics_speed=0.20},
    wear = 0,
  })

  minetest.register_tool("moarmour:helmet_sapphire", {
    description = S("Sapphire Helmet"),
    inventory_image = "moarmour_inv_helmet_sapphire.png",
    groups = {armor_head=10, armor_heal=5, armor_use=70, physics_gravity=-0.20},
    wear = 0,
  })
  minetest.register_tool("moarmour:chestplate_sapphire", {
    description = S("Sapphire Chestplate"),
    inventory_image = "moarmour_inv_chestplate_sapphire.png",
    groups = {armor_torso=15, armor_heal=5, armor_use=70, physics_gravity=-0.20},
    wear = 0,
  })
  minetest.register_tool("moarmour:leggings_sapphire", {
    description = S("Sapphire Leggings"),
    inventory_image = "moarmour_inv_leggings_sapphire.png",
    groups = {armor_legs=15, armor_heal=5, armor_use=70, physics_gravity=-0.20},
    wear = 0,
  })
  minetest.register_tool("moarmour:boots_sapphire", {
    description = S("Sapphire Boots"),
    inventory_image = "moarmour_inv_boots_sapphire.png",
    groups = {armor_feet=10, armor_heal=5, armor_use=70, physics_gravity=-0.20},
    wear = 0,
  })
  minetest.register_tool("moarmour:shield_sapphire", {
    description = S("Sapphire Shield"),
    inventory_image = "moarmour_inv_shield_sapphire.png",
    groups = {armor_shield=10, armor_heal=5, armor_use=70, physics_gravity=-0.20},
    wear = 0,
  })

  minetest.register_tool("moarmour:helmet_ruby", {
    description = S("Ruby Helmet"),
    inventory_image = "moarmour_inv_helmet_ruby.png",
    groups = {armor_head=10, armor_heal=5, armor_use=70, armor_fire=5},
    wear = 0,
  })
  minetest.register_tool("moarmour:chestplate_ruby", {
    description = S("Ruby Chestplate"),
    inventory_image = "moarmour_inv_chestplate_ruby.png",
    groups = {armor_torso=15, armor_heal=5, armor_use=70, armor_fire=5},
    wear = 0,
  })
  minetest.register_tool("moarmour:leggings_ruby", {
    description = S("Ruby Leggings"),
    inventory_image = "moarmour_inv_leggings_ruby.png",
    groups = {armor_legs=15, armor_heal=5, armor_use=70, armor_fire=5},
    wear = 0,
  })
  minetest.register_tool("moarmour:boots_ruby", {
    description = S("Ruby Boots"),
    inventory_image = "moarmour_inv_boots_ruby.png",
    groups = {armor_feet=10, armor_heal=5, armor_use=70, armor_fire=5},
    wear = 0,
  })
  minetest.register_tool("moarmour:shield_ruby", {
    description = S("Ruby Shield"),
    inventory_image = "moarmour_inv_shield_ruby.png",
    groups = {armor_shield=10, armor_heal=5, armor_use=70, armor_fire=5},
    wear = 0,
  })

  minetest.register_tool("moarmour:helmet_shadow", {
    description = S("Shadow Helmet"),
    inventory_image = "moarmour_inv_helmet_shadow.png",
    groups = {armor_head=10, armor_heal=5, armor_use=0, physics_speed=0.10, physics_gravity=-0.10, radiation=8, armor_water=1, armor_fire=5},
    wear = 0,
  })
  minetest.register_tool("moarmour:chestplate_shadow", {
    description = S("Shadow Chestplate"),
    inventory_image = "moarmour_inv_chestplate_shadow.png",
    groups = {armor_torso=15, armor_heal=5, armor_use=0, physics_speed=0.10, physics_gravity=-0.10, radiation=8, armor_water=1, armor_fire=5},
    wear = 0,
  })
  minetest.register_tool("moarmour:leggings_shadow", {
    description = S("Shadow Leggings"),
    inventory_image = "moarmour_inv_leggings_shadow.png",
    groups = {armor_legs=15, armor_heal=5, armor_use=0, physics_speed=0.10, physics_gravity=-0.10, radiation=8, armor_water=1, armor_fire=5},
    wear = 0,
  })
  minetest.register_tool("moarmour:boots_shadow", {
    description = S("Shadow Boots"),
    inventory_image = "moarmour_inv_boots_shadow.png",
    groups = {armor_feet=10, armor_heal=5, armor_use=0, physics_speed=0.10, physics_gravity=-0.10, radiation=8, armor_water=1, armor_fire=5},
    wear = 0,
  })
  minetest.register_tool("moarmour:shield_shadow", {
    description = S("Shadow Shield"),
    inventory_image = "moarmour_inv_shield_shadow.png",
    groups = {armor_shield=10, armor_heal=5, armor_use=0, physics_speed=0.10, physics_gravity=-0.10, radiation=8, armor_water=1, armor_fire=5},
    wear = 0,
  })

end

if minetest.get_modpath("terumet") then

  minetest.register_tool("moarmour:helmet_cgls", {
    description = S("Coreglass Helmet"),
    inventory_image = "moarmour_inv_helmet_cgls.png",
    groups = {armor_head=19, armor_heal=2, armor_use=20},
    wear = 0,
  })
  minetest.register_tool("moarmour:chestplate_cgls", {
    description = S("Coreglass Chestplate"),
    inventory_image = "moarmour_inv_chestplate_cgls.png",
    groups = {armor_torso=25, armor_heal=2, armor_use=20},
    wear = 0,
  })
  minetest.register_tool("moarmour:leggings_cgls", {
    description = S("Coreglass Leggings"),
    inventory_image = "moarmour_inv_leggings_cgls.png",
    groups = {armor_legs=25, armor_heal=2, armor_use=20},
    wear = 0,
  })
  minetest.register_tool("moarmour:boots_cgls", {
    description = S("Coreglass Boots"),
    inventory_image = "moarmour_inv_boots_cgls.png",
    groups = {armor_feet=19, armor_heal=2, armor_use=20},
    wear = 0,
  })
  minetest.register_tool("moarmour:shield_cgls", {
    description = S("Coreglass Shield"),
    inventory_image = "moarmour_inv_shield_cgls.png",
    groups = {armor_shield=19, armor_heal=2, armor_use=20},
    wear = 0,
  })

  minetest.register_tool("moarmour:helmet_tcop", {
    description = S("Terucopper Helmet"),
    inventory_image = "moarmour_inv_helmet_tcop.png",
    groups = {armor_head=13, armor_heal=1, armor_use=20},
    wear = 0,
  })
  minetest.register_tool("moarmour:chestplate_tcop", {
    description = S("Terucopper Chestplate"),
    inventory_image = "moarmour_inv_chestplate_tcop.png",
    groups = {armor_torso=17.5, armor_heal=1, armor_use=20},
    wear = 0,
  })
  minetest.register_tool("moarmour:leggings_tcop", {
    description = S("Terucopper Leggings"),
    inventory_image = "moarmour_inv_leggings_tcop.png",
    groups = {armor_legs=17.5, armor_heal=1, armor_use=20},
    wear = 0,
  })
  minetest.register_tool("moarmour:boots_tcop", {
    description = S("Terucopper Boots"),
    inventory_image = "moarmour_inv_boots_tcop.png",
    groups = {armor_feet=13, armor_heal=1, armor_use=20},
    wear = 0,
  })
  minetest.register_tool("moarmour:shield_tcop", {
    description = S("Terucopper Shield"),
    inventory_image = "moarmour_inv_shield_tcop.png",
    groups = {armor_shield=13, armor_heal=1, armor_use=20},
    wear = 0,
  })

  minetest.register_tool("moarmour:helmet_tcha", {
    description = S("Teruchalcum Helmet"),
    inventory_image = "moarmour_inv_helmet_tcha.png",
    groups = {armor_head=16.5, armor_heal=1, armor_use=20},
    wear = 0,
  })
  minetest.register_tool("moarmour:chestplate_tcha", {
    description = S("Teruchalcum Chestplate"),
    inventory_image = "moarmour_inv_chestplate_tcha.png",
    groups = {armor_torso=22, armor_heal=1, armor_use=20},
    wear = 0,
  })
  minetest.register_tool("moarmour:leggings_tcha", {
    description = S("Teruchalcum Leggings"),
    inventory_image = "moarmour_inv_leggings_tcha.png",
    groups = {armor_legs=22, armor_heal=1, armor_use=20},
    wear = 0,
  })
  minetest.register_tool("moarmour:boots_tcha", {
    description = S("Teruchalcum Boots"),
    inventory_image = "moarmour_inv_boots_tcha.png",
    groups = {armor_feet=16.5, armor_heal=1, armor_use=20},
    wear = 0,
  })
  minetest.register_tool("moarmour:shield_tcha", {
    description = S("Teruchalcum Shield"),
    inventory_image = "moarmour_inv_shield_tcha.png",
    groups = {armor_shield=16.5, armor_heal=1, armor_use=20},
    wear = 0,
  })

  minetest.register_tool("moarmour:helmet_tgol", {
    description = S("Terugold Helmet"),
    inventory_image = "moarmour_inv_helmet_tgol.png",
    groups = {armor_head=16.5, armor_heal=1, armor_use=20},
    wear = 0,
  })
  minetest.register_tool("moarmour:chestplate_tgol", {
    description = S("Terugold Chestplate"),
    inventory_image = "moarmour_inv_chestplate_tgol.png",
    groups = {armor_torso=22, armor_heal=1, armor_use=20},
    wear = 0,
  })
  minetest.register_tool("moarmour:leggings_tgol", {
    description = S("Terugold Leggings"),
    inventory_image = "moarmour_inv_leggings_tgol.png",
    groups = {armor_legs=22, armor_heal=1, armor_use=20},
    wear = 0,
  })
  minetest.register_tool("moarmour:boots_tgol", {
    description = S("Terugold Boots"),
    inventory_image = "moarmour_inv_boots_tgol.png",
    groups = {armor_feet=16.5, armor_heal=1, armor_use=20},
    wear = 0,
        })
        minetest.register_tool("moarmour:shield_tgol", {
    description = S("Terugold Shield"),
    inventory_image = "moarmour_inv_shield_tgol.png",
    groups = {armor_shield=16.5, armor_heal=1, armor_use=20},
    wear = 0,
  })

  minetest.register_tool("moarmour:helmet_tste", {
    description = S("Terusteel Helmet"),
    inventory_image = "moarmour_inv_helmet_tste.png",
    groups = {armor_head=15, armor_heal=1, armor_use=20},
    wear = 0,
  })
  minetest.register_tool("moarmour:chestplate_tste", {
    description = S("Terusteel Chestplate"),
    inventory_image = "moarmour_inv_chestplate_tste.png",
    groups = {armor_torso=20, armor_heal=1, armor_use=20},
    wear = 0,
  })
  minetest.register_tool("moarmour:leggings_tste", {
    description = S("Terusteel Leggings"),
    inventory_image = "moarmour_inv_leggings_tste.png",
    groups = {armor_legs=20, armor_heal=1, armor_use=20},
    wear = 0,
  })
  minetest.register_tool("moarmour:boots_tste", {
    description = S("Terusteel Boots"),
    inventory_image = "moarmour_inv_boots_tste.png",
    groups = {armor_feet=15, armor_heal=1, armor_use=20},
    wear = 0,
  })
  minetest.register_tool("moarmour:shield_tste", {
    description = S("Terusteel Shield"),
    inventory_image = "moarmour_inv_shield_tste.png",
    groups = {armor_shield=15, armor_heal=1, armor_use=20},
    wear = 0,
  })


end
