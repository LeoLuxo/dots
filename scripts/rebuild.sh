#!/usr/bin/env bash

# Original script by 0atman / No boilerplate
# https://gist.github.com/0atman/1a5133b842f929ba4c1e195ee67599d5

sudo echo "Running as sudo"

# A rebuild script that commits on a successful build
set -e

# cd to our config dir
pushd ~/dots/ &>/dev/null

# Early return if no changes were detected (thanks @singiamtel!)
if git diff --quiet .; then
	echo "No changes detected, exiting."
	popd &>/dev/null
	exit 0
fi

# Autoformat nix files
# alejandra . &>/dev/null \
#   || ( alejandra . ; echo "formatting failed!" && exit 1)

# Shows changes
git diff -U0 .

echo "NixOS Rebuilding..."

# For some reason nix can't see non-git added files
git add .

# Rebuild and log everything to a file
# On error, output simplified errors
sudo nixos-rebuild switch --show-trace --flake .#$USER &>rebuild.log ||
	(cat rebuild.log | grep --color error && exit 1)

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep current)

# Commit all changes witih the generation metadata
git commit -am "$current"
git push

# Back to where we were
popd &>/dev/null

# Notify all OK!
# notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
