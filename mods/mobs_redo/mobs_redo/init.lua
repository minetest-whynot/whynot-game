
local path = minetest.get_modpath("mobs")

-- Peaceful player privilege
minetest.register_privilege("peaceful_player", {
	description = "Prevents Mobs Redo mobs from attacking player",
	give_to_singleplayer = false
})

-- Fallback node
minetest.register_node("mobs:fallback_node", {
	description = "Fallback Node",
	tiles = {"mobs_fallback.png"},
	is_ground_content = false,
	groups = {handy = 1, crumbly = 3, not_in_creative_inventory = 1},
	drop = ""
})

-- Mob API
dofile(path .. "/api.lua")

-- Rideable Mobs
dofile(path .. "/mount.lua")

-- Mob Items
dofile(path .. "/crafts.lua")

-- Mob Spawner
dofile(path .. "/spawner.lua")

-- Lucky Blocks
if minetest.get_modpath("lucky_block") then
	dofile(path .. "/lucky_block.lua")
end


print("[MOD] Mobs Redo loaded")
