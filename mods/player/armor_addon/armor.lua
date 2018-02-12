-- Armors --
minetest.register_tool("armor_addon:helmet_obsidian", {
		description = "Obsidian Helmet",
		inventory_image = "armor_addon_inv_helmet_obsidian.png",
		groups = {armor_head=22.5, armor_heal=18, armor_use=300},
		wear = 0,
	})
	minetest.register_tool("armor_addon:chestplate_obsidian", {
		description = "Obsidian Chestplate",
		inventory_image = "armor_addon_inv_chestplate_obsidian.png",
		groups = {armor_torso=30, armor_heal=18, armor_use=300},
		wear = 0,
	})
	minetest.register_tool("armor_addon:leggings_obsidian", {
		description = "Obsidian Leggings",
		inventory_image = "armor_addon_inv_leggings_obsidian.png",
		groups = {armor_legs=30, armor_heal=18, armor_use=300},
		wear = 0,
	})
	minetest.register_tool("armor_addon:boots_obsidian", {
		description = "Obsidian Boots",
		inventory_image = "armor_addon_inv_boots_obsidian.png",
		groups = {armor_feet=22.5, armor_heal=18, armor_use=300},
		wear = 0,
        })
        minetest.register_tool("armor_addon:shield_obsidian", {
		description = "Obsidian Shield",
		inventory_image = "armor_addon_inv_shield_obsidian.png",
		groups = {armor_shield=22.5, armor_heal=18, armor_use=300},
		wear = 0,
	})
minetest.register_tool("armor_addon:helmet_tin", {
		description = "Tin Helmet",
		inventory_image = "armor_addon_inv_helmet_tin.png",
		groups = {armor_head=6, armor_heal=0, armor_use=800},
		wear = 0,
	})
	minetest.register_tool("armor_addon:chestplate_tin", {
		description = "Tin Chestplate",
		inventory_image = "armor_addon_inv_chestplate_tin.png",
		groups = {armor_torso=12, armor_heal=0, armor_use=800},
		wear = 0,
	})
	minetest.register_tool("armor_addon:leggings_tin", {
		description = "Tin Leggings",
		inventory_image = "armor_addon_inv_leggings_tin.png",
		groups = {armor_legs=12, armor_heal=0, armor_use=800},
		wear = 0,
	})
	minetest.register_tool("armor_addon:boots_tin", {
		description = "Tin Boots",
		inventory_image = "armor_addon_inv_boots_tin.png",
		groups = {armor_feet=6, armor_heal=0, armor_use=800},
		wear = 0,
        })
        minetest.register_tool("armor_addon:shield_tin", {
		description = "Tin Shield",
		inventory_image = "armor_addon_inv_shield_tin.png",
		groups = {armor_shield=6, armor_heal=0, armor_use=800},
		wear = 0,
	})
minetest.register_tool("armor_addon:helmet_brick", {
		description = "Brick Helmet",
		inventory_image = "armor_addon_inv_helmet_brick.png",
		groups = {armor_head=12, armor_heal=4, armor_use=1100, physics_speed=-0.10, physics_jump=-0.05},
		wear = 0,
	})
	minetest.register_tool("armor_addon:chestplate_brick", {
		description = "Brick Chestplate",
		inventory_image = "armor_addon_inv_chestplate_brick.png",
		groups = {armor_torso=15, armor_heal=4, armor_use=1100, physics_speed=-0.10, physics_jump=-0.05},
		wear = 0,
	})
	minetest.register_tool("armor_addon:leggings_brick", {
		description = "Brick Leggings",
		inventory_image = "armor_addon_inv_leggings_brick.png",
		groups = {armor_legs=15, armor_heal=4, armor_use=1100, physics_speed=-0.10, physics_jump=-0.05},
		wear = 0,
	})
	minetest.register_tool("armor_addon:boots_brick", {
		description = "Brick Boots",
		inventory_image = "armor_addon_inv_boots_brick.png",
		groups = {armor_feet=12, armor_heal=4, armor_use=1100, physics_speed=-0.10, physics_jump=-0.05},
		wear = 0,
        })
        minetest.register_tool("armor_addon:shield_brick", {
		description = "Brick Shield",
		inventory_image = "armor_addon_inv_shield_brick.png",
		groups = {armor_shield=12, armor_heal=4, armor_use=1100, physics_speed=-0.10, physics_jump=-0.05},
		wear = 0,
	})

if minetest.get_modpath("moreores") then

