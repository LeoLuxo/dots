#!/usr/bin/env bash

pushd ${NX_SECRETS}/secrets

export EDITOR=nano
export RULES="${NX_SECRETS}/secrets.nix"
agenix --edit $@

popd
