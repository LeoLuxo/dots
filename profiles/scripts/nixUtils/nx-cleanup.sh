#!/usr/bin/env bash

sudo echo "Running as superuser"

echo "Checking nix store size"
sizeBefore=$(du -h -s /nix/store)

echo "Cleaning up old NixOS generations and garbage-collecting the nix store"
sudo nh clean all --keep 10 --keep-since 30d
# sudo nix-collect-garbage -d --delete-older-than 2d

echo "Hard linking nix store"
sudo nix-store --optimise

echo "Checking nix store size"
sizeAfter=$(du -h -s /nix/store)

echo
echo "Before: $sizeBefore"
echo "Afer:   $sizeAfter"
