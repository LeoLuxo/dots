#!/usr/bin/env nix-shell
#!nix-shell -p bash
#!nix-shell -i bash

# Clean up old NixOS generations and garbage-collect the nix store
sudo nix-collect-garbage -d --delete-older-than 2d
