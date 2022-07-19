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

OLDSTASHSIZE=$(git stash list | wc -l)
echo -n "Stashing uncommited changes..."
[[ $VERBOSITY == '--quiet' ]] && TMPV=$VERBOSITY || TMPV=''
git stash push $VERBOSITY --include-untracked -m "update_mod.sh: stashing uncommitted changes before updating mods"
NEWSTASHSIZE=$(git stash list | wc -l)
[[ $OLDSTASHSIZE -lt $NEWSTASHSIZE ]] && echo " done." || echo " nothing to stash."

echo -n "Updating local repository..."
git submodule sync $VERBOSITY
git fetch --all --prune --prune-tags --tags --recurse-submodules=yes $VERBOSITY --job 4
echo " done."
echo -n "Updating submodules..."
git submodule update --init --recursive $VERBOSITY --jobs 4
echo " done."

# Overwrite old log
>"$LOG"

echo "Process updates of submodules..."
git submodule status | xargs -P 1 -n 3 bash -c 'source "$PROJ"/builder/lib-config-whynot.sh; process_update_mods "$@"' _

# Update built-in mods (not submodules)
$RSYNC $SRC/libs/whynot_compat $DST/libs/
git diff --quiet -- $DST/libs/whynot_compat || git commit $VERBOSITY -m "Update whynot_compat" $DST/libs/whynot_compat

# Finalize mods update by commiting mod_sources.txt
git diff --quiet -- $LOG || git commit $VERBOSITY -m "Update mod_sources.txt" $LOG

if [[ $OLDSTASHSIZE -lt $NEWSTASHSIZE ]]; then
  echo -n "Restoring uncommited changes from stash..."
  git stash pop --index $VERBOSITY
  echo " done."
fi

echo ""
echo "Mods have been updated as per your selections."
echo "Please review your commits before pushing using: "
echo ""
echo "  git difftool origin/main"
echo ""