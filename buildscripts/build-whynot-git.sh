#!/bin/bash


# TODO1: GIT sources konsolidieren - 1x output pro Repo
# TODO2: excluded berücksichtigen
PROJ=~/Projekte/minetest-whynot-subgame-updater

DST="$PROJ"/whynot-git/ # Subgame staging 

# mods sources
SRC="$PROJ"/mods_src/
RSYNC="rsync -a --info=NAME --delete --exclude=.git --exclude=.gitignore"

LOGFILE="$DST"/mod_sources.txt
GIT="git  --no-pager"
GITPARAM="--color=always"

declare -a git_repositories
function in_git_repositories {
	for entry in "${git_repositories[@]}"; do
		[[ "$entry" == "$1" ]] && echo "found";
	done
}

function mod_install {

	group=$1
	shift

	declare excluded
	excluded_string=""
	while (( "$#" )); do
		if [ ${1:0:10} == '--exclude=' ]; then
			excluded=(${excluded[@]} ${1#--exclude=*})
			excluded_string="$excluded_string $1"
			shift
		else
			break
		fi
	done
#echo "excluded files:" ${excluded[@]}
	function in_excluded {
		for entry in "${excluded[@]}"; do
			[[ "$entry" == "$1" ]] && echo "found";
		done
	}

	declare sync_list
	if [ "$#" == "0" ]; then
		sync_list=("$group"/*)
	else
		sync_list=(${@})
	fi
#echo "sync_list:" ${sync_list[@]}

## TODO: filter sync_list by excluded
	for mod in ${sync_list[@]}; do
		if [ -d "$mod" ] && [ -z "$(in_excluded "$(basename $mod)")" ]; then
echo "Process repo $mod"
			cd "$mod"
			GIT_REPO="$(git remote -v | grep '\(fetch\)' )"
			if [ -z "$(in_git_repositories "$GIT_REPO")" ]; then
				echo '' >> "$LOGFILE"
				echo "$GIT_REPO" >> "$LOGFILE"
				git branch -vv | grep '^[*]' >> "$LOGFILE"
				git_repositories=(${git_repositories[@]} "$GIT_REPO")
			fi
			echo "Mod: $mod" >> "$LOGFILE"
			cd - >/dev/null
 			$RSYNC $excluded_string "$SRC"/"$mod" "$DST"/mods/"$group"/
		fi
	done
	
}

################################
cd "$SRC" # for proper resolving *
rm "$LOGFILE" 2>/dev/null

## Sync minetest_game
echo ' ##### sync minetest_game'
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

################### Game related files ########################
echo ' ### Sync game related files'
$RSYNC whynot_compat "$DST"/mods/
$RSYNC  "$PROJ"/game_src/minetest.conf "$DST"/
$RSYNC  "$PROJ"/game_src/game.conf "$DST"/
$RSYNC  "$PROJ"/game_src/menu "$DST"/
$RSYNC "$PROJ"/*.sh "$DST"/buildscripts
