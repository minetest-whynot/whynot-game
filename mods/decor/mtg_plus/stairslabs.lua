-- Boilerplate to support localized strings if intllib mod is installed.
local S
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
else
	S = function(s) return s end
end

-- Stairs/slabs

-- Add tin block stair and tin block slab which are oddly not present in Minetest Game 0.4.16.
-- NOTE: It is likely that these block will be added into stock Minetest Game one day.
-- This automatically checks if the node is already registered to avoid duplicates.
-- TODO: Remove this section anyway when Minetest Game adds these blocks.
if minetest.registered_nodes["stairs:slab_tinblock"] == nil then
	stairs.register_stair_and_slab("tinblock", "default:tinblock", minetest.registered_nodes["default:tinblock"].groups, minetest.registered_nodes["default:tinblock"].tiles, S("Tin Block Stair"), S("Tin Block Slab"), minetest.registered_nodes["default:tinblock"].sounds)
end

-- Add custom stairs and slabs
local stairslab_ignore_groups = { "wood", "stone", "soil", }

local function simple_stair_slab(subname, desc_stair, desc_slab)
	local itemstring = "mtg_plus:"..subname
	local groups = table.copy(minetest.registered_nodes[itemstring].groups)
	for i=1,#stairslab_ignore_groups do
		groups[stairslab_ignore_groups[i]] = nil
	end
	stairs.register_stair_and_slab(subname, itemstring, groups, minetest.registered_nodes[itemstring].tiles, desc_stair, desc_slab, minetest.registered_nodes[itemstring].sounds)
end

simple_stair_slab("sandstone_cobble", S("Cobbled Sandstone Stair"), S("Cobbled Sandstone Slab"))
simple_stair_slab("desert_sandstone_cobble", S("Cobbled Desert Sandstone Stair"), S("Cobbled Desert Sandstone Slab"))
simple_stair_slab("silver_sandstone_cobble", S("Cobbled Silver Sandstone Stair"), S("Cobbled Silver Sandstone Slab"))
simple_stair_slab("jungle_cobble", S("Jungle Cobblestone Stair"), S("Jungle Cobblestone Slab"))
simple_stair_slab("snow_brick", S("Soft Snow Brick Stair"), S("Soft Snow Brick Slab"))
simple_stair_slab("hard_snow_brick", S("Hard Snow Brick Stair"), S("Hard Snow Brick Slab"))
simple_stair_slab("ice_snow_brick", S("Icy Snow Brick Stair"), S("Icy Snow Brick Slab"))
simple_stair_slab("ice_brick", S("Ice Brick Stair"), S("Ice Brick Slab"))
simple_stair_slab("ice_tile4", S("Ice Tile Stair"), S("Ice Tile Slab"))
simple_stair_slab("goldwood", S("Goldwood Stair"), S("Goldwood Slab"))
simple_stair_slab("goldbrick", S("Gold Brick Stair"), S("Gold Brick Slab"))
simple_stair_slab("bronzebrick", S("Bronze Brick Stair"), S("Bronze Brick Slab"))
simple_stair_slab("tinbrick", S("Tin Brick Stair"), S("Tin Brick Slab"))
simple_stair_slab("copperbrick", S("Copper Brick Stair"), S("Copper Brick Slab"))
simple_stair_slab("steelbrick", S("Steel Brick Stair"), S("Steel Brick Slab"))
simple_stair_slab("harddirtbrick", S("Hardened Dirt Brick Stair"), S("Hardened Dirt Brick Slab"))
simple_stair_slab("gravel_cobble", S("Cobbled Gravel Stair"), S("Cobbled Gravel Slab"))

stairs.register_slab("flint_block", "mtg_plus:flint_block", {cracky=2}, {"mtg_plus_flint_block.png", "mtg_plus_flint_block.png", "mtg_plus_flint_block_slab.png", "mtg_plus_flint_block_slab.png", "mtg_plus_flint_block_slab.png", "mtg_plus_flint_block_slab.png"}, S("Flint Block Slab"), minetest.registered_items["mtg_plus:flint_block"].sounds)
stairs.register_stair("flint_block", "mtg_plus:flint_block", {cracky=2}, {"mtg_plus_flint_block_slab.png", "mtg_plus_flint_block.png", "mtg_plus_flint_block_stair1.png", "mtg_plus_flint_block_stair2.png", "mtg_plus_flint_block.png", "mtg_plus_flint_block_slab.png"}, S("Flint Block Stair"), minetest.registered_items["mtg_plus:flint_block"].sounds)

stairs.register_slab("ice_block", "mtg_plus:ice_block", {cracky=3, puts_out_fire=1, cools_lava=1}, {"mtg_plus_ice_block.png", "mtg_plus_ice_block.png", "mtg_plus_ice_block_slab.png", "mtg_plus_ice_block_slab.png", "mtg_plus_ice_block_slab.png", "mtg_plus_ice_block_slab.png"}, S("Ice Block Slab"), minetest.registered_items["mtg_plus:ice_block"].sounds)
stairs.register_stair("ice_block", "mtg_plus:ice_block", {cracky=3, puts_out_fire=1, cools_lava=1}, {"mtg_plus_ice_block_slab.png", "mtg_plus_ice_block.png", "mtg_plus_ice_block_stair1.png", "mtg_plus_ice_block_stair2.png", "mtg_plus_ice_block.png", "mtg_plus_ice_block_slab.png"}, S("Ice Block Stair"), minetest.registered_items["mtg_plus:ice_block"].sounds)
