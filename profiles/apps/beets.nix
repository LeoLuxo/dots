{
  config,
  pkgs,
  lib2,
  user,
  ...
}:
let
  inherit (lib2.nixos) mkSyncedPath;
in

let
  beets = pkgs.unstable.beets.override {
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

  # age.secrets."beets/acoustID-key" = {
  #   owner = user;
  #   group = "users";
  #   mode = "400"; # read-only for owner
  # };

  # home-manager.users.${user} = {
  #   home.file.".config/beets/keys.yaml" = {
  #     text = ''
  #       acoustid.apikey: $(cat ${config.age.secrets."beets/acoustID-key".path})
  #     '';
  #     force = true;
  #   };
  # };

  system.activationScripts.beetsCopyKeys = ''
    cp --force "${config.age.secrets."beets/keys-yaml".path}" "/home/${user}/.config/beets/keys.yaml"
  '';

  environment.systemPackages = [
    (pkgs.writeScriptWithDeps {
      name = "beet";

      deps = [
        beets

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
