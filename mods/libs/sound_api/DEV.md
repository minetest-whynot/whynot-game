# Sound API

This mod is a wrapper for [sound api library](https://github.com/mt-mods/sound_api_core/).

## Usage of the sound api

### Option 1: embed

You can insert the [sound api library](https://github.com/mt-mods/sound_api_core/) directly into your mod as a submodule and use the following to load it.

```lua
local sound_api = dofile(modpath .. "/sound_api_core/init.lua")
```

additionally the author recommends that you use dependabot(github) or similar to help you keep the submodule up to date.

### Option 2: Agnostically depend

You can do this by using a custom field in your node def instead of the `sounds` key.

```lua
minetest.register_node(nodename, {
    ...
    _sound_def = {
        key = "",
        input = {},
    },
    ...
})
```

where:

* key: string name of the field from the sound api you want to use, for example `node_sound_stone_defaults`
* input: table input of fields you want passed to the key field, used to override specific sounds.

### Option 3: Hard depend

add this mod to your mod.confs depends and directly call the sound_api as follows

```lua
minetest.register_node(nodename, {
    ...
    sounds = sound_api.node_sound_stone_defaults(input)
    ...
})
```

* input: optional table to override some or all of returned values

