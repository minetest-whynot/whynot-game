# minetest mod Backpacks
========================

Backpacks allow you to clean up space in your inventory.

Information
-----------

This mod must be named `backpacks` it featured to player a 
bag with shoulder straps that allow it to be carried on someone's back, 
or just simple bags to carried payer items.

![screenshot.png](screenshot.png)

Tech information
----------------

Adds backpacks made of wool and leather, that can **store anything but themselves** 
in an 16 slots inventory. The backpacks can only be accessed once they're placed. 
Picking them up preserves their contents. They obey regular protection rules.
Development is at [https://git.minetest.io/minenux/minetest-mod-backpacks](https://git.minetest.io/minenux/minetest-mod-backpacks) codeberg is only for private developers, 
if you want to contribute go to git.minetest.io as must be!

This mod started as a unification effors from forum original

https://forum.minetest.net/viewtopic.php?f=9&t=14579

The others mods similar are 

* Improved https://github.com/jastevenson303/backpacks that is just 
removed later in flavour of https://github.com/everamzah/backpacks
* Tenplus sfinv bags https://notabug.org/TenPlus1/sfinv_bags this only work in 
recent engine versions and lost spirit of block, showing a so detailed rounded bags
* Exile one at https://codeberg.org/Mantar/Exile/src/branch/master/mods/backpacks that 
provide the only feature to use modern api so inventory never get cleared and ambient influence

Unless all of those mods, this one is more simple and faster, and works with any version 
of the engine since 0.4 version.

#### Dependencies

* default
* wool
* dye

Optional dependences:

* mobs

#### Nodes Tools

They can be crafted by placing 8 wools of a same colour in a square around an empty craft grid centre.
If you use any combination of wools, a brow backpack will be the result.

This backpacks mod provides a large featured basic foods production of backpacks:

| Node name                      | Description name      |
| ------------------------------ | --------------------- |
| backpacks:backpack_wool_white  | White  Wool Backpack |
| backpacks:backpack_wool_grey   | Grey Wool Backpack |
| backpacks:backpack_wool_black  | Black Wool Backpack |
| backpacks:backpack_wool_red    | REd Wool Backpack |
| backpacks:backpack_wool_yellow | Yellow Wool Backpack |
| backpacks:backpack_wool_green  | Green Wool Backpack |
| backpacks:backpack_wool_cyan   | Cyan Wool Backpack |
| backpacks:backpack_wool_blue   | Blue Wool Backpack |
| backpacks:backpack_wool_brown  | Brown Wool Backpack |
| backpacks:backpack_wool_violet | Violet Wool Backpack |

## LICENSE

Textures were provided originaly by James Stevenson but there is no hints about

Code were started by James Stevenson and later continue by Tai Kedzierski https://github.com/taikedz

License code is GPL3+ check [LICENSE.txt](LICENSE.txt) file. This fork 
has one exception: You must put the url info in your copy and only allow this url to promotion:
[https://git.minetest.io/minenux/minetest-mod-backpacks](https://git.minetest.io/minenux/minetest-mod-backpacks)

Original code never get updates and get abandoned so we forked and **rethink the 
license terms take into consideration the bad promotion that have real minetest spirits, 
people only want to play and do not worry about constants changes and updates!**
