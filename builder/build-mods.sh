###########################
#!/bin/bash

#######################
### Debugging options
#######################
#export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }' # for debugging, uncomment this line and use `bash -cx` below

######################
### Script constants
######################
MODDIR="mods_src"
export PROJ="$(realpath $(dirname $0)/..)"   # Absolute path
export SRC="$PROJ"/builder/$MODDIR
export DST="$PROJ"/mods
export LOG="$PROJ"/mod_sources.txt

[[ $VERBOSITY == '--quiet' ]] && QUIETONLY=$VERBOSITY || QUIETONLY=''
[[ $VERBOSITY == '--verbose' ]] && VERBOSEONLY=$VERBOSITY || VERBOSEONLY=''
export QUIETONLY
export VERBOSEONLY

#####################
### Start of script
#####################

source "$PROJ"/builder/lib-build-whynot.sh

mkdir -p "$DST"
cd "$SRC"

# Overwrite old log
>"$LOG"

echo "Process submodules..."
git submodule status | xargs -P 1 -n 3 bash -c 'source "$PROJ"/builder/lib-config-whynot.sh; process_rebuild_mods "$@"' _

# Update built-in mods (not submodules)
$RSYNC $SRC/libs/whynot_compat $DST/libs/
git diff --quiet -- $DST/libs/whynot_compat || git commit $VERBOSITY -m "Update whynot_compat" $DST/libs/whynot_compat

# Finalize mods update by commiting mod_sources.txt
git diff --quiet -- $LOG || git commit $VERBOSITY -m "Update mod_sources.txt" $LOG
