#!/bin/bash

PROJ="$(realpath $(dirname $0)/..)" # Subgame dir (..)

# Repositories points to non-default branch
declare -A BRANCHES=(
	[minetest_game]=origin/stable-5 # Stay on stable version
	[homedecor_modpack]=63ad77e2    # No updates. See Bug #49
	[libs/craftguide]=58e4516       # No updates. See Bug #53
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
