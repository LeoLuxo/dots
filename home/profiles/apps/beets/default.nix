{
  pkgs,
  ...
}:

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
  home.packages = [
    (pkgs.writeScriptWithDeps {
      name = "beet";

      deps = [ package ];

      text = ''
        #!/usr/bin/env bash
        beet --config "${./config.yaml}" "$@"
      '';
    })
  ];
}
