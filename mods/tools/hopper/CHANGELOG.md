### Change log

- 0.1 - Initial release from jordan4ibanez
- 0.2 - Fixed tool glitch (wear restored by accident)
- 0.3 - transfer function added
- 0.4 - Supports locked chest and protected chest
- 0.5 - Works with 0.4.13's new shift+click for newly placed Hoppers
- 0.6 - Remove formspec from hopper nodes to improve speed for servers
- 0.7 - Halved hopper capacity, can be dug by wooden pick
- 0.8 - Added Napiophelios' new textures and tweaked code
- 0.9 - Added support for Wine mod's wine barrels
- 1.0 - New furances do not work properly with hoppers so old reverted to abm furnaces
- 1.1 - Hoppers now work with new node timer Furnaces.  Reduced Abm's and tidied code.
- 1.2 - Added simple API so that hoppers can work with other containers.
- 1.3 - Hoppers now call on_metadata_inventory_put and on_metadata_inventory_take, triggering furnace timers via their standard callbacks. Updated side hopper rotation handling to allow it to function in any orientation. Added settings options to use 16-pixel or 32-pixel textures. Added settings option to allow explicit crafting of standard/side hoppers or to allow crafting of a single item that selects which type to use on place. Added in-game documentation via optional "doc" mod dependency
- 1.4 - Added intllib support
- 1.5 - Added chutes
- 1.6 - Added "eject items" button to formspecs, "group" support to the API
- 1.7 - Added sorter block to allow for more sophisticated item transfer arrangements
- master - Maintained by minetest-mods and contributors. Refer to git history for details.