minetest.register_tool("armor_addon:helmet_silver", {
		description = "Silver Helmet",
		inventory_image = "armor_addon_inv_helmet_silver.png",
		groups = {armor_head=10, armor_heal=5, armor_use=700},
		wear = 0,
	})
	minetest.register_tool("armor_addon:chestplate_silver", {
		description = "Silver Chestplate",
		inventory_image = "armor_addon_inv_chestplate_silver.png",
		groups = {armor_torso=15, armor_heal=5, armor_use=700},
		wear = 0,
	})
	minetest.register_tool("armor_addon:leggings_silver", {
		description = "Silver Leggings",
		inventory_image = "armor_addon_inv_leggings_silver.png",
		groups = {armor_legs=15, armor_heal=5, armor_use=700},
		wear = 0,
	})
	minetest.register_tool("armor_addon:boots_silver", {
		description = "Silver Boots",
		inventory_image = "armor_addon_inv_boots_silver.png",
		groups = {armor_feet=10, armor_heal=5, armor_use=700},
		wear = 0,
        })
        minetest.register_tool("armor_addon:shield_silver", {
		description = "Silver Shield",
		inventory_image = "armor_addon_inv_shield_silver.png",
		groups = {armor_shield=10, armor_heal=5, armor_use=700},
		wear = 0,
	})
minetest.register_tool("armor_addon:helmet_rhodo", {
		description = "Rhodochrosite Helmet",
		inventory_image = "armor_addon_inv_helmet_rhodo.png",
		groups = {armor_head=15, armor_heal=12, armor_use=200},
		wear = 0,
	})
	minetest.register_tool("armor_addon:chestplate_rhodo", {
		description = "Rhodochrosite Chestplate",
		inventory_image = "armor_addon_inv_chestplate_rhodo.png",
		groups = {armor_torso=20, armor_heal=12, armor_use=200},
		wear = 0,
	})
	minetest.register_tool("armor_addon:leggings_rhodo", {
		description = "Rhodochrosite Leggings",
		inventory_image = "armor_addon_inv_leggings_rhodo.png",
		groups = {armor_legs=20, armor_heal=12, armor_use=200},
		wear = 0,
	})
	minetest.register_tool("armor_addon:boots_rhodo", {
		description = "Rhodochrosite Boots",
		inventory_image = "armor_addon_inv_boots_rhodo.png",
		groups = {armor_feet=15, armor_heal=12, armor_use=200},
		wear = 0,
        })
        minetest.register_tool("armor_addon:shield_rhodo", {
		description = "Rhodochrosite Shield",
		inventory_image = "armor_addon_inv_shield_rhodo.png",
		groups = {armor_shield=15, armor_heal=12, armor_use=200},
		wear = 0,
	})

end

if minetest.get_modpath("nyancats_plus") then

minetest.register_tool("armor_addon:helmet_rainbow", {
		description = "Rainbow Helmet",
		inventory_image = "armor_addon_inv_helmet_rainbow.png",
		groups = {armor_head=16.5, armor_heal=12, armor_use=0},
		wear = 0,
	})
	minetest.register_tool("armor_addon:chestplate_rainbow", {
		description = "Rainbow Chestplate",
		inventory_image = "armor_addon_inv_chestplate_rainbow.png",
		groups = {armor_torso=22, armor_heal=12, armor_use=0},
		wear = 0,
	})
	minetest.register_tool("armor_addon:leggings_rainbow", {
		description = "Rainbow Leggings",
		inventory_image = "armor_addon_inv_leggings_rainbow.png",
		groups = {armor_legs=22, armor_heal=12, armor_use=0},
		wear = 0,
	})
	minetest.register_tool("armor_addon:boots_rainbow", {
		description = "Rainbow Boots",
		inventory_image = "armor_addon_inv_boots_rainbow.png",
		groups = {armor_feet=16.5, armor_heal=12, armor_use=0},
		wear = 0,
        })
        minetest.register_tool("armor_addon:shield_rainbow", {
		description = "Rainbow Shield",
		inventory_image = "armor_addon_inv_shield_rainbow.png",
		groups = {armor_shield=16.5, armor_heal=12, armor_use=0},
		wear = 0,
	})

end

if minetest.get_modpath("waffles") then

minetest.register_tool("armor_addon:helmet_waffle", {
		description = "Waffle Helmet",
		inventory_image = "armor_addon_inv_helmet_waffle.png",
		groups = {armor_head=15, armor_heal=12, armor_use=200},
		wear = 0,
	})
	minetest.register_tool("armor_addon:chestplate_waffle", {
		description = "Waffle Chestplate",
		inventory_image = "armor_addon_inv_chestplate_waffle.png",
		groups = {armor_torso=20, armor_heal=12, armor_use=200},
		wear = 0,
	})
	minetest.register_tool("armor_addon:leggings_waffle", {
		description = "Waffle Leggings",
		inventory_image = "armor_addon_inv_leggings_waffle.png",
		groups = {armor_legs=20, armor_heal=12, armor_use=200},
		wear = 0,
	})
	minetest.register_tool("armor_addon:boots_waffle", {
		description = "Waffle Boots",
		inventory_image = "armor_addon_inv_boots_waffle.png",
		groups = {armor_feet=15, armor_heal=12, armor_use=200},
		wear = 0,
        })
        minetest.register_tool("armor_addon:shield_waffle", {
		description = "Waffle Shield",
		inventory_image = "armor_addon_inv_shield_waffle.png",
		groups = {armor_shield=15, armor_heal=12, armor_use=200},
		wear = 0,
	})

