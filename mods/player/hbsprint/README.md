# hbSprint

## Description
A flexible sprint mod supporting stamina, hunger and coexistance with other physics altering mods.

## Licensing
- LGPLv2.1/CC BY-SA 3.0. Particle code: copyright (c) 2017 Elijah Duffy.
- sprint_stamina_\*icon textures:
  - CC0
  - Created by Jordan Irwin (AntumDeluge)
  - Based on [Running man icon by manio1](https://openclipart.org/detail/254287)

## Notes
hbSprint can be played with Minetest 0.4.16 or above.
It has no dependencies, but it supports on [hudbars](http://repo.or.cz/w/minetest_hudbars.git), [hbhunger](http://repo.or.cz/w/minetest_hbhunger.git) and [player_monoids](https://github.com/minetest-mods/player_monoids).

## List of features

- Displays and drains stamina (by default, if hudbars is present). Hides stamina bar if full.
- Displays and drains satiation (by default, if hbhunger is present)
- Drains air faster while sprinting on walkable ground but in water (by default)
- Requires only forward key to be pressed, not left and right (by default)
- Requires walkable ground (no water surface sprinting)
- Particle spawning based on ground type (Thanks to [octacian](https://github.com/octacian/sprint/))
- All variables customizable in Advanced settings or directly in minetest.conf


## Known issues
- Forward double tap support not implemented

## Bug reports and suggestions
You can report bugs or suggest ideas by [filing an issue](http://github.com/tacotexmex/hbsprint/issues/new).

## Links
* [Download ZIP](https://github.com/tacotexmex/hbsprint/archive/master.zip)
* [Source](https://github.com/tacotexmex/hbsprint/)
* [Forum thread](https://forum.minetest.net/viewtopic.php?f=9&t=18069&p=282981)
