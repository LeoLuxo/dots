#!/usr/bin/env bash

# Clean up old NixOS generations and garbage-collect the nix store
nh clean all --keep 10 --keep-since 7d
# sudo nix-collect-garbage -d --delete-older-than 2d

# Hard link nix store
sudo nix-store --optimise

du -h -s /nix/store
