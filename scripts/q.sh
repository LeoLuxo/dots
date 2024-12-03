#!/usr/bin/env bash

ERROR='\033[0;31m'
INFO='\033[1;97m'
DIR='\033[1;94m'
FILE='\033[1;95m'
SYMLINK='\033[0;33m'
RESET='\033[0m'

checkfile() {
	echo -e "${FILE}File ${INFO}$(realpath "$1")${RESET}"
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
	echo -e "${DIR}Directory ${INFO}$(realpath "$1")${RESET}"
	tree -a -L 1 --dirsfirst -h -v "$1"
}

checkpath() {
	if [[ -L $1 ]]; then
		target="$(readlink -f $1)"
		echo -e "${SYMLINK}$1${RESET} -> ${SYMLINK}${target}${RESET}"

		if [[ -d $target ]]; then
			checkdir "$target"
		elif [[ -f $target ]]; then
			checkfile "$target"
		else
			echo "${ERROR}Target of the symlink does not exist or is invalid${RESET}"
			exit 1
		fi
	elif [[ -d $1 ]]; then
		checkdir "$1"
	elif [[ -f $1 ]]; then
		checkfile "$1"
	else
		echo "${ERROR}Path '$1' does not exist or is invalid${RESET}"
		exit 1
	fi
}

if [[ $# -eq 0 ]]; then
	checkpath .
else
	checkpath "$*"
fi
