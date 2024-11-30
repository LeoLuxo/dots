#!/usr/bin/env bash

RED='\033[1;31m'
CYAN='\033[1;36m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
RESET='\033[0m'

checkfile() {
	echo -e "${CYAN}File ${PURPLE}$1${RESET}"
	mime="$(file "$1" --mime)"

	if echo $mime | grep -q "charset=binary"; then
		file "$1"

		if echo $mime | grep -q "image"; then
			viu --height 20 "$1"
		fi
	else
		highlight -O ansi --force "$1"
	fi
}

checkdir() {
	echo -e "${CYAN}Directory ${BLUE}$1${RESET}"
	ls -Fhsla --color=always "$1"
}

checkpath() {
	if [[ -L $1 ]]; then
		target="$(readlink -f $1)"
		echo -e "${PURPLE}-> ${BLUE}${target}${RESET}"

		if [[ -d $target ]]; then
			checkdir "$target"
		elif [[ -f $target ]]; then
			checkfile "$1"
		else
			echo "${RED}Target of the symlink does not exist or is invalid${RESET}"
			exit 1
		fi
	elif [[ -d $1 ]]; then
		checkdir "$1"
	elif [[ -f $1 ]]; then
		checkfile "$1"
	else
		echo "${RED}Path '$1' does not exist or is invalid${RESET}"
		exit 1
	fi
}

if [[ $# -eq 0 ]]; then
	checkpath .
else
	checkpath "$*"
fi
