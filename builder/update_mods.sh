#!/bin/bash

PROJ="$(realpath $(dirname $0)/..)"   # Absolute path
SRC="$PROJ"/builder/mods_src/
DST="$PROJ"/mods/
LOG="$PROJ"/mod_sources.txt
DEFAULTBR="origin/HEAD"

# Repositories points to non-default branch
declare -A BRANCHES=(
	[minetest_game]=origin/stable-5 # Stay on stable version
	[libs/craftguide]=58e4516       # No updates. See Bug #53
)

function process_update_mods {
  commit=$1
  subm=$2
  branch=$(echo "$3" | tr -d '()')

  cd $subm
  git rev-parse --verify --quiet origin/master > /dev/null 
}
export -f process_update_mods

mkdir -p "$DST"
cd "$SRC"

# Remove old log
rm "$LOG" 2>/dev/null

echo -n "Updating local repository..."
#git fetch --all --prune --prune-tags --tags --recurse-submodules=yes --quiet --job 20
echo " done."
echo -n "Updating submodules..."
#git submodule update --init --recursive --quiet --jobs 8
echo " done."

echo "Process updates of submodules..."
git submodule status | xargs -t -P 1 -n 3 bash -c 'process_update_mods "$@"' _

exit

# Cleanup/delete unused mods

rm -r "$DST/minetest_game/farming"
rm -r "$DST/minetest_game/env_sounds"
rm -r "$DST/minetest_game/mtg_craftguide"

rm -r "$DST/player/3d_armor_ip"
rm -r "$DST/player/3d_armor_ui"

rm -r "$DST/mesecons/mesecons_lucacontroller"
rm -r "$DST/mesecons/mesecons_commandblock"
rm -r "$DST/mesecons/mesecons_detector"
rm -r "$DST/mesecons/mesecons_fpga"
rm -r "$DST/mesecons/mesecons_gates"
rm -r "$DST/mesecons/mesecons_hydroturbine"
rm -r "$DST/mesecons/mesecons_luacontroller"
rm -r "$DST/mesecons/mesecons_microcontroller"
rm -r "$DST/mesecons/mesecons_stickyblocks"