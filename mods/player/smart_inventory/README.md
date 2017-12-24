# smart_inventory

## Overview
A fast Minetest inventory with focus on a great number of items and big screens. The special feature of this inventory is the dynamic classification filters that allow fast searching and browsing trough available items and show relevant invormations only to the user.

The mod is organized in multiple pages, each page does have own focus and follow own vision.

## Crafting page
![Screenshot](https://github.com/bell07/minetest-smart_inventory/blob/master/screenshot_crafting.png)
The vision is to not affect the gameplay trough crafting helpers. The dynamic search helper display currently relevant craft recipes only based on inventory content by default.
- Contains the usual player-, and crafting inventory
- Additional view of "craftable items" based on players inventory content
- Dynamic grouping of craftable items for better overview
- Lookup field to get all recipes with item in it - with filter for revealed items if the doc system is used
- Search field - with filter for revealed items if the doc system is used
- Compress - use the stack max size in inventory
- Sweep - move content of crafting inventory back to the main inventory

### Optional support for other mods
doc_items - if the doc system is found the crafting page shows only items craftable by known (revealed) items.
A lookup button is available on already known items to jump to the documntation entry


## Creative page
![Screenshot](https://github.com/bell07/minetest-smart_inventory/blob/master/screenshot_creative.png)
The vision is to get items fast searchable and gettable
- 3 dynamic filters + text search field for fast items search
- Sort out "mass"-groups to a special "Shaped" group
- just click to the item to get it in inventory
- cleanup of inventory trough "Trash" field
- clean whole inventory trough "Trash all" button
- save and restore inventory content in 3x save slots

## Player page
![Screenshot](https://github.com/bell07/minetest-smart_inventory/blob/master/screenshot_player.png)
The vision is to get all skins and player customizations visual exposed.

### 3d_armor
In creative mode there are all armor items available for 3d_armor support. The players inventory is not used in this mode. In survival only the armor from players inventory is shown.
Supported version: current stable 0.4.8

### skins
tested only with my fork https://github.com/bell07/minetest-skinsdb
But it should be work with any fork that uses skins.skins[] and have *_preview.png files

## Doc page
![Screenshot](https://github.com/bell07/minetest-smart_inventory/blob/master/screenshot_doc.png)
The vision is to get all ingame documentation available in a fast way. So navigation from crafting page is possible directly to the doc_item entry
The doc and doc_items mods required to get the page


## Dependencies: 
Screen size at least 1024x768 / big screen. On my mobile with "full HD" it does not work.
Minetest stable 0.4.15 or newer
default mod (some graphics are used from this mod)



## Settings
```
#If enabled, the mod will show alternative human readable filterstrings if available.
smart_inventory_friendly_group_names (Show “friendly” filter grouping names) bool true

#List of groups defined for special handling of "Shaped nodes" (Comma separated).
#Items in this groups ignores the "not_in_inventory" group and are moved to separate "Shaped" category
smart_inventory_shaped_groups (List of groups to be handled as separate) string carpet,door,fence,stair,slab,wall,micro,panel,slope,dye

#If enabled, the the mod does not replace other inventory mods.
#The functionality is provided in a workbench.
smart_inventory_workbench_mode (Use workbench instead of players inventory) bool false
```

License: [LGPL-3](https://github.com/bell07/minetest-smart_inventory/blob/master/LICENSE)
Textures:
  - Workbench: WTFPL (credits: to xdecor project)
  - Buttons: WTFPL (credits to Stix (Minetest-forum))
