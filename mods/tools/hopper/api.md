
# Hopper API

This API provides two functions for adding containers such as chests and furnaces that will interact with hoppers.

## hopper:add_container

```lua
hopper:add_container({ {"where_from", "node_name", "inventory_name"}, })
```

  'where_from' is a string telling the api that items are coming from either
               the 'top' node into a hopper below, going into the 'bottom' node
               from the hopper above or coming from a 'side' hopper into the
               node next door.

  'node_name"  is the name of the container itself (e.g. "default:chest")

  'inventory_name' is the name of the container inventory that is affected.

e.g.

```lua
hopper:add_container({
	{"top", "default:furnace", "dst"}, -- take cooked items from above into hopper below
	{"bottom", "default:furnace", "src"}, -- insert items below to be cooked from hopper above
	{"side", "default:furnace", "fuel"}, -- replenish furnace fuel from hopper at side
})
```

You can also register hopper interaction targets by group, or by a group and a specific group
value. For example:

```lua
hopper:add_container({
	{"top", "group:loot_chest", "loot"},
	{"bottom", "group:loot_chest", "loot"},
	{"side", "group:loot_chest", "loot"},
})
```

Would cause hoppers to interact with the "loot" inventory of all nodes belonging to the group
"loot_chest", and

```lua
hopper:add_container({
	{"top", "group:protected_container=1", "main"},
	{"bottom", "group:protected_container=1", "main"},
	{"side", "group:protected_container=1", "main"},
})
```

Would cause hoppers to interact with the "main" inventory of nodes belonging to the group
"protected_container" provided they had a value of 1 in that group. Hoppers prioritize the most
specific definition first; they check for registrations for a specific node name, then
for registrations that apply to a node's group and group value, and then for registrations
applying to a node's group in general.

Note that if multiple group registrations apply to the same node it's undefined which group
will take priority. Using the above examples, if there were a node that belonged to *both*
the groups "loot_chest" and "protected_container=1" there's no way of knowing ahead of time
whether hoppers would interact with the "loot" or "main" inventories. Try to avoid this situation.

### Optional parameter: get_inventory function

```lua
hopper:add_container({ {"where_from", "node_name", "inventory_name", get_inventory = function get_inventory(node_pos)}, })
```

This option allows you to use a different inventory instead of the inventory of this node. Unlike others, this parameter does not have to be set.

## hopper:set_extra_container_info

```lua
hopper:set_extra_container_info({ {"node_name", EXTRA PARAMETERS}, })
```

The function adds additional information about the container, which does not depend on where the items arrive. Before using it, you need to add a container.
Of course, it is not necessary to use it.

### EXTRA PARAMETER: set_hopper_param2 function

```lua
hopper:set_extra_container_info({ {"node_name", set_hopper_param2 = function set_hopper_param2(hopper_pos, node_pos)}, })
```

When we place the hopper, we have the position of the node we are looking at and the position of the funnel.
When other nodes get into the nodebox of one node, the information becomes insufficient, see [minetest 9147 issue](https://github.com/minetest/minetest/issues/9147). In particular, this feature was useful for adding [connected chests](https://github.com/HybridDog/connected_chests/pull/14) support.

This function takes priority over the usual installation of the hopper.

## Already supported containers

The hopper mod already have support for the wine barrel inside of the Wine mod and protected
chests inside of Protector Redo, as well as default chests, furnaces and hoppers
themselves.
