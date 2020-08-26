local S = maple.get_translator;

default.register_fence("maple:fence_maple_wood", {
  description = S("Maple Fence"),
  texture = "maple_fence.png",
  inventory_image = "default_fence_overlay.png^maple_wood.png^default_fence_overlay.png^[makealpha:255,126,126",
  wield_image = "default_fence_overlay.png^maple_wood.png^default_fence_overlay.png^[makealpha:255,126,126",
  material = "maple:maple_wood",
  groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
  sounds = default.node_sound_wood_defaults()
})

default.register_fence_rail("maple:fence_rail_maple_wood", {
  description = S("Maple Fence Rail"),
  texture = "maple_fence.png",
  inventory_image = "default_fence_rail_overlay.png^maple_wood.png^" ..
                          "default_fence_rail_overlay.png^[makealpha:255,126,126",
  wield_image = "default_fence_rail_overlay.png^maple_wood.png^" ..
                          "default_fence_rail_overlay.png^[makealpha:255,126,126",
  material = "maple:maple_wood",
  groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
  sounds = default.node_sound_wood_defaults()
})

doors.register_fencegate("maple:gate_maple_wood", {
  description = S("Maple Wood Fence Gate"),
  texture = "maple_wood.png",
  material = "maple:maple_wood",
  groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3}
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
