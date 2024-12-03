#!/usr/bin/env bash

# This shebang runs nix-shell which then interpret the rest:
# it pulls in the packages bash, git and nixfmt
# and set bash as the interpreter
# https://stackoverflow.com/a/64599687

# Based on the script by 0atman / No boilerplate
# https://gist.github.com/0atman/1a5133b842f929ba4c1e195ee67599d5

# Makes bash error-out if any exit code is non-zero
set -e

# Some color
CYAN='\033[1;36m'
GREEN='\033[1;32m'
RESET='\033[0m'

# Force sudo early and cache it so I don't have to enter password later in the script
sudo echo -e "${CYAN}Running as superuser${RESET}"

# cd to our config dir
pushd $NX_REPO 1>/dev/null

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

# For some reason nix can't see non-git added files
git add .

# Shows changes
changes=$(
	git --no-pager diff --staged --name-status .
)
echo -e "${CYAN}Files changed:${RESET}\n${changes}"

echo -e "${CYAN}NixOS Rebuilding...${RESET}"

# Rebuild, and if errors occur make sure to exit
# tarball-ttl 0 forces the tarball cache to be stale and re-downloaded
# warn dirty disables the goddamn git dirty tree message
nh os switch . --no-nom \
	-- --impure \
	--option tarball-ttl 0 \
	--option warn-dirty false \
	"$@" ||
	(
		git restore --staged .
		exit 1
	)

# Get current generation metadata
current_gen="${HOSTNAME} $(nixos-rebuild list-generations | grep current | sed s/\*//g)"
echo -e "${CYAN}Current generation: ${RESET}\n${current_gen}"

# Save current dconf settings (for nx-dconf-diff)
dconf dump / >$DCONF_DIFF

# RE-add any auto-generated files
git add ./synced

# Shows NEW changes
changes=$(
	git --no-pager diff --staged --name-status .
)
echo -e "${CYAN}New files changed:${RESET}\n${changes}"

# Commit all changes with the generation metadata
echo -e "${CYAN}Committing...${RESET}"
git commit -m "$current_gen" -m "$changes" 1>/dev/null

echo -e "${CYAN}Pushing...${RESET}"
# Git push is stoopid and writes everything to stderr
git push &>/dev/null

# Back to where we were
popd 1>/dev/null

# Notify all OK!
echo -e "${GREEN}DONE!${RESET}"
# notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
