#!/bin/bash

PROJ="$(realpath $(dirname $0)/..)"   # Absolute path
export LOG="$PROJ"/mod_sources.txt
export DEFAULTBR="origin/HEAD"
MODDIR="mods_src"
export SRC="$PROJ"/builder/$MODDIR
export DST="$PROJ"/mods
export RSYNC="rsync -a --info=NAME --delete --exclude=.git --exclude=.gitignore"

function process_update_mods {

  local commit=$1
  local subm=$2
  # ignore local branch=$(echo "$3" | tr -d '()')

  #
  # Associative list of repositories that point to non-default branch
  # Modify as needed
  #
  declare -A BRANCHES=(
    [minetest_game]=origin/stable-5 # Stay on stable version
  )

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

    local CHOOSEDIFF=""
    IFS= read -r -p "View full diff? [y/N] " CHOOSEDIFF < /dev/tty
    if [[ "$CHOOSEDIFF" = "Y" ||  "$CHOOSEDIFF" = "y" ]]; then
      git diff $commit..$current
    fi

    local CHOOSEMERGE=""
    IFS= read -r -p "Merge all changes? [Y/n] " CHOOSEMERGE < /dev/tty
    if [[ "$CHOOSEMERGE" = "Y" ||  "$CHOOSEMERGE" = "y" || "$CHOOSEMERGE" = "" ]]; then

      git merge $branch

      local group=$(dirname $subm)
      local DSTPATH="$DST/$group"
      if [ "$group" == "." ]; then
        DSTPATH="$DST"
      fi
      mkdir -p $DSTPATH
      if ! [ -e "$DSTPATH/modpack.conf" ]; then
        touch "$DSTPATH/modpack.conf"
      fi
      $RSYNC "$SRC"/"$subm" "$DSTPATH/"

      local CHOOSECOMMIT=""
      IFS= read -r -p "Commit now? [Y/n] " CHOOSECOMMIT < /dev/tty
      if [[ "$CHOOSECOMMIT" = "Y" ||  "$CHOOSECOMMIT" = "y" || "$CHOOSECOMMIT" = "" ]]; then
        cd $STARTDIR
        git commit -am "Update $subm from upstream."
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
git fetch --all --prune --prune-tags --tags --recurse-submodules=yes --quiet --job 4
echo " done."
echo -n "Updating submodules..."
git submodule update --init --recursive --quiet --jobs 4
echo " done."

echo "Process updates of submodules..."
git submodule status | xargs -P 1 -n 3 bash -c 'process_update_mods "$@"' _

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