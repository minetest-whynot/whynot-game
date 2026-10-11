mtg_plus = {}

local path = minetest.get_modpath(minetest.get_current_modname())

-- Trivial blocks (full definition included; almost all nodes are full cubes)
dofile(path.."/brickblocks.lua") -- Bricks and blocks
dofile(path.."/cobble.lua") -- Cobblestone
dofile(path.."/seethrough.lua") -- Glasslike nodes
dofile(path.."/specials.lua") -- Nodes with something special (or misc. blocks)

-- Non-trivial blocks (definition require API)
dofile(path.."/stairslabs.lua") -- Stairs and slabs
dofile(path.."/wallfences.lua") -- Walls and fences
dofile(path.."/xpanes.lua") -- Panes (xpanes mod)
dofile(path.."/doors.lua") -- Doors and trapdoors
dofile(path.."/ladders.lua") -- Ladders

-- Support for other mods
dofile(path.."/extras.lua") -- Additional blocks and crafts for optional mods
dofile(path.."/awards.lua") -- Achievements for the awards mod

-- Compability
dofile(path.."/compat_xdecor.lua") -- xdecor compability
dofile(path.."/aliases.lua") -- Aliases for compability
