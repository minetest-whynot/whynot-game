#!/bin/bash

#######################
### Debugging options
#######################
export VERBOSITY="--quiet" # "--quiet" or "--verbose"
#export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }' # for debugging, uncomment this line and use `bash -cx` below

######################
### Script constants
######################
MODDIR="mods_src"
export PROJ="$(realpath $(dirname $0)/..)"   # Absolute path
export SRC="$PROJ"/builder/$MODDIR
export DST="$PROJ"/mods
export LOG="$PROJ"/mod_sources.txt
export DEFAULTBR="origin/HEAD"
export RSYNC="rsync -a $VERBOSITY --delete --delete-excluded --exclude=.git*"

#####################
### Start of script
#####################

source "$PROJ"/builder/lib-build-whynot.sh

mkdir -p "$DST"
cd "$SRC"

# Overwrite old log
>"$LOG"

echo -n "Updating local repository..."
git submodule sync $VERBOSITY
git fetch --all --prune --prune-tags --tags --recurse-submodules=yes $VERBOSITY --job 4
echo " done."
echo -n "Updating submodules..."
git submodule update --init --recursive $VERBOSITY --jobs 4
echo " done."

echo "Process updates of submodules..."
git submodule status | xargs -P 1 -n 3 bash -c 'source "$PROJ"/builder/lib-config-whynot.sh; process_update_mods "$@"' _

mkdir -p $DST/libs/whynot_compat
$RSYNC $SRC/libs/whynot_compat/ $DST/libs/whynot_compat/
git diff --quiet $DST/libs/whynot_compat || git commit $VERBOSITY -m "Update whynot_compat" $DST/libs/whynot_compat

git diff --quiet $LOG || git commit $VERBOSITY -m "Update mod_sources.txt" $LOG

echo "Mods have been updated. Please review your commits before pushing using: "
echo ""
echo "  git difftool origin/main"