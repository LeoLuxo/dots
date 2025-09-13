{
  lib,
  pkgs,
  lib2,
  ...
}:

let
  inherit (lib2)
    # mkQuickPatch
    mkSyncedPath
    ;
in

let
  vencord = pkgs.callPackage ./vencord.nix { };
  vesktop = pkgs.callPackage ./vesktop.nix { inherit vencord; };
in

{
  imports = [
    ./overlays/customIconsAndName.nix
    # ./overlays/globalKeybinds.nix

    # (mkQuickPatch {
    #   package = "vencord";
    #   patches = [
    #     ./patches/vencord-disable-update-check.patch
    #   ];
    # })

    # (mkQuickPatch {
    #   package = "vesktop";
    #   patches = [
    #     ./patches/vesktop-disable-update-check.patch

    #     # Vencord is being a little annoying so use our custom vencord and patch that to disable updates
    #     # (pkgs.substituteAll {
    #     #   src = ./patches/use-custom-vencord.patch;
    #     #   inherit (pkgs) vencord;
    #     # })
    #   ];
    # })

    # (mkSyncedPath {
    #   xdgPath = "vesktop/settings/settings.json";
    #   cfgPath = "vesktop/vencord.json";
    # })

    # (mkSyncedPath {
    #   xdgPath = "vesktop/settings.json";
    #   cfgPath = "vesktop/vesktop.json";
    # })

  ];

  # nixpkgs.overlays = [
  #   (
  #     final: prev:

  #     let
  #       pinnedPkgs = import (builtins.fetchTarball {
  #         url = "https://github.com/NixOS/nixpkgs/archive/fd27151c1e098faa7838bd569f6e5b5681b11ccf.tar.gz";
  #       }) { };
  #     in
  #     {
  #       vesktop = pinnedPkgs.vesktop.overrideAttrs (
  #         finalAttrs: oldAttrs: {
  #           src = prev.fetchFromGitHub {
  #             owner = "tuxinal";
  #             repo = "Vesktop";
  #             rev = "25963c66bed4643377044dea36e44ee68d13a3c8";
  #             hash = "sha256-7u3kmpgCWCj+0sSxCg8cylulWVv8oAW6H5jy8f4o+tQ=";
  #           };

  #           pnpmDeps = prev.pnpm_10.fetchDeps {
  #             inherit (finalAttrs)
  #               pname
  #               version
  #               src
  #               patches
  #               ;
  #             hash = "sha256-Xmcx0hWS5F4nEi83Hc6BvRu7Okw3LTwa7zGU3rJ+Udk=";
  #           };

  #           # patches = [
  #           #   (prev.fetchpatch {
  #           #     url = "https://patch-diff.githubusercontent.com/raw/Vencord/Vesktop/pull/326.patch";
  #           #     hash = "sha256-CTMETKHDdgj3mp/40Ps49GNC9gfRe1YhNF9KQ7IVxnE=";
  #           #   })
  #           # ];
  #         }
  #       );
  #     }
  #   )
  # ];

  my.defaultApps.communication = lib.mkDefault "vesktop";

  my.packages = [
    # (vesktop.override {
    #   withSystemVencord = true;
    #   inherit vencord;
    # })

  ];

  # my.keybinds = {
  #   "Discord mute" = {
  #     binding = "<Super>m";
  #     command = "echo \"VCD_TOGGLE_SELF_MUTE\" >> $XDG_RUNTIME_DIR/vesktop-ipc";
  #   };

  #   "Discord deafen" = {
  #     binding = "<Super><Shift>m";
  #     command = "echo \"VCD_TOGGLE_SELF_DEAF\" >> $XDG_RUNTIME_DIR/vesktop-ipc";
  #   };
  # };
}