end

if minetest.get_modpath("farming") then

minetest.register_tool("armor_addon:helmet_chocolate", {
		description = "Chocolate Helmet",
		inventory_image = "armor_addon_inv_helmet_chocolate.png",
		groups = {armor_head=10, armor_heal=5, armor_use=800},
		wear = 0,
	})
	minetest.register_tool("armor_addon:chestplate_chocolate", {
		description = "Chocolate Chestplate",
		inventory_image = "armor_addon_inv_chestplate_chocolate.png",
		groups = {armor_torso=15, armor_heal=5, armor_use=800},
		wear = 0,
	})
	minetest.register_tool("armor_addon:leggings_chocolate", {
		description = "Chocolate Leggings",
		inventory_image = "armor_addon_inv_leggings_chocolate.png",
		groups = {armor_legs=15, armor_heal=5, armor_use=800},
		wear = 0,
	})
	minetest.register_tool("armor_addon:boots_chocolate", {
		description = "Chocolate Boots",
		inventory_image = "armor_addon_inv_boots_chocolate.png",
		groups = {armor_feet=10, armor_heal=5, armor_use=800},
		wear = 0,
        })
        minetest.register_tool("armor_addon:shield_chocolate", {
		description = "Chocolate Shield",
		inventory_image = "armor_addon_inv_shield_chocolate.png",
		groups = {armor_shield=10, armor_heal=5, armor_use=800},
		wear = 0,
	})

end

if minetest.get_modpath("nanotech") then

minetest.register_tool("armor_addon:helmet_carbonfiber", {
		description = "Carbonfiber Helmet",
		inventory_image = "armor_addon_inv_helmet_carbonfiber.png",
		groups = {armor_head=22.5, armor_heal=18, armor_use=165},
		wear = 0,
	})
	minetest.register_tool("armor_addon:chestplate_carbonfiber", {
		description = "Carbonfiber Chestplate",
		inventory_image = "armor_addon_inv_chestplate_carbonfiber.png",
		groups = {armor_torso=30, armor_heal=18, armor_use=165},
		wear = 0,
	})
	minetest.register_tool("armor_addon:leggings_carbonfiber", {
		description = "Carbonfiber Leggings",
		inventory_image = "armor_addon_inv_leggings_carbonfiber.png",
		groups = {armor_legs=30, armor_heal=18, armor_use=165},
		wear = 0,
	})
	minetest.register_tool("armor_addon:boots_carbonfiber", {
		description = "Carbonfiber Boots",
		inventory_image = "armor_addon_inv_boots_carbonfiber.png",
		groups = {armor_feet=22.5, armor_heal=18, armor_use=165},
		wear = 0,
        })
        minetest.register_tool("armor_addon:shield_carbonfiber", {
		description = "Carbonfiber Shield",
		inventory_image = "armor_addon_inv_shield_carbonfiber.png",
		groups = {armor_shield=22.5, armor_heal=18, armor_use=165},
		wear = 0,
	})

end

if minetest.get_modpath("xpanes") then

minetest.register_tool("armor_addon:helmet_ibrog", {
		description = "Ibrog Helmet",
		inventory_image = "armor_addon_inv_helmet_ibrog.png",
		groups = {armor_head=15, armor_heal=12, armor_use=200},
		wear = 0,
	})
	minetest.register_tool("armor_addon:chestplate_ibrog", {
		description = "Ibrog Chestplate",
		inventory_image = "armor_addon_inv_chestplate_ibrog.png",
		groups = {armor_torso=20, armor_heal=12, armor_use=200},
		wear = 0,
	})
	minetest.register_tool("armor_addon:leggings_ibrog", {
		description = "Ibrog Leggings",
		inventory_image = "armor_addon_inv_leggings_ibrog.png",
		groups = {armor_legs=20, armor_heal=12, armor_use=200},
		wear = 0,
	})
	minetest.register_tool("armor_addon:boots_ibrog", {
		description = "Ibrog Boots",
		inventory_image = "armor_addon_inv_boots_ibrog.png",
		groups = {armor_feet=15, armor_heal=12, armor_use=200},
		wear = 0,
        })
        minetest.register_tool("armor_addon:shield_ibrog", {
		description = "Ibrog Shield",
		inventory_image = "armor_addon_inv_shield_ibrog.png",
		groups = {armor_shield=15, armor_heal=12, armor_use=200},
		wear = 0,
	})

end

if minetest.get_modpath("even_mosword") then

