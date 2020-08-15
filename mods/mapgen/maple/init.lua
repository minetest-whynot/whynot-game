local S = minetest.get_translator(minetest.get_current_modname())

minetest.log("[MOD] Loading maple module...")
maple = {
  get_translator = S
}
dofile(minetest.get_modpath(minetest.get_current_modname()).."/trees.lua")

minetest.register_node("maple:maple_tree", {
  description = S("Maple Tree"),
  tiles = {"maple_tree_top.png", "maple_tree_top.png", "maple_tree.png"},
  paramtype2 = "facedir",
  is_ground_content = false,
  groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
  sounds = default.node_sound_wood_defaults(),

  on_place = minetest.rotate_node
})

minetest.register_node("maple:maple_wood", {
  description = S("Maple Wood Planks"),
  paramtype2 = "facedir",
  place_param2 = 0,
  tiles = {"maple_wood.png"},
  is_ground_content = false,
  groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
  sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("maple:maple_leaves", {
  description = S("Maple Leaves"),
  drawtype = "allfaces_optional",
  waving = 1,
  tiles = {"maple_leaves.png"},
  special_tiles = {"maple_leaves_simple.png"},
  paramtype = "light",
  is_ground_content = false,
  groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
  drop = {
    max_items = 1,
    items = {
      {
        -- player will get sapling with 1/20 chance
        items = {'maple:maple_sapling'},
        rarity = 20,
      },
      {
        -- player will get leaves only if he get no saplings,
        -- this is because max_items is 1
        items = {'maple:maple_leaves'},
      }
    }
  },
  sounds = default.node_sound_leaves_defaults(),

  after_place_node = default.after_place_leaves,
})



minetest.register_node("maple:maple_sapling", {
  description = S("Maple Sapling"),
  drawtype = "plantlike",
  visual_scale = 1.0,
  tiles = {"maple_sapling.png"},
  inventory_image = "maple_sapling.png",
  wield_image = "maple_sapling.png",
  paramtype = "light",
  sunlight_propagates = true,
  walkable = false,
  on_timer = maple.grow_sapling,
  selection_box = {
    type = "fixed",
    fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
  },
  groups = {snappy = 2, dig_immediate = 3, flammable = 2,
    attached_node = 1, sapling = 1},
  sounds = default.node_sound_leaves_defaults(),

  on_construct = function(pos)
    minetest.get_node_timer(pos):start(math.random(2400,4800))
  end,

  on_place = function(itemstack, placer, pointed_thing)
  print(S("Maple sapling placed."))
    itemstack = default.sapling_on_place(itemstack, placer, pointed_thing,
      "maple:maple_sapling",
      -- minp, maxp to be checked, relative to sapling pos
      -- minp_relative.y = 1 because sapling pos has been checked
      {x = -2, y = 1, z = -2},
      {x = 2, y = 13, z = 2},
      -- maximum interval of interior volume check
      4)

    return itemstack
  end,
})


minetest.register_decoration({
  deco_type = "schematic",
  place_on = {"default:dirt_with_grass"},
  sidelen = 16,
  noise_params = {
    offset = 0.0,
    --scale = -0.015,
    scale = 0.0007,
    spread = {x = 250, y = 250, z = 250},
    seed = 2,
    octaves = 3,
    persist = 0.66
  },
  biomes = {"deciduous_forest"},
  y_min = 1,
  y_max = 31000,
  schematic = minetest.get_modpath("maple").."/schematics/maple_tree.mts",
  flags = "place_center_x, place_center_z",
})

default.register_leafdecay({
  trunks = {"maple:maple_tree"},
  leaves = {"maple:maple_leaves"},
  radius = 3,
})

default.register_fence("maple:fence_maple_wood", {
  description = S("Maple Fence"),
  texture = "maple_fence.png",
  inventory_image = "default_fence_overlay.png^maple_wood.png^default_fence_overlay.png^[makealpha:255,126,126",
  wield_image = "default_fence_overlay.png^maple_wood.png^default_fence_overlay.png^[makealpha:255,126,126",
  material = "maple:maple_wood",
  groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
  sounds = default.node_sound_wood_defaults()
})

minetest.register_craft({
  output = 'maple:maple_wood 4',
  recipe = {
    {'maple:maple_tree'},
  }
})

minetest.register_craft({
  type = "fuel",
  recipe = "maple:maple_sapling",
  burntime = 12,
})

minetest.register_craft({
  type = "fuel",
  recipe = "maple:fence_maple_wood",
  burntime = 8,
})


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
