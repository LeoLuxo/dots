#!/usr/bin/env bash

COLOR_ERROR='\033[0;31m'
COLOR_WARNING='\033[0;33m'
COLOR_INFO='\033[1;97m'
COLOR_DIR='\033[1;94m'
COLOR_FILE='\033[1;95m'
COLOR_SYMLINK='\033[0;33m'
COLOR_RESET='\033[0m'

# Default depth of 1
depth=${DEPTH:-1}

QFILE="/tmp/Q_LAST_DIR_$(id -u)"
touch "$QFILE"
chmod 600 "$QFILE"

perms() {
	echo "${2}Permissions ${COLOR_INFO}$(stat -c %A "$1") ($(stat -c %a "$1"))  ${2}Owner ${COLOR_INFO}$(stat -c "%U (%G)" "$1")${COLOR_RESET}"
}

checkfile() {
	mime="$(file "$1" --mime)"

	if echo $mime | grep -q "charset=binary"; then
		# IS binary file, show file info
		echo -e "${COLOR_FILE}Binary file ${COLOR_INFO}$(realpath "$1")  $(perms "$1" $COLOR_FILE)\n"
		file "$1"

		if echo $mime | grep -q "image"; then
			# If image, additionally show preview
			viu --height 20 "$1"
		fi
	else
		# Is text, show contents
		echo -e "${COLOR_FILE}Text file ${COLOR_INFO}$(realpath "$1")  $(perms "$1" $COLOR_FILE)\n"
		highlight -O ansi --force "$1"
	fi

	# Set last dir for qq alias
	dirname $(realpath "$1") | tee "$QFILE" >/dev/null
}

checkdir() {
	echo -e ""
	echo -e "${COLOR_DIR}Directory ${COLOR_INFO}$(realpath "$1")  $(perms "$1" $COLOR_DIR)\n"

	# Show directory tree
	tree -a -L $depth --dirsfirst -h -v "$1" -C

	# Set last dir for qq alias
	realpath "$1" | tee "$QFILE" >/dev/null
}

checkpath() {
	if [[ -e $1 ]]; then
		if [[ ! -r $1 ]]; then
			# Is not readable by current user
			echo -e "${COLOR_WARNING}Path '$1' is not readable by you (${USER}), trying with sudo.${COLOR_RESET}"
			# Disable qq for this time, as 1) when running as root we'll be writing to root's QFILE, and 2) we can't access root-permission dirs with cd as user anyway
			rm "$QFILE"
			exec sudo bash "$0" "$@"

		elif [[ -L $1 ]]; then
			# Is symlink
			target="$(readlink $1)"
			echo -e "${COLOR_SYMLINK}$1${COLOR_RESET} -> ${COLOR_SYMLINK}${target}${COLOR_RESET}"
			checkpath "$target"

		elif [[ -d $1 ]]; then
			# Is directory
			checkdir "$1"

		elif [[ -f $1 ]]; then
			# Is file
			checkfile "$1"

		else
			echo -e "${COLOR_ERROR}Path '$1' cannot be read or is invalid${COLOR_RESET}"
			exit 1
		fi

	else
		echo -e "${COLOR_ERROR}Path '$1' does not exist${COLOR_RESET}"
		exit 1
	fi
}

if [[ $# -eq 0 ]]; then
	checkpath .
else
	checkpath "$*"
fi
