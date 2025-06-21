{
  pkgs,
  config,
  extraLib,
  ...
}:

let
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
  ext.packages = [
    (writeScriptWithDeps {
      name = "beet";

      deps = [ package ];

      text = ''
        #!/usr/bin/env bash
        beet --config "${./config.yaml}" "$@"
      '';
    })
  ];
}
