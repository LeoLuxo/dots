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

let
  package = pkgs.beets.override {
    pluginOverrides = {
      # fetchartist = {
      #   enable = true;
      #   propagatedBuildInputs = [ (pkgs.callPackage ./beets-fetchartist.nix { }) ];
      # };
    };
  };
in
{
  home-manager.users.${user} = {
    home.packages = [
      (writeScriptWithDeps {
        name = "beet";

        deps = [ package ];

        text = ''
          #!/usr/bin/env bash
          beet --config "${./config.yaml}" "$@"
        '';
      })
    ];
  };
}
