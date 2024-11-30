#!/usr/bin/env bash

BLUE='\033[1;34m'
PURPLE='\033[1;35m'
RESET='\033[0m'

checkfile() {
	if [[ -L $@ ]]; then
		TARGET=$(readlink -f $@)
		echo -e "${PURPLE}Symlink points to ->\n${BLUE}${TARGET}${RESET}"

		checkfile $TARGET
	elif [[ -d $@ ]]; then
		echo -e "${PURPLE}Directory listing:${RESET}"

		ls -Fhsla --color=always
	elif [[ -f $@ ]]; then
		echo -e "${PURPLE}File contents:${RESET}"

		highlight -O ansi --force $@
	else
		echo "$@ is not valid"
		exit 1
	fi
}

if [[ $# -eq 0 ]]; then
	checkfile .
else
	checkfile $@
fi
