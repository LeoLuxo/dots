#!/usr/bin/env nix-shell
#!nix-shell -p bash difftastic dconf
#!nix-shell -i bash

difft ~/.dconf_activation <(dconf dump /)
