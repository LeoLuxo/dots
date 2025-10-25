{
  config,
  pkgs,
  ...
}:

let
  DCONF_DIFF = "${config.home.homeDirectory}/.nx/dconf_diff";
in
{
  hm = {
    home.sessionVariables = { inherit DCONF_DIFF; };
    home.packages = [
      (pkgs.writeScriptWithDeps {
        name = "dconf-diff";
        text = ''
          #!/usr/bin/env bash

          # nx-rebuild is supposed to populate the $DCONF_DIFF file
          # but create it as empty just in case
          mkdir --parents "$(dirname "${DCONF_DIFF}")" && touch "${DCONF_DIFF}"

          # Show the dconf diff since the last rebuild
          difft ${DCONF_DIFF} <(dconf dump /)
        '';
        deps = with pkgs; [
          dconf
          difftastic
        ];
      })
    ];
  };

  # Add some post-build actions
  nx.postRebuildActions = ''
    # Save current dconf settings (for nx-dconf-diff)
    echo "Dumping dconf"
    mkdir --parents "$(dirname "${DCONF_DIFF}")" && touch "${DCONF_DIFF}"
    dconf dump / >"${DCONF_DIFF}"
  '';
}
