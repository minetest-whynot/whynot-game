#!/bin/bash

PROJ="$(realpath $(dirname $0)/..)"   # Absolute path
SRC="$PROJ"/builder/mods_src/
DST="$PROJ"/mods/            # Subgame mods
LOG="$PROJ"/mod_sources.txt
GIT="git --no-pager"
GITPARAM="--color=always"
RSYNC="rsync -a --info=NAME --delete --exclude=.git --exclude=.gitignore"

export LC_ALL="C"

! [ -e "$DST" ] && mkdir "$DST"

source "$PROJ"/builder/lib-build-whynot.sh
cd "$SRC" # for proper resolving the '*'

# Remove old log
rm "$LOG" 2>/dev/null

## Sync minetest_game
# exclude env_sounds => Tenplus1/ambience is used
# exclude farming =>Tenplus1/farming is used
# exclude mtg_craftguide => sfcraftguide is used
# exclude player_api => bell07/player_api_modpack is used

mod_install minetest_game --exclude=farming --exclude=env_sounds --exclude=mtg_craftguide minetest_game/mods/*

mod_install libs

mod_install player --exclude=3d_armor --exclude=smart_sfinv_modpack
mod_install player --exclude=3d_armor_ip --exclude=3d_armor_ui player/3d_armor/*
mod_install player player/smart_sfinv_modpack/*

mod_install ambience

mod_install flora_ores
mod_install mapgen

mod_install tools --exclude=flight --exclude=maidroid

mod_install tools flight/flyingcarpet
mod_install tools maidroid/maidroid*

mod_install decor --exclude=homedecor_modpack --exclude=home_workshop_modpack --exclude=mydoors

mod_install decor decor/homedecor_modpack/building_blocks #grate and marble in recipes
# no computers - I use laptop mod
mod_install decor decor/homedecor_modpack/fake_fire
# no inbox, itemframes
mod_install decor decor/homedecor_modpack/lavalamp
## the homedecor blob was in whynot, therefore applied all at the first
## Next step is to check each mod for whynot rules
# no 3d_extras
mod_install decor decor/homedecor_modpack/homedecor_bathroom
mod_install decor decor/homedecor_modpack/homedecor_bedroom
mod_install decor decor/homedecor_modpack/homedecor_books
mod_install decor decor/homedecor_modpack/homedecor_climate_control
mod_install decor decor/homedecor_modpack/homedecor_clocks
mod_install decor decor/homedecor_modpack/homedecor_cobweb
mod_install decor decor/homedecor_modpack/homedecor_common
mod_install decor decor/homedecor_modpack/homedecor_doors_and_gates
mod_install decor decor/homedecor_modpack/homedecor_electrical
mod_install decor decor/homedecor_modpack/homedecor_electronics
mod_install decor decor/homedecor_modpack/homedecor_exterior
mod_install decor decor/homedecor_modpack/homedecor_fences
mod_install decor decor/homedecor_modpack/homedecor_foyer
mod_install decor decor/homedecor_modpack/homedecor_furniture
mod_install decor decor/homedecor_modpack/homedecor_furniture_medieval
mod_install decor decor/homedecor_modpack/homedecor_gastronomy
mod_install decor decor/homedecor_modpack/homedecor_kitchen
mod_install decor decor/homedecor_modpack/homedecor_laundry
mod_install decor decor/homedecor_modpack/homedecor_lighting
mod_install decor decor/homedecor_modpack/homedecor_misc
mod_install decor decor/homedecor_modpack/homedecor_office
mod_install decor decor/homedecor_modpack/homedecor_pictures_and_paintings
mod_install decor decor/homedecor_modpack/homedecor_plasmascreen
mod_install decor decor/homedecor_modpack/homedecor_roofing
mod_install decor decor/homedecor_modpack/homedecor_seating
mod_install decor decor/homedecor_modpack/homedecor_tables
mod_install decor decor/homedecor_modpack/homedecor_trash_cans
mod_install decor decor/homedecor_modpack/homedecor_wardrobe
mod_install decor decor/homedecor_modpack/homedecor_windows_and_treatments

mod_install decor decor/home_workshop_modpack/home_vending_machines
mod_install decor decor/home_workshop_modpack/home_workshop_misc

mod_install decor decor/mydoors/my_castle_doors
mod_install decor decor/mydoors/my_cottage_doors
mod_install decor decor/mydoors/my_default_doors
mod_install decor decor/mydoors/my_door_wood
mod_install decor decor/mydoors/my_fancy_doors
mod_install decor decor/mydoors/my_future_doors
mod_install decor decor/mydoors/my_hidden_doors
mod_install decor decor/mydoors/my_misc_doors
mod_install decor decor/mydoors/my_old_doors
mod_install decor decor/mydoors/my_old_doors

mod_install food --exclude=food_modpack

mod_install food food/food_modpack/food food/food_modpack/food_basic

mod_install mesecons --exclude=mesecons_lucacontroller \
					--exclude=mesecons_commandblock \
					--exclude=mesecons_detector \
					--exclude=mesecons_fpga \
					--exclude=mesecons_gates \
					--exclude=mesecons_hydroturbine \
					--exclude=mesecons_luacontroller \
					--exclude=mesecons_microcontroller \
					--exclude=mesecons_stickyblocks \
			mesecons/mesecons/*

mod_install mobs_redo mobs_redo/*
