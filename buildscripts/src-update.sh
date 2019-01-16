#!/bin/bash

if [ -n "$2" ]; then
	cd "$2" # update given directory only
else
	cd "$(dirname $0)"/../../mods_src
fi

VERBOSE="$1"

GIT="git  --no-pager"
GITPARAM="--color=always"

if  [ "$VERBOSE" == "" ]; then
	VERBOSE=99
fi

# 0: just update relevant infos
# 1 display "branch -vaa" + local changes
# 2 display log on current branch
# 3 display "remote -v"


find . -name ".git" -type d | while read repo; do
	echo ''
	echo '--------------------------------------'
	echo "$(dirname "$repo")"
	echo '--------------------------------------'

	cd "$(dirname "$repo")"

# fetch all connected remotes
	for repo in $(git remote); do
		$GIT fetch "$repo" --prune
	done

# Display repo status in different verbosity
	if [ "$VERBOSE" -ge 1 ]; then
		$GIT branch -vva $GITPARAM
	fi

# create log range
	currentbranch="$(git branch | grep '^*' | sed 's:\* ::g')"
	remotebranch="$(git branch -avv | grep '^\*' | sed 's@.*\[@@g;s@[]:].*@@g' | grep -v '^\*')"

# print the log information
	if [ "$VERBOSE" -ge 2 ]; then
		if [ "$remotebranch" == "" ]; then
			echo '!!!!! No remote branch for' $currentbranch '!!!!!!'
		else
			echo $currentbranch '=>' "$remotebranch"
			$GIT log $currentbranch..$remotebranch
		fi

		if [ "$VERBOSE" -ge 3 ]; then
			$GIT remote -v
		fi
	fi

# Now pull+merge
# git pull. (from man git-pull: git pull is shorthand for git fetch followed by git merge FETCH_HEAD.)
	if [ ! "$remotebranch" == "" ]; then
		$GIT merge "$remotebranch"
	fi

# display local changes
	if [ $VERBOSE -ge 1 ]; then
		$GIT diff $GITPARAM #display local changes
	fi

	echo "last commit: $(git log -1 --format=%cd)"

	cd - >/dev/null
done


#########################################
# Find all ".hg" and pull them
find . -name ".hg" -type d | while read repo; do
	echo "$(dirname "$repo")"
	cd "$(dirname "$repo")"
	hg pull
	cd - >/dev/null
done

