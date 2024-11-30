#!/usr/bin/env bash

BLUE='\033[1;34m'
PURPLE='\033[1;35m'
RESET='\033[0m'

checkfile() {
	if [[ -L $1 ]]; then
		TARGET=$(readlink -f $1)
		echo -e "${PURPLE}Symlink points to ->\n${BLUE}${TARGET}${RESET}"

		checkfile $TARGET
	elif [[ -d $1 ]]; then
		echo -e "${PURPLE}Directory listing:${RESET}"

		ls -Fhsla
	elif [[ -f $1 ]]; then
		echo -e "${PURPLE}File contents:${RESET}"

		highlight -O ansi --force
	else
		echo "$1 is not valid"
		exit 1
	fi
}

checkfile $1
