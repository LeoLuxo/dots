{ pkgs, user, ... }:
{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      wallutils
      wallutils-install
    ];
  };

  nixpkgs.overlays = [
    (final: prev: {
      wallutils-install = pkgs.writeShellScriptBin "heic-install" (
        builtins.readFile "${prev.wallutils.src}/scripts/heic-install"
      );
    })
  ];
}
