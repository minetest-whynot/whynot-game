minetest.register_craft(
  {
    output = "maple:maple_wood 4",
    recipe = {
      {"maple:maple_tree"}
    }
  }
)

minetest.register_craft(
  {
    type = "fuel",
    recipe = "maple:maple_sapling",
    burntime = 12
  }
)

minetest.register_craft(
  {
    type = "fuel",
    recipe = "maple:fence_maple_wood",
    burntime = 8
  }
)
