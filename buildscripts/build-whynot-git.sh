#!/bin/bash

PROJ=~/Projekte/minetest-whynot-subgame-updater

SRC="$PROJ"/mods_src/  # mods sources
DST="$PROJ"/whynot-git/mods/ # Subgame staging
LIB="$PROJ"/whynot-git/buildscripts/ # The bash updater lib
LOG="$PROJ"/whynot-git/mod_sources.txt

source "$LIB"/build-whynot.lib
cd "$SRC" # for proper resolving the '*'

## Sync minetest_game
mod_install minetest_game --exclude=farming minetest_game/mods/*

mod_install libs
mod_install player

mod_install ambience weather/* ambienceplus/*

mod_install player 3d_armor/3d_armor 3d_armor/3d_armor_stand 3d_armor/shields 3d_armor/wieldview

mod_install flora_ores
mod_install mapgen
mod_install tools

mod_install tools flight/flyingcarpet

mod_install decor
mod_install decor homedecor_modpack/homedecor_i18n
mod_install decor homedecor_modpack/homedecor
mod_install decor homedecor_modpack/building_blocks #grate and marble in recipes
mod_install decor homedecor_modpack/chains
mod_install decor homedecor_modpack/fake_fire
mod_install decor homedecor_modpack/lavalamp
mod_install decor homedecor_modpack/lrfurn
mod_install decor homedecor_modpack/plasmascreen

mod_install decor mydoors/my_castle_doors
mod_install decor mydoors/my_cottage_doors
mod_install decor mydoors/my_default_doors
mod_install decor mydoors/my_door_wood
mod_install decor mydoors/my_fancy_doors
mod_install decor mydoors/my_future_doors
mod_install decor mydoors/my_hidden_doors
mod_install decor mydoors/my_misc_doors
mod_install decor mydoors/my_old_doors
mod_install decor mydoors/my_old_doors

mod_install food food_modpack/food food_modpack/food_basic food/*
