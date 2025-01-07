#!/usr/bin/env bash

# Based on the script by 0atman / No boilerplate
# https://gist.github.com/0atman/1a5133b842f929ba4c1e195ee67599d5

# Makes bash error-out if any exit code is non-zero
set -e

# Some color
INFO='\033[1;94m'
SUCCESS='\033[1;92m'
ERROR='\033[1;91m'
RESET='\033[0m'

# Force sudo early and cache it so I don't have to enter password later in the script
sudo echo -e "${INFO}Running as superuser${RESET}"

# cd to our config dir
pushd $NX_DOTS 1>/dev/null

rebuild() {
	# Autoformat nix files
	nixfmt --quiet . ||
		(
			nixfmt --check . || true
			echo -e "${ERROR}Formatting failed!"
			return 1
		)

	# Nix can't see non-git added files
	git add .

	# Shows changes
	changes=$(
		git --no-pager diff --staged --name-status .
	)
	echo -e "${INFO}Files changed:${RESET}\n${changes}"

	# Run pre-rebuild actions
	echo -e "${INFO}Running pre-rebuild actions...${RESET}"
	source $NX_PRE_REBUILD

	echo -e "${INFO}NixOS Rebuilding...${RESET}"

	# Rebuild, and if errors occur make sure to exit
	# tarball-ttl 0 forces the tarball cache to be stale and re-downloaded
	# warn dirty disables the goddamn git dirty tree message
	nh os switch . --no-nom \
		-- --impure \
		--option tarball-ttl 0 \
		--option warn-dirty false \
		"$@" ||
		return 1

	# Run post-rebuild actions
	echo -e "${INFO}Running post-rebuild actions...${RESET}"
	source $NX_POST_REBUILD

	# Reload the wallpaper to avoid having to logout
	# systemctl --user restart wallutils-timed.service || systemctl --user restart wallutils-static.service || true

	# Get current generation metadata
	current_gen="${HOSTNAME} $(nixos-rebuild list-generations | grep current | sed s/\*//g)"
	echo -e "${INFO}Current generation: ${RESET}\n${current_gen}"

	# RE-add any auto-generated files
	git add ./config

	# Early return if no changes are detected
	if git diff --staged --quiet .; then
		echo -e "${INFO}No changes detected, not committing."
		return 0
	fi

	# Shows NEW changes
	changes=$(
		git --no-pager diff --staged --name-status .
	)
	echo -e "${INFO}New files changed:${RESET}\n${changes}"

	# Commit all changes with the generation metadata
	echo -e "${INFO}Committing...${RESET}"
	git commit -m "$current_gen" -m "$changes" 1>/dev/null

	echo -e "${INFO}Pushing...${RESET}"
	# Git push is stoopid and writes everything to stderr
	git push &>/dev/null
}

rebuild
status=$?

# Revert staging in case an error happened
git restore --staged --quiet . || true

# Back to where we were
popd 1>/dev/null

if [[ $status -eq 0 ]]; then
	echo -e "${SUCCESS}DONE!${RESET}"
else
	echo -e "${ERROR}Rebuild cancelled${RESET}"
fi
