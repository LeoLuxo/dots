#!/usr/bin/env bash

ERROR='\033[0;31m'
WARNING='\033[0;33m'
INFO='\033[1;97m'
DIR='\033[1;94m'
FILE='\033[1;95m'
SYMLINK='\033[0;33m'
RESET='\033[0m'

# Default depth of 1
depth=${DEPTH:-1}

QFILE="/tmp/Q_LAST_DIR_$(id -u)"
touch "$QFILE"
chmod 700 "$QFILE"

checkfile() {
	echo -e "${FILE}Permissions ${INFO}$(stat -c %A "$1")${RESET}"

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
	dirname $(realpath "$1") | tee "$QFILE" >/dev/null
}

checkdir() {
	echo -e "${DIR}Permissions ${INFO}$(stat -c %A "$1")${RESET}"
	echo -e "${DIR}Directory ${INFO}$(realpath "$1")${RESET}\n"

	# Show directory tree
	tree -a -L $depth --dirsfirst -h -v "$1" -C

	# Set last dir for qq alias
	realpath "$1" | tee "$QFILE" >/dev/null
}

checkpath() {
	if [[ -e $1 ]]; then
		if [[ ! -r $1 ]]; then
			# Is not readable by current user
			echo -e "${WARNING}Path '$1' is not readable by you, trying with sudo.${RESET}"
			# Disable qq for this time, as 1) when running as root we'll be writing to root's QFILE, and 2) we can't access root-permission dirs with cd as user anyway
			rm "$QFILE"
			exec sudo bash "$0" "$@"

		elif [[ -L $1 ]]; then
			# Is symlink
			target="$(readlink $1)"
			echo -e "${SYMLINK}$1${RESET} -> ${SYMLINK}${target}${RESET}"
			checkpath "$target"

		elif [[ -d $1 ]]; then
			# Is directory
			checkdir "$1"

		elif [[ -f $1 ]]; then
			# Is file
			checkfile "$1"

		else
			echo -e "${ERROR}Path '$1' cannot be read or is invalid${RESET}"
			exit 1
		fi

	else
		echo -e "${ERROR}Path '$1' does not exist${RESET}"
		exit 1
	fi
}

if [[ $# -eq 0 ]]; then
	checkpath .
else
	checkpath "$*"
fi
