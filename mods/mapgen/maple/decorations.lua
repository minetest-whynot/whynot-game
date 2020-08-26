local S = maple.get_translator;

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
  schematic = maple.path .. "/schematics/maple_tree.mts",
  flags = "place_center_x, place_center_z",
})