#!/usr/bin/env bash

# nx-rebuild is supposed to populate the $DCONF_DIFF file

# Show the dconf diff since the last rebuild
difft $DCONF_DIFF <(dconf dump /)
