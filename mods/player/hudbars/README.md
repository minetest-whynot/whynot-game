# HUD Bars

## Description
This mod changes the HUD of Luanti . It replaces the default health and breath
symbols by horizontal colored bars with text showing the number.

Furthermore, it enables other mods to add their own custom bars to the HUD,
this mod will place them accordingly.

**Important**: Keep in mind if running a server with this mod, that the custom
position should be displayed correctly on every screen size.

## Current version
The current version is 2.3.7.
It works for Minetest/Luanti 5.3.0 or later.

This software uses [semantic versioning](http://semver.org), as defined by version 2.0.0 of the SemVer
standard.

## Settings
This mod can be configured quite a bit. You can change HUD bar appearance, offsets, ordering, and more.
Use the advanced settings menu in Luanti for detailed configuration.

## Troubleshooting

### Rendering issues with the HUD bars

If the HUD bars look strange and you have any of the following problems:

* The bars do not get “filled” correctly
* Text too large or too small
* Stuff is weirdly offset

Then try the following (one after the other, until the problem is resolved):

* Make sure to use the latest Luanti version
* Make sure your settings `gui_scaling` and `hud_scaling` are equal
* Use a different font
* Use a different font size

If the problem persists, then this might just be due to a longstanding bug in this mod, see: <https://codeberg.org/Wuzzy/minetest_hudbars/issues/1>

## API
The API is used to add your own custom HUD bars.
Documentation for the API of this mod can be found in `API.md`.

## Legal
### License of source code
Author: Wuzzy (2015)

Also: This mod was forked from the “Better HUD” [hud] mod by BlockMen.

Translations:

* German: Wuzzy
* Portuguese: BrunoMine
* Turkish: admicos
* Dutch: kingoscargames
* Italian: Hamlet
* Malay: muhdnurhidayat
* Russian: Imk
* Spanish: wuniversales
* French: syl
* Ukrainian: FromKaniv
* Chinese (Simplified): w0rr1z

This program is free software. It comes without any warranty, to
the extent permitted by applicable law. You can redistribute it
and/or modify it under the terms of the MIT License.

### Licenses of textures

* `hudbars_icon_health.png`—celeron55 (CC BY-SA 3.0), modified by BlockMen
* `hudbars_bgicon_health.png`—celeron55 (CC BY-SA 3.0), modified by BlockMen
* `hudbars_icon_breath.png`—kaeza (MIT License), modified by BlockMen, modified again by Wuzzy
* `hudbars_bgicon_breath.png`—based on previous image, edited by Wuzzy (MIT License)
* `hudbars_bar_health.png`—Wuzzy (MIT License)
* `hudbars_bar_breath.png`—Wuzzy (MIT License)
* `hudbars_bar_background.png`—Wuzzy (MIT License)

### License references

* [CC-BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/)
* [MIT License](https://opensource.org/licenses/MIT)
