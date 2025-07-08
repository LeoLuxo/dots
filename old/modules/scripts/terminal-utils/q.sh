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
	mime="$(file "$1" --mime)"

	if echo $mime | grep -q "charset=binary"; then
		# IS binary file, show file info
		echo -e "${FILE}Binary file ${INFO}$(realpath "$1")${RESET}\n"
		file "$1"

		if echo $mime | grep -q "image"; then
			# If image, additionally show preview
			viu --height 20 "$1"
		fi
	else
		# Is text, show contents
		echo -e "${FILE}Text file ${INFO}$(realpath "$1")${RESET}\n"
		highlight -O ansi --force "$1"
	fi

	# Set last dir for qq alias
	echo $(dirname $(realpath "$1")) >/tmp/Q_LAST_DIR
}

checkdir() {
	echo -e "${DIR}Directory ${INFO}$(realpath "$1")${RESET}\n"

	# Show directory tree
	tree -a -L $depth --dirsfirst -h -v "$1" -C

	# Set last dir for qq alias
	echo $(realpath "$1") >/tmp/Q_LAST_DIR
}

checkpath() {
	if [[ -L $1 ]]; then
		target="$(readlink $1)"
		echo -e "${SYMLINK}$1${RESET} -> ${SYMLINK}${target}${RESET}"
		checkpath "$target"
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
