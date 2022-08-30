#!/bin/bash

#######################
#!/bin/bash

######################
### Script constants
######################
MODDIR="mods_src"
export PROJ="$(realpath $(dirname $0)/..)"   # Absolute path
export SRC="$PROJ"/builder/$MODDIR

#####################
### Start of script
#####################

source "$PROJ"/builder/lib-build-whynot.sh

cd "$SRC"

echo "Check submodules for updates..."
git submodule status | xargs -P 1 -n 3 bash -c 'source "$PROJ"/builder/lib-config-whynot.sh; check_update_mods "$@"' _