minetest.register_tool("armor_addon:helmet_hero", {
		description = "Hero Mese Helmet",
		inventory_image = "armor_addon_inv_helmet_hero.png",
		groups = {armor_head=56, armor_heal=45, armor_use=150, physics_jump=0.20,physics_speed=0.20,},
		wear = 0,
	})
	minetest.register_tool("armor_addon:chestplate_hero", {
		description = "Hero Mese Chestplate",
		inventory_image = "armor_addon_inv_chestplate_hero.png",
		groups = {armor_torso=75, armor_heal=45, armor_use=150, physics_jump=0.20,physics_speed=0.20,},
		wear = 0,
	})
	minetest.register_tool("armor_addon:leggings_hero", {
		description = "Hero Mese Leggings",
		inventory_image = "armor_addon_inv_leggings_hero.png",
		groups = {armor_legs=75, armor_heal=45, armor_use=150, physics_jump=0.20,physics_speed=0.20,},
		wear = 0,
	})
	minetest.register_tool("armor_addon:boots_hero", {
		description = "Hero Mese Boots",
		inventory_image = "armor_addon_inv_boots_hero.png",
		groups = {armor_feet=56, armor_heal=45, armor_use=150, physics_jump=0.20,physics_speed=0.20,},
		wear = 0,
        })
        minetest.register_tool("armor_addon:shield_hero", {
		description = "Hero Mese Shield",
		inventory_image = "armor_addon_inv_shield_hero.png",
		groups = {armor_shield=56, armor_heal=45, armor_use=150, physics_jump=0.20,physics_speed=0.20,},
		wear = 0,
	})

end

if minetest.get_modpath("candycane") then

minetest.register_tool("armor_addon:helmet_cane", {
		description = "Candycane Helmet",
		inventory_image = "armor_addon_inv_helmet_cane.png",
		groups = {armor_head=15, armor_heal=12, armor_use=200},
		wear = 0,
	})
	minetest.register_tool("armor_addon:chestplate_cane", {
		description = "Candycane Chestplate",
		inventory_image = "armor_addon_inv_chestplate_cane.png",
		groups = {armor_torso=20, armor_heal=12, armor_use=200},
		wear = 0,
	})
	minetest.register_tool("armor_addon:leggings_cane", {
		description = "Candycane Leggings",
		inventory_image = "armor_addon_inv_leggings_cane.png",
		groups = {armor_legs=20, armor_heal=12, armor_use=200},
		wear = 0,
	})
	minetest.register_tool("armor_addon:boots_cane", {
		description = "Candycane Boots",
		inventory_image = "armor_addon_inv_boots_cane.png",
		groups = {armor_feet=15, armor_heal=12, armor_use=200},
		wear = 0,
        })
        minetest.register_tool("armor_addon:shield_cane", {
		description = "Candycane Shield",
		inventory_image = "armor_addon_inv_shield_cane.png",
		groups = {armor_shield=15, armor_heal=12, armor_use=200},
		wear = 0,
	})

end

if minetest.get_modpath("bones") then

minetest.register_tool("armor_addon:helmet_skeletal", {
		description = "Skeletal Helmet",
		inventory_image = "armor_addon_inv_helmet_skeletal.png",
		groups = {armor_head=30, armor_heal=15, armor_use=80},
		wear = 0,
	})
	minetest.register_tool("armor_addon:chestplate_skeletal", {
		description = "Skeletal Chestplate",
		inventory_image = "armor_addon_inv_chestplate_skeletal.png",
		groups = {armor_torso=40, armor_heal=15, armor_use=80},
		wear = 0,
	})
	minetest.register_tool("armor_addon:leggings_skeletal", {
		description = "Skeletal Leggings",
		inventory_image = "armor_addon_inv_leggings_skeletal.png",
		groups = {armor_legs=40, armor_heal=15, armor_use=80},
		wear = 0,
	})
	minetest.register_tool("armor_addon:boots_skeletal", {
		description = "Skeletal Boots",
		inventory_image = "armor_addon_inv_boots_skeletal.png",
		groups = {armor_feet=30, armor_heal=15, armor_use=80},
		wear = 0,
        })
        minetest.register_tool("armor_addon:shield_skeletal", {
		description = "Skeletal Shield",
		inventory_image = "armor_addon_inv_shield_skeletal.png",
		groups = {armor_shield=30, armor_heal=15, armor_use=80},
		wear = 0,
	})

end

if minetest.get_modpath("nyancats_plus") and minetest.get_modpath("waffles") and minetest.get_modpath("tac_nayn") then

