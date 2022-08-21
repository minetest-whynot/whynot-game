# The Edible Stuff API Mod

[![ContentDB](https://content.minetest.net/packages/lazerbeak12345/ediblestuff_api/shields/downloads/)](https://content.minetest.net/packages/lazerbeak12345/ediblestuff_api/)

Adds an API to MineTest to easily register tools as edible - and to make
specified armor get "eaten" automatically when hunger goes down.

When an `edible_while_wearing` armor peice is equipped, the player will eat some
of that armor if their saturation (or health in absence of a hunger 
mod) is below 85%. This reduces the durability of a random armor piece.

This mod was created for the [`chocolatestuff`][cs] mod, and so you can make your own armors like it - without needing to depend on `farming`.

[cs]: https://github.com/Lazerbeak12345/chocolatestuff

> This mod only provides the api to register a tool as edible.

## Requires

Nothing! But it has optional integration with:

- `stamina`
	- the `minetest-mods` fork
	- the `TenPlus1` fork
	- the `sofar` fork
- `hbhunger`
- `hunger_ng`
- `3d_armor`
	- If absent the armor apis do nothing.
- `shields`
- `hunger`
- `hud`
- `mcl_hunger`

For all the above, this mod (currently) assumes you are on a fairly recent version of that mod.

## API

This mod provides a global variable `ediblestuff`. All public api is within this.

### `ediblestuff.satiates` table

Used to prevent need for calling `on_use` when calculating eating equipped armor.

Key: item string

Value: how much this item satiates.

### `ediblestuff.make_thing_edible` function

Use `minetest.override_item`, `ediblestuff.satiates`, and specific mod register functions (`hunger_ng`, `hunger`) to mark the satiation of a given item.

Arguments:

1. `item` item string
2. `amount` number - amount the thing satiates (used as argument for `minetest.item_eat`)

### `ediblestuff.make_things_edible` function

Make a batch of things edible with a scale factor.

Arguments:

1. `mod` string - name of mod for itemstring
2. `name` string - name of itemtype (see example)
3. `scale` number - multiply the tool amount by this before calling `ediblestuff.make_thing_edible`
4. `items` table - the items to make edible
    - Key: string - the tool name
    - Value: number - the tool amount

Returns a table

- Key: String item type
- Value: scaled tool amount (tool amount \* scale)

> Return value was nil before version 1.2

```lua
ediblestuff.make_things_edible("mod","name",3,{
	tool=3,
	another=1,
})
```

Is the same as calling.

```lua
ediblestuff.make_thing_edible("mod:tool_name",9)
ediblestuff.make_thing_edible("mod:another_name",3)
```

### `ediblestuff.make_tools_edible` function

> New in 1.1

Mark a pick, shovel axe and sword as edible. The "tool amount" (see `ediblestuff.make_things_edible`) is equal to the number of element items in the crafting recipe.

If farming is present this will also register a hoe as edible.

Arguments:

1. `mod` string - name of mod for itemstring
2. `name` string - name of itemtype (see example)
3. `scale` number - multiply the tool amount by this before calling `ediblestuff.make_thing_edible`
4. Optional `is_flat_rate`. If `true` then the "tool amount" will be set to 1 for all tools. (Thus the satiation for all tools is equal to `scale`)

> Argument 4 `is_flat_rate` is new in 1.2

Returns a table

- Key: String item type
- Value: scaled tool amount (tool amount \* scale)

> Return value was nil before version 1.2

### `ediblestuff.make_armor_edible` function

> New in 1.1

Mark helmet, chestplate, leggings and boots as edible. The "tool amount" (see `ediblestuff.make_things_edible`) is equal to the number of element items in the crafting recipe.

If shields is present this will also register a shield as edible.

Arguments:

1. `mod` string - name of mod for itemstring
2. `name` string - name of itemtype (see example)
3. `scale` number - multiply the tool amount by this before calling `ediblestuff.make_thing_edible`
4. Optional `is_flat_rate`. If `true` then the "tool amount" will be set to 1 for all tools. (Thus the satiation for all tools is equal to `scale`)

> Argument 4 `is_flat_rate` is new in 1.2

Returns a table

- Key: String item type
- Value: scaled tool amount (tool amount \* scale)

> Return value was nil before version 1.2

### `ediblestuff.make_armor_edible_while_wearing` function

> New in 1.1

Calls `ediblestuff.make_armor_edible` with the same arguments but also registers all of those armor peices in `ediblestuff.edible_while_wearing`

Arguments:

1. `mod` string - name of mod for itemstring
2. `name` string - name of itemtype (see example)
3. `scale` number - multiply the tool amount by this before calling `ediblestuff.make_thing_edible`
4. Optional `is_flat_rate`. If `true` then the "tool amount" will be set to 1 for all tools. (Thus the satiation for all tools is equal to `scale`)

> Argument 4 `is_flat_rate` is new in 1.2

Returns a table

- Key: String item type
- Value: scaled tool amount (tool amount \* scale)

> Return value was nil before version 1.2

### `ediblestuff.get_max_hunger` function

Generic function for getting max hunger. If a hunger mod is not present it will return the `hp_max` for that player. (min hunger is zero across all supported mods)

Arguments:

1. `player` player object - the player in question (not all hunger mods have a standard max hunger)

Returns a number - the amount of hunger.

### `ediblestuff.get_hunger` function

Generic function for getting current hunger. If a hunger mod is not present it will return `get_hp` for that player.

Arguments:

1. `player` player object - the player in question

Returns a number - the amount of hunger. (keep in mind that this number's meaning is different across mods. use `ediblestuff.get_max_hunger` to mathmatically make up for that difference)

### `ediblestuff.alter_hunger` function

Generic function for getting current hunger. If a hunger mod is not present it will change HP.

Arguments:

1. `player` player object - the player in question
2. `amount` number - the amount to change the hunger by (positive makes them less hungry. See note about return value in `ediblestuff.get_hunger`)

### `ediblestuff.equipped` dict

A dictionary of all players known to be wearing armor registered in the `ediblestuff.edible_while_wearing` dictionary.

Updated automatically on these conditions:

- A player joins
- A player leaves (or times out)
- A player equips armor
- A player unequips armor
- A player's armor is destroyed

Keys: string - a player name

Value: true

### `ediblestuff.edible_while_wearing` dict

A dictionary of armor items that, when equipped, a player will eat from automatically, given they are hungry enough.

Keys: string - item name

Value: true

## TODO

- [ ] Upstream bug in 3d_armor with `get_weared_armor_elements`
- [ ] make a way to actually use the tool (shift? no shift?)
  - Doesn't seem possible. Can't tell MT engine to eat the tool but not use tool (except hoe, which is a type defined in farming)
- [ ] Settings?
- [ ] Prevent race-condidtions when setting `on_use` in `override_item`
- [ ] Find specific oldest supported MT version

## Legal

Copyright 2021-2 Lazerbeak12345

### Credit

- The YourLand players for a bunch of questionable ideas for this questionable mod. Original idea was from "Bla."
- The creator of [the obsidianstuff redo mod](https://github.com/OgelGames/obsidianstuff). This takes inspiration from that repo.
- The creator of [the edible swords mod][the_edible_swords_mod]. I took inspiration from this repo as well.

[the_edible_swords_mod]: https://content.minetest.net/packages/GamingAssociation39/edible_swords/

### Licence

GPL-3 or later
