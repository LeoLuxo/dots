#!/usr/bin/env bash

# nx-rebuild is supposed to populate the $NX_DCONF_DIFF file
# but create it as empty just in case
mkdir --parents "$(dirname "$NX_DCONF_DIFF")" && touch "$NX_DCONF_DIFF"

# Show the dconf diff since the last rebuild
difft $NX_DCONF_DIFF <(dconf dump /)
