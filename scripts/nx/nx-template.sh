#!/usr/bin/env bash

nix flake init -t "$NX_REPO#$1"
