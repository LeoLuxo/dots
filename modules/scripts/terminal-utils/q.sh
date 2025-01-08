#!/usr/bin/env bash

ERROR='\033[0;31m'
INFO='\033[1;97m'
DIR='\033[1;94m'
FILE='\033[1;95m'
SYMLINK='\033[0;33m'
RESET='\033[0m'

# Default depth of 1
depth=${DEPTH:-1}

checkfile() {
	echo -e "${FILE}File ${INFO}$(realpath "$1")${RESET}"
	mime="$(file "$1" --mime)"

	if echo $mime | grep -q "charset=binary"; then
		# IS binary file, show file info
		file "$1"

		if echo $mime | grep -q "image"; then
			# If image, additionally show preview
			viu --height 20 "$1"
		fi
	else
		# Is text, show contents
		highlight -O ansi --force "$1"
	fi

	# Set last dir for qq alias
	Q_LAST_DIR=$(dirname $(realpath "$1"))
}

checkdir() {
	echo -e "${DIR}Directory ${INFO}$(realpath "$1")${RESET}"

	# Show directory tree
	tree -a -L $depth --dirsfirst -h -v "$1" -C

	# Set last dir for qq alias
	Q_LAST_DIR=$(realpath "$1")
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
			echo -e "${ERROR}Target of the symlink does not exist or is invalid${RESET}"
			exit 1
		fi
	elif [[ -d $1 ]]; then
		checkdir "$1"
	elif [[ -f $1 ]]; then
		checkfile "$1"
	else
		echo -e "${ERROR}Path '$1' does not exist or is invalid${RESET}"
		exit 1
	fi
}

if [[ $# -eq 0 ]]; then
	checkpath .
else
	checkpath "$*"
fi
