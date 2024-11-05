#!/usr/bin/env bash

# Hard link nix store
nix-store --optimise

# Clean up old NixOS generations and garbage-collect the nix store
sudo nix-collect-garbage -d --delete-older-than 2d
