local S = maple.get_translator;

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
        -- player will get sapling with 1/50 chance
        items = {'maple:maple_sapling'},
        rarity = 50,
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
  minetest.log("action", S("Maple sapling placed."))
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

default.register_leafdecay({
  trunks = {"maple:maple_tree"},
  leaves = {"maple:maple_leaves"},
  radius = 3,
})