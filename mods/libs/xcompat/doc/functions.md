# Functions API

## `can_interact_with_node(player, pos)`

returns `bool`

checks for the ability to interact with a node via:

* if a player
* owner metadata key
* `protection_bypass`

supports

* minetest game default if present
* else polyfill

## `get_default_stack_max()`

returns `number`

checks the current game against a table of games with their default stack_max

supports

* minetest game
* mineclonia
* farlands reloaded
* hades revisited
* exile
* devtest
