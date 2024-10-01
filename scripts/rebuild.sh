#!/usr/bin/env nix-shell
#!nix-shell -p bash git nixfmt-rfc-style
#!nix-shell -i bash

# This shebang runs nix-shell which then interpret the rest:
# it pulls in the packages bash, git and nixfmt
# and set bash as the interpreter
# https://stackoverflow.com/a/64599687

# Original script by 0atman / No boilerplate
# https://gist.github.com/0atman/1a5133b842f929ba4c1e195ee67599d5

# Makes bash error-out if any exit code is non-zero
set -e

# Some color
PURPLE='\033[1;35m'
GREEN='\033[1;32m'
RESET='\033[0m'

# Force sudo early and cache it so I don't have to enter password later in the script
sudo echo -e "${PURPLE}Running as superuser${RESET}"

# cd to our config dir
pushd ~/dots/ &>/dev/null

# Autoformat nix files
nixfmt --quiet . ||
	(
		nixfmt --check .
		echo "formatting failed!" && exit 1
	)

# Early return if no changes were detected
if git diff --quiet .; then
	echo "No changes detected, exiting."
	popd &>/dev/null
	exit 0
fi

# Shows changes
git --no-pager diff -U0 .

echo -e "${PURPLE}NixOS Rebuilding...${RESET}"

# For some reason nix can't see non-git added files
git add .

# Rebuild and log everything to a file
# On error, output simplified errors
sudo nixos-rebuild switch --show-trace --flake .#$USER &>rebuild.log ||
	(
		cat rebuild.log | grep --color error && (
			git restore --staged .
			exit 1
		)
	)

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep current | sed s/\*//g)

echo -e "${PURPLE}Current generation: ${RESET}${current}"
echo -e "${PURPLE}Committing...${RESET}"

# Commit all changes with the generation metadata
git commit -am "$current" &>/dev/null

echo -e "${PURPLE}Pushing...${RESET}"
git push &>/dev/null

# Back to where we were
popd &>/dev/null

# Notify all OK!
echo -e "${GREEN}DONE!${RESET}"
# notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