minetest.register_tool("armor_addon:helmet_tacnayn", {
		description = "Tac Nayn Helmet",
		inventory_image = "armor_addon_inv_helmet_tacnayn.png",
		groups = {armor_head=30, armor_heal=30, armor_use=0, physics_jump=0.05, physics_speed=0.10, radiation=40, armor_fire=5},
		wear = 0,
	})
	minetest.register_tool("armor_addon:chestplate_tacnayn", {
		description = "Tac Nayn Chestplate",
		inventory_image = "armor_addon_inv_chestplate_tacnayn.png",
		groups = {armor_torso=40, armor_heal=30, armor_use=0, physics_jump=0.05, physics_speed=0.10, radiation=40, armor_fire=5},
		wear = 0,
	})
	minetest.register_tool("armor_addon:leggings_tacnayn", {
		description = "Tac Nayn Leggings",
		inventory_image = "armor_addon_inv_leggings_tacnayn.png",
		groups = {armor_legs=40, armor_heal=30, armor_use=0, physics_jump=0.05, physics_speed=0.10, radiation=40, armor_fire=5},
		wear = 0,
	})
	minetest.register_tool("armor_addon:boots_tacnayn", {
		description = "Tac Nayn Boots",
		inventory_image = "armor_addon_inv_boots_tacnayn.png",
		groups = {armor_feet=30, armor_heal=30, armor_use=0, physics_jump=0.05, physics_speed=0.10, radiation=40, armor_fire=5},
		wear = 0,
        })
        minetest.register_tool("armor_addon:shield_tacnayn", {
		description = "Tac Nayn Shield",
		inventory_image = "armor_addon_inv_shield_tacnayn.png",
		groups = {armor_shield=30, armor_heal=30, armor_use=0, physics_jump=0.05, physics_speed=0.10, radiation=40, armor_fire=5},
		wear = 0,
	})

end

if minetest.get_modpath("sky_tools") then

minetest.register_tool("armor_addon:helmet_sky", {
		description = "Sky Helmet",
		inventory_image = "armor_addon_inv_helmet_sky.png",
		groups = {armor_head=15, armor_heal=14, armor_use=175},
		wear = 0,
	})
	minetest.register_tool("armor_addon:chestplate_sky", {
		description = "Sky Chestplate",
		inventory_image = "armor_addon_inv_chestplate_sky.png",
		groups = {armor_torso=20, armor_heal=14, armor_use=175},
		wear = 0,
	})
	minetest.register_tool("armor_addon:leggings_sky", {
		description = "Sky Leggings",
		inventory_image = "armor_addon_inv_leggings_sky.png",
		groups = {armor_legs=20, armor_heal=14, armor_use=175},
		wear = 0,
	})
	minetest.register_tool("armor_addon:boots_sky", {
		description = "Sky Boots",
		inventory_image = "armor_addon_inv_boots_sky.png",
		groups = {armor_feet=15, armor_heal=14, armor_use=175},
		wear = 0,
        })
        minetest.register_tool("armor_addon:shield_sky", {
		description = "Sky Shield",
		inventory_image = "armor_addon_inv_shield_sky.png",
		groups = {armor_shield=15, armor_heal=14, armor_use=175},
		wear = 0,
	})

end

if minetest.get_modpath("emeralds") then

minetest.register_tool("armor_addon:helmet_emeralds", {
		description = "Emeralds Helmet",
		inventory_image = "armor_addon_inv_helmet_emeralds.png",
		groups = {armor_head=10, armor_heal=5, armor_use=70},
		wear = 0,
	})
	minetest.register_tool("armor_addon:chestplate_emeralds", {
		description = "Emeralds Chestplate",
		inventory_image = "armor_addon_inv_chestplate_emeralds.png",
		groups = {armor_torso=15, armor_heal=5, armor_use=70},
		wear = 0,
	})
	minetest.register_tool("armor_addon:leggings_emeralds", {
		description = "Emeralds Leggings",
		inventory_image = "armor_addon_inv_leggings_emeralds.png",
		groups = {armor_legs=15, armor_heal=5, armor_use=70},
		wear = 0,
	})
	minetest.register_tool("armor_addon:boots_emeralds", {
		description = "Emeralds Boots",
		inventory_image = "armor_addon_inv_boots_emeralds.png",
		groups = {armor_feet=10, armor_heal=5, armor_use=70},
		wear = 0,
        })
        minetest.register_tool("armor_addon:shield_emeralds", {
		description = "Emeralds Shield",
		inventory_image = "armor_addon_inv_shield_emeralds.png",
		groups = {armor_shield=10, armor_heal=5, armor_use=70},
		wear = 0,
	})

end

if minetest.get_modpath("gems") then

minetest.register_tool("armor_addon:helmet_emerald", {
		description = "Emerald Helmet",
		inventory_image = "armor_addon_inv_helmet_emerald.png",
		groups = {armor_head=10, armor_heal=5, armor_use=70, radiation=15},
		wear = 0,
	})
	minetest.register_tool("armor_addon:chestplate_emerald", {
		description = "Emerald Chestplate",
		inventory_image = "armor_addon_inv_chestplate_emerald.png",
		groups = {armor_torso=15, armor_heal=5, armor_use=70, radiation=15},
		wear = 0,
	})
	minetest.register_tool("armor_addon:leggings_emerald", {
		description = "Emerald Leggings",
		inventory_image = "armor_addon_inv_leggings_emerald.png",
		groups = {armor_legs=15, armor_heal=5, armor_use=70, radiation=15},
		wear = 0,
	})
	minetest.register_tool("armor_addon:boots_emerald", {
		description = "Emerald Boots",
		inventory_image = "armor_addon_inv_boots_emerald.png",
		groups = {armor_feet=10, armor_heal=5, armor_use=70, radiation=15},
		wear = 0,
        })
        minetest.register_tool("armor_addon:shield_emerald", {
		description = "Emerald Shield",
		inventory_image = "armor_addon_inv_shield_emerald.png",
		groups = {armor_shield=10, armor_heal=5, armor_use=70, radiation=15},
		wear = 0,
	})

