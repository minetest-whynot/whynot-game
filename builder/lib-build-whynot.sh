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
