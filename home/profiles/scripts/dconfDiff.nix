{
  config,
  pkgs,
  ...
}:

let
  variables = {
    DCONF_DIFF = "${config.home.homeDirectory}/.nx/dconf_diff";
  };
in
{
  home.sessionVariables = variables;

  home.packages = [
    (pkgs.writeScriptWithDeps {
      name = "dconf-diff";
      text = ''
        #!/usr/bin/env bash

        # nx-rebuild is supposed to populate the $DCONF_DIFF file
        # but create it as empty just in case
        mkdir --parents "$(dirname "${variables.DCONF_DIFF}")" && touch "${variables.DCONF_DIFF}"

        # Show the dconf diff since the last rebuild
        difft ${variables.DCONF_DIFF} <(dconf dump /)
      '';
      deps = with pkgs; [
        dconf
        difftastic
      ];
    })
  ];
}