minetest.register_tool("armor_addon:helmet_pearl", {
		description = "Pearl Helmet",
		inventory_image = "armor_addon_inv_helmet_pearl.png",
		groups = {armor_head=10, armor_heal=5, armor_use=70, armor_water=1},
		wear = 0,
	})
	minetest.register_tool("armor_addon:chestplate_pearl", {
		description = "Pearl Chestplate",
		inventory_image = "armor_addon_inv_chestplate_pearl.png",
		groups = {armor_torso=15, armor_heal=5, armor_use=70, armor_water=1},
		wear = 0,
	})
	minetest.register_tool("armor_addon:leggings_pearl", {
		description = "Pearl Leggings",
		inventory_image = "armor_addon_inv_leggings_pearl.png",
		groups = {armor_legs=15, armor_heal=5, armor_use=70, armor_water=1},
		wear = 0,
	})
	minetest.register_tool("armor_addon:boots_pearl", {
		description = "Pearl Boots",
		inventory_image = "armor_addon_inv_boots_pearl.png",
		groups = {armor_feet=10, armor_heal=5, armor_use=70, armor_water=1},
		wear = 0,
        })
        minetest.register_tool("armor_addon:shield_pearl", {
		description = "Pearl Shield",
		inventory_image = "armor_addon_inv_shield_pearl.png",
		groups = {armor_shield=10, armor_heal=5, armor_use=70, armor_water=1},
		wear = 0,
	})

minetest.register_tool("armor_addon:helmet_amethyst", {
		description = "Amethyst Helmet",
		inventory_image = "armor_addon_inv_helmet_amethyst.png",
		groups = {armor_head=10, armor_heal=5, armor_use=70, physics_speed=0.20},
		wear = 0,
	})
	minetest.register_tool("armor_addon:chestplate_amethyst", {
		description = "Amethyst Chestplate",
		inventory_image = "armor_addon_inv_chestplate_amethyst.png",
		groups = {armor_torso=15, armor_heal=5, armor_use=70, physics_speed=0.20},
		wear = 0,
	})
	minetest.register_tool("armor_addon:leggings_amethyst", {
		description = "Amethyst Leggings",
		inventory_image = "armor_addon_inv_leggings_amethyst.png",
		groups = {armor_legs=15, armor_heal=5, armor_use=70, physics_speed=0.20},
		wear = 0,
	})
	minetest.register_tool("armor_addon:boots_amethyst", {
		description = "Amethyst Boots",
		inventory_image = "armor_addon_inv_boots_amethyst.png",
		groups = {armor_feet=10, armor_heal=5, armor_use=70, physics_speed=0.20},
		wear = 0,
        })
        minetest.register_tool("armor_addon:shield_amethyst", {
		description = "Amethyst Shield",
		inventory_image = "armor_addon_inv_shield_amethyst.png",
		groups = {armor_shield=10, armor_heal=5, armor_use=70, physics_speed=0.20},
		wear = 0,
	})

minetest.register_tool("armor_addon:helmet_sapphire", {
		description = "Sapphire Helmet",
		inventory_image = "armor_addon_inv_helmet_sapphire.png",
		groups = {armor_head=10, armor_heal=5, armor_use=70, physics_gravity=-0.20},
		wear = 0,
	})
	minetest.register_tool("armor_addon:chestplate_sapphire", {
		description = "Sapphire Chestplate",
		inventory_image = "armor_addon_inv_chestplate_sapphire.png",
		groups = {armor_torso=15, armor_heal=5, armor_use=70, physics_gravity=-0.20},
		wear = 0,
	})
	minetest.register_tool("armor_addon:leggings_sapphire", {
		description = "Sapphire Leggings",
		inventory_image = "armor_addon_inv_leggings_sapphire.png",
		groups = {armor_legs=15, armor_heal=5, armor_use=70, physics_gravity=-0.20},
		wear = 0,
	})
	minetest.register_tool("armor_addon:boots_sapphire", {
		description = "Sapphire Boots",
		inventory_image = "armor_addon_inv_boots_sapphire.png",
		groups = {armor_feet=10, armor_heal=5, armor_use=70, physics_gravity=-0.20},
		wear = 0,
        })
        minetest.register_tool("armor_addon:shield_sapphire", {
		description = "Sapphire Shield",
		inventory_image = "armor_addon_inv_shield_sapphire.png",
		groups = {armor_shield=10, armor_heal=5, armor_use=70, physics_gravity=-0.20},
		wear = 0,
	})

