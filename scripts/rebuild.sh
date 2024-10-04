#!/usr/bin/env nix-shell
#!nix-shell -p bash git nixfmt-rfc-style
#!nix-shell -i bash

# This shebang runs nix-shell which then interpret the rest:
# it pulls in the packages bash, git and nixfmt
# and set bash as the interpreter
# https://stackoverflow.com/a/64599687

# Based on the script by 0atman / No boilerplate
# https://gist.github.com/0atman/1a5133b842f929ba4c1e195ee67599d5

# Makes bash error-out if any exit code is non-zero
set -e

# Some color
BLUE='\033[1;34m'
GREEN='\033[1;32m'
RESET='\033[0m'

# Force sudo early and cache it so I don't have to enter password later in the script
sudo echo -e "${BLUE}Running as superuser${RESET}"

# cd to our config dir
pushd /etc/nixos/dots 1>/dev/null

# Autoformat nix files
nixfmt --quiet . ||
	(
		nixfmt --check .
		echo "formatting failed!" && exit 1
	)

# Early return if no changes were detected
# if git diff --quiet .; then
# 	echo "No changes detected, exiting."
# 	popd &>/dev/null
# 	exit 0
# fi

# Shows changes
echo -e "${BLUE}Files changed:${RESET}"
git --no-pager diff --name-only .

echo -e "${BLUE}NixOS Rebuilding...${RESET}"

# For some reason nix can't see non-git added files
git add .

# Rebuild, and if errors occur make sure to exit
sudo nixos-rebuild switch --impure --flake .#$HOSTNAME "$@" ||
	(
		git restore --staged .
		exit 1
	)

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep current | sed s/\*//g)

echo -e "${BLUE}Current generation: ${RESET}${current}"
echo -e "${BLUE}Committing...${RESET}"

# Commit all changes with the generation metadata
git commit -am "$current" 1>/dev/null

echo -e "${BLUE}Pushing...${RESET}"
# Git push is stoopid and writes everything to stderr
git push &>/dev/null

# Back to where we were
popd 1>/dev/null

# Notify all OK!
echo -e "${GREEN}DONE!${RESET}"
# notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
