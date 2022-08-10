function sync_mods_folder {

  local subm=$1
  local modname=$2

  local group=$(dirname $subm)
  local DSTPATH="$DST/$group"

  mkdir -p $DSTPATH

  local exclusionlist=''
  if [ ${EXCLUDED[$subm]+_} ]; then
    exclusionlist=${EXCLUDED[$subm]}
  fi

  if [[ -e "$SRC/$subm/modpack.txt" || -e "$SRC/$subm/modpack.conf" ]]; then

    for childmod in `find $SRC/$subm -mindepth 1 -maxdepth 1 -type d`; do
      local childname=$(basename $childmod)
      if [[ ${childname:0:1} != "." && !( $exclusionlist =~ $childname$ || $exclusionlist =~ $childname[^[:alnum:]_] ) ]]; then
        $RSYNC $exclusionlist $childmod/ $DSTPATH/$childname/
      else
        rm -rf $VERBOSEONLY $DSTPATH/$childname
      fi
    done

  elif [[ "$modname" = "minetest_game" ]]; then
    $RSYNC $exclusionlist $SRC/$subm/mods/ $DSTPATH/
  else
    $RSYNC $exclusionlist $SRC/$subm/ $DSTPATH/$modname/
  fi

  touch "$DSTPATH/modpack.conf"
}
export -f sync_mods_folder


function process_update_mods {

  local commit=$1
  local subm=$2
  # ignore local branch=$(echo "$3" | tr -d '()')

  pushd $subm > /dev/null
  echo -n "Processing $subm... "

  local branch="origin/HEAD"
  if [ ${BRANCHES[$subm]+_} ]; then
    branch=${BRANCHES[$subm]}
  fi

  local modname=$(basename $subm)

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
      git merge $VERBOSITY $branch
      sync_mods_folder $subm $modname

      local CHOOSECOMMIT=''
      IFS= read -r -p 'Commit now? [Y/n] ' CHOOSECOMMIT < /dev/tty
      if [[ "$CHOOSECOMMIT" = "Y" ||  "$CHOOSECOMMIT" = "y" || "$CHOOSECOMMIT" = "" ]]; then
        cd $PROJ
        git add $VERBOSEONLY .
        git reset $QUIETONLY $LOG
        git commit $VERBOSITY -m "Update $modname from upstream."
      fi
    fi

  else

    echo 'No changes.'
    sync_mods_folder $subm $modname
    cd $PROJ
    local DSTPATH="$DST/$subm"
    if [[ ! -e $DSTPATH ]]; then
      local group=$(dirname $subm)
      DSTPATH="$DST/$group"
    fi
    git add $VERBOSEONLY .
    git reset $QUIETONLY $LOG
    git diff --quiet --cached -- $DSTPATH || git commit $VERBOSITY -m "Rsync cleanup for $modname" -- $DSTPATH

  fi

  popd > /dev/null
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