minetest.register_tool("armor_addon:helmet_ruby", {
		description = "Ruby Helmet",
		inventory_image = "armor_addon_inv_helmet_ruby.png",
		groups = {armor_head=10, armor_heal=5, armor_use=70, armor_fire=5},
		wear = 0,
	})
	minetest.register_tool("armor_addon:chestplate_ruby", {
		description = "Ruby Chestplate",
		inventory_image = "armor_addon_inv_chestplate_ruby.png",
		groups = {armor_torso=15, armor_heal=5, armor_use=70, armor_fire=5},
		wear = 0,
	})
	minetest.register_tool("armor_addon:leggings_ruby", {
		description = "Ruby Leggings",
		inventory_image = "armor_addon_inv_leggings_ruby.png",
		groups = {armor_legs=15, armor_heal=5, armor_use=70, armor_fire=5},
		wear = 0,
	})
	minetest.register_tool("armor_addon:boots_ruby", {
		description = "Ruby Boots",
		inventory_image = "armor_addon_inv_boots_ruby.png",
		groups = {armor_feet=10, armor_heal=5, armor_use=70, armor_fire=5},
		wear = 0,
        })
        minetest.register_tool("armor_addon:shield_ruby", {
		description = "Ruby Shield",
		inventory_image = "armor_addon_inv_shield_ruby.png",
		groups = {armor_shield=10, armor_heal=5, armor_use=70, armor_fire=5},
		wear = 0,
	})

minetest.register_tool("armor_addon:helmet_shadow", {
		description = "Shadow Helmet",
		inventory_image = "armor_addon_inv_helmet_shadow.png",
		groups = {armor_head=10, armor_heal=5, armor_use=0, physics_speed=0.10, physics_gravity=-0.10, radiation=8, armor_water=1, armor_fire=5},
		wear = 0,
	})
	minetest.register_tool("armor_addon:chestplate_shadow", {
		description = "Shadow Chestplate",
		inventory_image = "armor_addon_inv_chestplate_shadow.png",
		groups = {armor_torso=15, armor_heal=5, armor_use=0, physics_speed=0.10, physics_gravity=-0.10, radiation=8, armor_water=1, armor_fire=5},
		wear = 0,
	})
	minetest.register_tool("armor_addon:leggings_shadow", {
		description = "Shadow Leggings",
		inventory_image = "armor_addon_inv_leggings_shadow.png",
		groups = {armor_legs=15, armor_heal=5, armor_use=0, physics_speed=0.10, physics_gravity=-0.10, radiation=8, armor_water=1, armor_fire=5},
		wear = 0,
	})
	minetest.register_tool("armor_addon:boots_shadow", {
		description = "Shadow Boots",
		inventory_image = "armor_addon_inv_boots_shadow.png",
		groups = {armor_feet=10, armor_heal=5, armor_use=0, physics_speed=0.10, physics_gravity=-0.10, radiation=8, armor_water=1, armor_fire=5},
		wear = 0,
        })
        minetest.register_tool("armor_addon:shield_shadow", {
		description = "Shadow Shield",
		inventory_image = "armor_addon_inv_shield_shadow.png",
		groups = {armor_shield=10, armor_heal=5, armor_use=0, physics_speed=0.10, physics_gravity=-0.10, radiation=8, armor_water=1, armor_fire=5},
		wear = 0,
	})

end

if minetest.get_modpath("terumet") then

minetest.register_tool("armor_addon:helmet_cgls", {
		description = "Coreglass Helmet",
		inventory_image = "armor_addon_inv_helmet_cgls.png",
		groups = {armor_head=19, armor_heal=2, armor_use=20},
		wear = 0,
	})
	minetest.register_tool("armor_addon:chestplate_cgls", {
		description = "Coreglass Chestplate",
		inventory_image = "armor_addon_inv_chestplate_cgls.png",
		groups = {armor_torso=25, armor_heal=2, armor_use=20},
		wear = 0,
	})
	minetest.register_tool("armor_addon:leggings_cgls", {
		description = "Coreglass Leggings",
		inventory_image = "armor_addon_inv_leggings_cgls.png",
		groups = {armor_legs=25, armor_heal=2, armor_use=20},
		wear = 0,
	})
	minetest.register_tool("armor_addon:boots_cgls", {
                description = "Coreglass Boots",
		inventory_image = "armor_addon_inv_boots_cgls.png",
		groups = {armor_feet=19, armor_heal=2, armor_use=20},
		wear = 0,
        })
        minetest.register_tool("armor_addon:shield_cgls", {
		description = "Coreglass Shield",
		inventory_image = "armor_addon_inv_shield_cgls.png",
		groups = {armor_shield=19, armor_heal=2, armor_use=20},
		wear = 0,
	})

