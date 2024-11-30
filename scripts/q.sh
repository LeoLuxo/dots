#!/usr/bin/env bash

ERROR='\033[1;31m'
INFO='\033[1;36m'
DIR='\033[1;34m'
FILE='\033[1;35m'
SYMLINK='\033[1;33m'
RESET='\033[0m'

checkfile() {
	echo -e "${INFO}File ${FILE}$1${RESET}"
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
	echo -e "${INFO}Directory ${DIR}$1${RESET}"
	ls -Fhsla --color=always "$1"
}

checkpath() {
	if [[ -L $1 ]]; then
		target="$(readlink -f $1)"
		echo -e "${SYMLINK}$1${RESET} -> ${SYMLINK}${target}${RESET}"

		if [[ -d $target ]]; then
			checkdir "$target"
		elif [[ -f $target ]]; then
			checkfile "$1"
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
