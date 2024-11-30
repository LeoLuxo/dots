#!/usr/bin/env bash

BLUE='\033[1;34m'
PURPLE='\033[1;35m'
RESET='\033[0m'

echo $@
echo $1

file() {
	echo file arg: $1
	echo -e "${PURPLE}File contents:${RESET}"
	highlight -O ansi --force $1
}

dir() {
	echo dir arg: $1
	echo -e "${PURPLE}Directory listing:${RESET}"
	ls -Fhsla --color=always $1
}

checkfile() {
	echo checkfile arg: $1

	if [[ -L $1 ]]; then
		TARGET="$(readlink -f $1)"
		echo -e "${PURPLE}Symlink points to ->\n${BLUE}${TARGET}${RESET}"

		if [[ -d $TARGET ]]; then
			dir $TARGET
		elif [[ -f $TARGET ]]; then
			file $1
		else
			echo "Target of the symlink does not exist or is invalid"
			exit 1
		fi
	elif [[ -d $1 ]]; then
		dir $1
	elif [[ -f $1 ]]; then
		file $1
	else
		echo "Path '$1' does not exist or is invalid"
		exit 1
	fi
}

if [[ $# -eq 0 ]]; then
	checkfile .
else
	checkfile "$*"
fi
