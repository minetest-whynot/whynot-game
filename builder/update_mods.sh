#!/bin/bash

MODDIR="mods_src"
export PROJ="$(realpath $(dirname $0)/..)"   # Absolute path
export SRC="$PROJ"/builder/$MODDIR
export DST="$PROJ"/mods
export LOG="$PROJ"/mod_sources.txt
export DEFAULTBR="origin/HEAD"
export RSYNC="rsync -aq --delete --delete-excluded --exclude=.git*"
#export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }' # for debugging, use bash -cx

source "$PROJ"/builder/lib-build-whynot.sh

####################
# Start of script
####################

mkdir -p "$DST"
cd "$SRC"

# Overwrite old log
>"$LOG"

echo -n "Updating local repository..."
git submodule sync --quiet
git fetch --all --prune --prune-tags --tags --recurse-submodules=yes --quiet --job 4
echo " done."
echo -n "Updating submodules..."
git submodule update --init --recursive --quiet --jobs 4
echo " done."

echo "Process updates of submodules..."
git submodule status | xargs -P 1 -n 3 bash -c 'source "$PROJ"/builder/lib-config-whynot.sh; process_update_mods "$@"' _

git commit -m "update mod_sources.txt" "$LOG"