minetest.register_tool("armor_addon:helmet_tcop", {
		description = "Terucopper Helmet",
		inventory_image = "armor_addon_inv_helmet_tcop.png",
		groups = {armor_head=13, armor_heal=1, armor_use=20},
		wear = 0,
	})
	minetest.register_tool("armor_addon:chestplate_tcop", {
		description = "Terucopper Chestplate",
		inventory_image = "armor_addon_inv_chestplate_tcop.png",
		groups = {armor_torso=17.5, armor_heal=1, armor_use=20},
		wear = 0,
	})
	minetest.register_tool("armor_addon:leggings_tcop", {
		description = "Terucopper Leggings",
		inventory_image = "armor_addon_inv_leggings_tcop.png",
		groups = {armor_legs=17.5, armor_heal=1, armor_use=20},
		wear = 0,
	})
	minetest.register_tool("armor_addon:boots_tcop", {
		description = "Terucopper Boots",
		inventory_image = "armor_addon_inv_boots_tcop.png",
		groups = {armor_feet=13, armor_heal=1, armor_use=20},
		wear = 0,
        })
        minetest.register_tool("armor_addon:shield_tcop", {
		description = "Terucopper Shield",
		inventory_image = "armor_addon_inv_shield_tcop.png",
		groups = {armor_shield=13, armor_heal=1, armor_use=20},
		wear = 0,
	})

minetest.register_tool("armor_addon:helmet_tcha", {
		description = "Teruchalcum Helmet",
		inventory_image = "armor_addon_inv_helmet_tcha.png",
		groups = {armor_head=16.5, armor_heal=1, armor_use=20},
		wear = 0,
	})
	minetest.register_tool("armor_addon:chestplate_tcha", {
		description = "Teruchalcum Chestplate",
		inventory_image = "armor_addon_inv_chestplate_tcha.png",
		groups = {armor_torso=22, armor_heal=1, armor_use=20},
		wear = 0,
	})
	minetest.register_tool("armor_addon:leggings_tcha", {
		description = "Teruchalcum Leggings",
		inventory_image = "armor_addon_inv_leggings_tcha.png",
		groups = {armor_legs=22, armor_heal=1, armor_use=20},
		wear = 0,
	})
	minetest.register_tool("armor_addon:boots_tcha", {
		description = "Teruchalcum Boots",
		inventory_image = "armor_addon_inv_boots_tcha.png",
		groups = {armor_feet=16.5, armor_heal=1, armor_use=20},
		wear = 0,
        })
        minetest.register_tool("armor_addon:shield_tcha", {
		description = "Teruchalcum Shield",
		inventory_image = "armor_addon_inv_shield_tcha.png",
		groups = {armor_shield=16.5, armor_heal=1, armor_use=20},
		wear = 0,
	})

minetest.register_tool("armor_addon:helmet_tgol", {
		description = "Terugold Helmet",
		inventory_image = "armor_addon_inv_helmet_tgol.png",
		groups = {armor_head=16.5, armor_heal=1, armor_use=20},
		wear = 0,
	})
	minetest.register_tool("armor_addon:chestplate_tgol", {
		description = "Terugold Chestplate",
		inventory_image = "armor_addon_inv_chestplate_tgol.png",
		groups = {armor_torso=22, armor_heal=1, armor_use=20},
		wear = 0,
	})
	minetest.register_tool("armor_addon:leggings_tgol", {
		description = "Terugold Leggings",
		inventory_image = "armor_addon_inv_leggings_tgol.png",
		groups = {armor_legs=22, armor_heal=1, armor_use=20},
		wear = 0,
	})
	minetest.register_tool("armor_addon:boots_tgol", {
		description = "Terugold Boots",
		inventory_image = "armor_addon_inv_boots_tgol.png",
		groups = {armor_feet=16.5, armor_heal=1, armor_use=20},
		wear = 0,
        })
        minetest.register_tool("armor_addon:shield_tgol", {
		description = "Terugold Shield",
		inventory_image = "armor_addon_inv_shield_tgol.png",
		groups = {armor_shield=16.5, armor_heal=1, armor_use=20},
		wear = 0,
	})

minetest.register_tool("armor_addon:helmet_tste", {
		description = "Terusteel Helmet",
		inventory_image = "armor_addon_inv_helmet_tste.png",
		groups = {armor_head=15, armor_heal=1, armor_use=20},
		wear = 0,
	})
	minetest.register_tool("armor_addon:chestplate_tste", {
		description = "Terusteel Chestplate",
		inventory_image = "armor_addon_inv_chestplate_tste.png",
		groups = {armor_torso=20, armor_heal=1, armor_use=20},
		wear = 0,
	})
	minetest.register_tool("armor_addon:leggings_tste", {
		description = "Terusteel Leggings",
		inventory_image = "armor_addon_inv_leggings_tste.png",
		groups = {armor_legs=20, armor_heal=1, armor_use=20},
		wear = 0,
	})
	minetest.register_tool("armor_addon:boots_tste", {
		description = "Terusteel Boots",
		inventory_image = "armor_addon_inv_boots_tste.png",
		groups = {armor_feet=15, armor_heal=1, armor_use=20},
		wear = 0,
        })
        minetest.register_tool("armor_addon:shield_tste", {
		description = "Terusteel Shield",
		inventory_image = "armor_addon_inv_shield_tste.png",
		groups = {armor_shield=15, armor_heal=1, armor_use=20},
		wear = 0,
	})


end
