local S = moarmour.get_translator

minetest.register_alias("armor_addon:ibrogblock", "moarmour:ibrogblock")
minetest.register_node("moarmour:ibrogblock", {
  description = S("Ibrog"),
  drawtype = "glasslike_framed_optional",
  tiles = {"moarmour_ibrogblock.png"},
  paramtype = "light",
  is_ground_content = false,
  sunlight_propagates = true,
  sounds = default.node_sound_glass_defaults(),
  groups = {cracky = 3},
})

minetest.register_alias("armor_addon:waffleblock", "moarmour:waffleblock")
minetest.register_node("moarmour:waffleblock", {
  description = S("Waffle Block"),
  tiles = {"moarmour_waffleblock.png"},
  is_ground_content = true,
  groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
  drop = 'moarmour:waffleblock',
  sounds = default.node_sound_wood_defaults(),
})