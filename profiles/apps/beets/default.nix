{
  pkgs,
  user,
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
  environment.systemPackages = [
    (pkgs.writeScriptWithDeps {
      name = "beet";

      deps = [
        package
        pkgs.flac
      ];

      text = ''
        #!/usr/bin/env bash
        beet --config "${./config.yaml}" "$@"
      '';
    })
  ];
}
