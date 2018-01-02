# API documentation for Minetest Game Plus
Minetest Game Plus provides a simple API for adding more items.

## `mtg_plus.register_cup(subname, description, tiles, craftitem, craft_count, extra_groups, extra_sounds)`
Adds a new cup with itemstring `mtg_plus:cup_<subname>` and optionally a crafting recipe for this cup.

If `craftitem` is non-`nil`, the recipe follows this template:

    C.C
    .C.
    .C.

    C = `craftitem`
    . = nothing

Yields `craft_count` cups.

### Parameters
* `subname`: Part of the name which will be used to create the cup's itemstring
* `description`: In-game description/tooltip of the cup
* `tiles`: Textures
* `craftitem`: The item source to be used in the crafting recipe. If `nil`, no crafting recipe will be generated
* `craft_count`: How many cups will be crafted at once (only has an effect if `craftitem ~= nil`)
* `extra_groups`: Table of additional groups to assign to this item (optional)
* `extra_sounds`: Table of additional sounds (`SimpleSoundSpec`) to assign to this item (optional)

### Returns
Always `nil`.
