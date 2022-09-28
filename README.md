# whynot-game

A Game for MineTest in mod-collection style

This game shows the diversity of the MineTest community. The game does not follow any theme and does not try to clone any other blocky game, just minetest as known in community.

The name describes the way the mods are applied to the game. The game does not have rules for mods to be applied, all mods are welcome. But there are some rules why a mod cannot be applied to the game.

### List of already included mods

Generated file: [mod_sources.txt](https://github.com/minetest-whynot/whynot-game/blob/master/mod_sources.txt)

### License statement

Each of the mods do have their own free license.
The whynot related work (such as the buiding scripts) are GPLv3-only

### Contribution

If you find bugs in mods - please report them directly to the upstream.

Whynot related issues, new mod suggestions or if the bugs cannot be solved by upstream, please open issue in repository https://github.com/minetest-whynot/whynot-game.

## Whynot Rules for mods

### 1 don't take over the game

<span id="1-no-take-over-the-game"></span>

Unfortunately a lot of great mods assume the player likes to play with this mod only. This game stands for diversity. That means if a player does not like an included mod, they can play the game without using that mod (few exceptions).

### 2 don't take over the server

<span id="2-no-take-over-the-server"></span>

Thinking alongside point 1, the mod should be not strain the server if the mod is not in use. That means no unnecessary ABM's and so on.

### 3 don't destroy the world

<span id="3-no-destroy-the-world"></span>

The mod should not be able to destroy players' work.

### 4 no bad code quality

I look into the lua code of each mod before I make my decision. I am tolerant against imperfect code, but roughly negligent and/or bad code will be rejected. Advantage for the mod developer: They get a code review for free ;-) And if I like the mod, I might contribute some optimizations to get the mod ready for the game.

### 5 no all-in-one mods or lots of unused dependencies

<span id="5-no-all-in-one-mods-and-lot-of-unused-dependencies"></span>

It is difficult to consider an all-in-one mod for these described rules. Therefore an all-in-one mod might be rejected.

### 6 most items obtainable in survival

The game should be playable in survival. Therefore the items should be obtainable

### 7 No cheating mods

The mods should not feel like cheats. The tools should be worn, walking through the world and searching for rare items should not be made obsolete by item generators.

### 8 Mod under version control

This game is not a new home for mods. Each mod remains within and have their own upstream. Access by version control is required for scripted updates to the game. If bugs are found in mods in this game, please report them to the upstream sources.

### 9 Mod must not be incompatible with other mods

Mods should not require compatibility code to be added to the Whynot game, and thus requiring extra maintenance work on our part. If we find incompatibilities (ex. recipes conflicts, redundant items, keypress overlap) we expect any required changes to happen upstream before the mod is added to whynot. Some exceptions may be considered on a case-by-case basis.
