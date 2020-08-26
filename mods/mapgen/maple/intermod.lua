local S = maple.get_translator;

-- integration with bonemeal
if minetest.get_modpath("bonemeal") then
  bonemeal:add_sapling({
    {"maple:maple_sapling", maple.grow_sapling, "soil"},
  })
end

-- derivative blocks (stairs / microblocks / etc)
if stairs and stairs.mod and stairs.mod == "redo" then

  stairs.register_all("maple_wood", "maple:maple_wood",
    {choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
    {"maple_wood.png"},
    S("Maple Wood Stair"),
    S("Maple Wood Slab"),
    default.node_sound_wood_defaults())

  stairs.register_all("maple_tree", "maple:maple_tree",
    {choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
    {"maple_tree_top.png", "maple_tree_top.png", "maple_tree.png"},
    S("Maple Trunk Stair"),
    S("Maple Trunk Slab"),
    default.node_sound_wood_defaults())

elseif minetest.global_exists("stairsplus") then

  stairsplus:register_all("maple", "maple_wood", "maple:maple_wood", {
    description = S("Maple Wood"),
    tiles = {"maple_wood.png"},
    groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
    sounds = default.node_sound_wood_defaults(),
  })

  stairsplus:register_all("maple", "maple_tree", "maple:maple_tree", {
    description = S("Maple Trunk"),
    tiles = {"maple_tree_top.png", "maple_tree_top.png", "maple_tree.png"},
    groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
    sounds = default.node_sound_wood_defaults(),
  })

else

  stairs.register_stair_and_slab("maple_wood", "maple:maple_wood",
    {choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
    {"maple_wood.png"},
    S("Maple Stair"),
    S("Maple Slab"),
    default.node_sound_wood_defaults())

  stairs.register_stair_and_slab("maple_tree", "maple:maple_tree",
    {choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
    {"maple_tree_top.png", "maple_tree_top.png", "maple_tree.png"},
    S("Maple Trunk Stair"),
    S("Maple Trunk Slab"),
    default.node_sound_wood_defaults())


end

-- registering the wood type with drawers mod
if minetest.get_modpath("drawers") and default then

  drawers.register_drawer("maple:maple_drawerk", {
    description = S("Maple Drawers"),
    tiles1 = drawers.node_tiles_front_other("drawers_maple_wood_front_1.png",
      "drawers_maple_wood.png"),
    tiles2 = drawers.node_tiles_front_other("drawers_maple_wood_front_2.png",
      "drawers_maple_wood.png"),
    tiles4 = drawers.node_tiles_front_other("drawers_maple_wood_front_4.png",
      "drawers_maple_wood.png"),
    groups = {choppy = 3, oddly_breakable_by_hand = 2},
    sounds = drawers.WOOD_SOUNDS,
    drawer_stack_max_factor = 4 * 8, -- normal chest size
    material = "maple:maple_wood"
  })

end

-- procedurally-generated arcs
if minetest.get_modpath("pkarcs") then
  pkarcs.register_node("maple:maple_wood")
end
