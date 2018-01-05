#!/bin/sh

PROJ=~/Projekte/minetest-whynot-subgame-updater

DST="$PROJ"/whynot-git/ # Subgame staging 

# mods sources
SRC="$PROJ"/mods_src/

RSYNC="rsync -a --info=NAME --delete --exclude=.git --exclude=.gitignore"

## Sync minetest_game
echo ' ##### sync minetest_game'
$RSYNC --exclude=modpack.txt --exclude=farming "$SRC"/minetest_game/mods/* "$DST"/mods/minetest_game
touch "$DST"/mods/minetest_game/modpack.txt

echo ' ##### sync player mods'
$RSYNC "$SRC"/player/* "$DST"/mods/player/

echo ' ##### sync weather / ambience'
$RSYNC --exclude=modpack.txt "$SRC"/weather/* "$DST"/mods/ambience/
$RSYNC "$SRC"/ambienceplus/* "$DST"/mods/ambience/

echo ' ##### sync ambienceplus'
$RSYNC --exclude=modpack.txt "$SRC"/ambienceplus/* "$DST"/mods/ambience/

echo ' ##### sync 3d_armor'
$RSYNC "$SRC"/3d_armor/3d_armor "$DST"/mods/player/
$RSYNC "$SRC"/3d_armor/3d_armor_stand "$DST"/mods/player/
$RSYNC "$SRC"/3d_armor/shields "$DST"/mods/player/
$RSYNC "$SRC"/3d_armor/wieldview "$DST"/mods/player/

echo ' ##### sync flora+ores'
$RSYNC "$SRC"/flora-ores/* "$DST"/mods/flora_ores/

echo ' ##### sync mapgen'
$RSYNC "$SRC"/mapgen/* "$DST"/mods/mapgen/

echo ' ##### sync tools'
$RSYNC "$SRC"/tools/* "$DST"/mods/tools/

echo ' ##### sync flying tools'
$RSYNC "$SRC"/flight/flyingcarpet "$DST"/mods/tools/

echo ' ##### sync decor misc mods'
$RSYNC "$SRC"/decor/* "$DST"/mods/decor/

echo ' ##### sync decor_home pack'
$RSYNC "$SRC"/homedecor_modpack/homedecor_i18n "$DST"/mods/decor/
$RSYNC "$SRC"/homedecor_modpack/homedecor "$DST"/mods/decor/
$RSYNC "$SRC"/homedecor_modpack/building_blocks "$DST"/mods/decor/ #grate and marble in recipes
$RSYNC "$SRC"/homedecor_modpack/chains "$DST"/mods/decor/
$RSYNC "$SRC"/homedecor_modpack/fake_fire "$DST"/mods/decor/
$RSYNC "$SRC"/homedecor_modpack/lavalamp "$DST"/mods/decor/
$RSYNC "$SRC"/homedecor_modpack/lrfurn "$DST"/mods/decor/
$RSYNC "$SRC"/homedecor_modpack/plasmascreen "$DST"/mods/decor/

echo ' ##### sync mydoors pack'
$RSYNC "$SRC"/mydoors/my_castle_doors "$DST"/mods/decor/
$RSYNC "$SRC"/mydoors/my_cottage_doors "$DST"/mods/decor/
$RSYNC "$SRC"/mydoors/my_default_doors "$DST"/mods/decor/
$RSYNC "$SRC"/mydoors/my_door_wood "$DST"/mods/decor/
$RSYNC "$SRC"/mydoors/my_fancy_doors "$DST"/mods/decor/
$RSYNC "$SRC"/mydoors/my_future_doors "$DST"/mods/decor/
$RSYNC "$SRC"/mydoors/my_hidden_doors "$DST"/mods/decor/
$RSYNC "$SRC"/mydoors/my_misc_doors "$DST"/mods/decor/
$RSYNC "$SRC"/mydoors/my_old_doors "$DST"/mods/decor/
$RSYNC "$SRC"/mydoors/my_old_doors "$DST"/mods/decor/

echo ' ##### sync food'
$RSYNC "$SRC"/food_modpack/food "$DST"/mods/food/
$RSYNC "$SRC"/food_modpack/food_basic "$DST"/mods/food/
$RSYNC "$SRC"/food/* "$DST"/mods/food/


################### Game related files ########################
echo ' ### Sync game related files'
$RSYNC "$SRC"/whynot_compat "$DST"/mods/
$RSYNC "$PROJ"/game_src/minetest.conf "$DST"/
$RSYNC "$PROJ"/game_src/game.conf "$DST"/

################### Create git logfile ########################
echo '### Update git-sources.txt'
GIT_LOGFILE="$DST"/buildscripts/git-sources.txt
rm "$GIT_LOGFILE"
touch "$GIT_LOGFILE"
find "$SRC" -name ".git" -type d | while read repo; do
   cd "$(dirname "$repo")"
	git remote -v | grep fetch >> "$GIT_LOGFILE"
	git branch -vv | grep '^[*]' >> "$GIT_LOGFILE"
	echo '' >> "$GIT_LOGFILE"
 
   cd - >/dev/null
done

echo '### store used shell scripts'
$RSYNC "$PROJ"/*.sh "$DST"/buildscripts
