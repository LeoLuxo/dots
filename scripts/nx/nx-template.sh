#!/usr/bin/env bash

echo $1
echo "$NX_REPO#$1"
nix flake init -t "$NX_REPO#$1"
