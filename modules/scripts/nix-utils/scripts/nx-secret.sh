#!/usr/bin/env bash

pushd ${NX_SECRETS}/secrets

EDITOR=nano
RULES="${NX_SECRETS}/secrets.nix"
agenix --edit $@

popd
