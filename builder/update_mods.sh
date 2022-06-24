#!/bin/bash

MODDIR="mods_src"
export PROJ="$(realpath $(dirname $0)/..)"   # Absolute path
export SRC="$PROJ"/builder/$MODDIR
export DST="$PROJ"/mods
export LOG="$PROJ"/mod_sources.txt
export DEFAULTBR="origin/HEAD"
export RSYNC="rsync -aq --delete --delete-excluded --exclude=.git*"
#export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }' # for debugging


function process_update_mods {

  #
  # Modify as needed
  # ================
  # Associative list of repositories that point to non-default branch
  #
  declare -A BRANCHES=(
    [minetest_game]=origin/stable-5 # Stay on stable version
  )

  #
  # Modify as needed
  # ================
  # Associative list of modpacks with excluded modules
  #
  declare -A EXCLUDED=(
    [minetest_game/minetest_game]='--exclude=farming --exclude=env_sounds --exclude=mtg_craftguide'
    [player/3d_armor]='--exclude=3d_armor_ip --exclude=3d_armor_ui'
    [mesecons/mesecons]='--exclude=mesecons_lucacontroller --exclude=mesecons_commandblock --exclude=mesecons_detector --exclude=mesecons_fpga --exclude=mesecons_gates --exclude=mesecons_hydroturbine --exclude=mesecons_luacontroller --exclude=mesecons_microcontroller --exclude=mesecons_stickyblocks'
    [tools/flight]='--exclude=jetpack --exclude=wings'
    [decor/homedecor_modpack]='--exclude=itemframes --exclude=homedecor_3d_extras --exclude=homedecor_inbox'
    [decor/home_workshop_modpack]='--exclude=computers --exclude=home_workshop_machines'
    [decor/mydoors]='--exclude=my_garage_door --exclude=my_saloon_doors --exclude=my_sliding_doors'
  )

  local commit=$1
  local subm=$2
  # ignore local branch=$(echo "$3" | tr -d '()')

  local STARTDIR=$(pwd)
  cd $subm
  echo -n "Processing $subm... "

  local branch="origin/HEAD"
  if [ ${BRANCHES[$subm]+_} ]; then
    branch=${BRANCHES[$subm]}
  fi

  local current=$(git rev-parse --verify --quiet $branch) #> /dev/null

  if [ "$commit" != "$current" ]; then
    echo ''
    git log $commit..$current

    local CHOOSEDIFF=''
    IFS= read -r -p 'View full diff? [y/N] ' CHOOSEDIFF < /dev/tty
    if [[ "$CHOOSEDIFF" = "Y" ||  "$CHOOSEDIFF" = "y" ]]; then
      git diff $commit..$current
    fi

    local CHOOSEMERGE=''
    IFS= read -r -p 'Merge all changes? [y/N] ' CHOOSEMERGE < /dev/tty
    if [[ "$CHOOSEMERGE" = "Y" ||  "$CHOOSEMERGE" = "y" ]]; then

      git merge $branch

      local group=$(dirname $subm)
      local modname=$(basename $subm)
      local DSTPATH="$DST/$group"

      mkdir -p $DSTPATH
      touch "$DSTPATH/modpack.conf"

      local exclusionlist=''
      if [ ${EXCLUDED[$subm]+_} ]; then
        exclusionlist=${EXCLUDED[$subm]}
      fi

      if [[ -e "$SRC/$subm/modpack.txt" || -e "$SRC/$subm/modpack.conf" || "$modname" == "minetest_game" ]]; then
        for childmod in `find $SRC/$subm -mindepth 1 -maxdepth 1 -type d`; do
          local childname=$(basename $childmod)
          $RSYNC "$exclusionlist" "$childmod/" "$DSTPATH/$childname/"
        done
      else
        $RSYNC "$exclusionlist" "$SRC/$subm/" "$DSTPATH/$modname/"
      fi

      local CHOOSECOMMIT=''
      IFS= read -r -p 'Commit now? [Y/n] ' CHOOSECOMMIT < /dev/tty
      if [[ "$CHOOSECOMMIT" = "Y" ||  "$CHOOSECOMMIT" = "y" || "$CHOOSECOMMIT" = "" ]]; then
        cd $STARTDIR
        git add $PROJ
        git commit -m "Update $modname from upstream."
        cd $subm
      fi

    fi
  else
    echo 'No changes.'
  fi

  echo '' >> "$LOG"
  echo `git remote -v | grep '\(fetch\)'` >> "$LOG"
  git branch --format '%(HEAD) %(objectname) %(subject)' | grep '^[*]' >> "$LOG"
  echo "Mod: $subm" >> "$LOG"
}
export -f process_update_mods


####################
# Start of script
####################

mkdir -p "$DST"
cd "$SRC"

# Overwrite old log
>"$LOG"

echo -n "Updating local repository..."
#git fetch --all --prune --prune-tags --tags --recurse-submodules=yes --quiet --job 4
echo " done."
echo -n "Updating submodules..."
git submodule update --init --recursive --quiet --jobs 4
echo " done."

echo "Process updates of submodules..."
git submodule status | xargs -P 1 -n 3 bash -c 'process_update_mods "$@"' _
