{
  pkgs,
  lib2,
  ...
}:
let
  inherit (lib2.nixos) mkSyncedPath;
in

let
  package = pkgs.beets.override {
    # pluginOverrides = {
    #   fetchartist = {
    #     enable = true;
    #     propagatedBuildInputs = [ (pkgs.callPackage ./beets-fetchartist.nix { }) ];
    #   };
    # };
  };
in
{
  imports = [
    (mkSyncedPath {
      target = "~/.config/beets/config.yaml";
      syncName = "beets/config.yaml";
    })
  ];

  environment.systemPackages = [
    (pkgs.writeScriptWithDeps {
      name = "beet";

      deps = [
        package

        pkgs.python313Packages.pyacoustid
        pkgs.chromaprint
        pkgs.ffmpeg
        pkgs.flac
        pkgs.imagemagick
      ];

      text = ''
        beet "$@"
      '';
    })
  ];
}
