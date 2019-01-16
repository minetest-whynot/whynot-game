#!/bin/bash

LIB="$(realpath $(dirname $0))"  # Absolute path
PROJ="$(dirname $LIB)"           # Subgame dir (..)
SRC="$(dirname $PROJ)"/mods_src/ # mods sources (../..)
DST="$PROJ"/mods/                # Subgame mods
LOG="$PROJ"/mod_sources.txt

source "$LIB"/build-whynot.lib
cd "$SRC" # for proper resolving the '*'

## Sync minetest_game
mod_install minetest_game --exclude=farming --exclude=player_api minetest_game/mods/*

mod_install libs

mod_install player
mod_install player --exclude=skins player_api_modpack/* #skinsdb5 should be used, therefore skins masked

mod_install player 3d_armor/3d_armor_stand
mod_install player 3d_armor/shields
mod_install player 3d_armor/3d_armor_sfinv

mod_install player smart_sfinv_modpack/*

mod_install ambience

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

mod_install mesecons --exclude=mesecons_lucacontroller \
					--exclude=mesecons_commandblock \
					--exclude=mesecons_detector \
					--exclude=mesecons_fpga \
					--exclude=mesecons_gates \
					--exclude=mesecons_hydroturbine \
					--exclude=mesecons_luacontroller \
					--exclude=mesecons_microcontroller \
					--exclude=mesecons_stickyblocks \
			mesecons/*

mod_install mobs_redo mobs_redo/*
