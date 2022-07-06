#!/bin/bash

PROJ="$(realpath $(dirname $0)/..)" # Subgame dir (..)

# Repositories points to non-default branch
declare -A BRANCHES=(
	[minetest_game]=origin/stable-5 # Stay on stable version
	[flora_ores/farming]=0b06c7cd450c5ec9a76b3c22a9c57f06e4f8a7c2 # See https://github.com/minetest-whynot/whynot-game/issues/105
)


fgrep path "$PROJ"/.gitmodules | while read _ _ p; do
	ls -1 "$PROJ"/.git/modules/"$p"/refs/remotes/*/HEAD | sed 's:.*git/modules/builder/mods_src/::;s:/refs/remotes/: :g' | while read mod branch; do
		if [ -n "${BRANCHES[$mod]}" ]; then
			branch="${BRANCHES[$mod]}"
		fi

		echo '**************' "$mod"  -  "$branch" '***********************'
		cd "$PROJ"/builder/mods_src/"$mod"
		git fetch
		git --no-pager log HEAD.."$branch"
	done
done
