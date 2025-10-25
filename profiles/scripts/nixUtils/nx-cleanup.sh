#!/usr/bin/env bash

sudo echo "Running as superuser"

sizeBefore=$(du -h -s /nix/store)

# Clean up old NixOS generations and garbage-collect the nix store
nh clean all --keep 10 --keep-since 30d
# sudo nix-collect-garbage -d --delete-older-than 2d

# Hard link nix store
sudo nix-store --optimise

sizeAfter=$(du -h -s /nix/store)

echo
echo "Before: $sizeBefore"
echo "Afer:   $sizeAfter"
