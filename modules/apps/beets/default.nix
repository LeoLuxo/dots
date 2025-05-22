{
  pkgs,
  constants,
  extraLib,
  ...
}:

let
  inherit (constants) user;
  inherit (extraLib) writeScriptWithDeps;
in

{
  home-manager.users.${user} = {
    home.packages = [
      (writeScriptWithDeps {
        name = "beet";

        deps = [ pkgs.beets ];

        text = ''
          #!/usr/bin/env bash
          beet --config ${./beets-config.yaml} "$@"
        '';
      })
    ];
  };
}
