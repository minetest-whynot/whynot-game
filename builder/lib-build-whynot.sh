function process_update_mods {
  #
  # Modify as needed
  # ================
  # Associative list of repositories that point to non-default branch
  #
  declare -A BRANCHES=(
    [minetest_game/minetest_game]=origin/stable-5 # Stay on stable version
    [flora_ores/farming]=0b06c7cd450c5ec9a76b3c22a9c57f06e4f8a7c2 # freeze due to incompatibility with milk buckets
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

      git --no-pager merge $branch

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
          $RSYNC $exclusionlist $childmod/ $DSTPATH/$childname/
        done
      else
        $RSYNC $exclusionlist $SRC/$subm/ $DSTPATH/$modname/
      fi

      local CHOOSECOMMIT=''
      IFS= read -r -p 'Commit now? [Y/n] ' CHOOSECOMMIT < /dev/tty
      if [[ "$CHOOSECOMMIT" = "Y" ||  "$CHOOSECOMMIT" = "y" || "$CHOOSECOMMIT" = "" ]]; then
        cd $STARTDIR
        git add $PROJ
        git reset $LOG
        git --no-pager commit -m "Update $modname from upstream."
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

	if ! [ -d "$DST"/"$group" ]; then
		mkdir "$DST"/"$group"
	fi
	if ! [ -e "$DST"/"$group"/modpack.conf ]; then
		touch "$DST"/"$group"/modpack.conf
	fi

	for mod in ${sync_list[@]}; do
		if [ -d "$mod" ] && [ -z "$(in_excluded "$(basename $mod)")" ]; then
			echo "Process repo $mod"
			cd "$mod"
			 # Search 0-2 levels down for git reporistory.
			 # The root should not be reached because at least 3 levels (builder/mods_src/group)
			if [ -e ".git" ] || [ -e "../.git" ] || [ -e "../../.git" ]; then
				GIT_REPO="$(git remote -v | grep '\(fetch\)' )"
				if [ -z "$(in_git_repositories "$GIT_REPO")" ]; then
					echo '' >> "$LOG"
					echo "$GIT_REPO" >> "$LOG"
					git branch --format '%(HEAD) %(objectname) %(subject)' | grep '^[*]' >> "$LOG"
					git_repositories=(${git_repositories[@]} "$GIT_REPO")
				fi
			else
				echo '' >> "$LOG"
				echo "Embedded into game repository:" >> "$LOG"
			fi

			echo "Mod: $mod" >> "$LOG"
			cd - >/dev/null
			$RSYNC $excluded_string "$SRC"/"$mod" "$DST"/"$group"/
		fi
	done
}
