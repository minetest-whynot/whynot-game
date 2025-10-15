# Materials API

The materials can be accessed anywhere in your mod with `xcompat.materials.material_name`.

**Example**: `xcompat.materials.steel_ingot` returns the string of whichever item would closest represent the steel_ingot material in the current game.

Behind the scenes, the xcompat mod automatically changes the `xcompat.materials` variable to contain the correct materials for whichever game the mod is launched in. 

See the [the support table in the readme](https://github.com/mt-mods/xcompat/tree/master?tab=readme-ov-file#directly-supported-games-and-mods) for an overview of supported games, and see the contents of `/src/materials/` for the supported materials and their names. 

**Example**: the `/src/materials/mineclonia.lua` file shows what the keys of `xcompat.materials` resolve to when playing Mineclonia, such as `xcompat.materials.steel_ingot` resolving to `mcl_core:iron_ingot`, and `xcompat.materials.mesa_crystal` resolving to `mcl_redstone:redstone` if supported.
