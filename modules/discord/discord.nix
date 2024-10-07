{
  pkgs,
  user,
  ...
}:

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      # Discord fork that fixes streaming issues on linux
      vesktop
    ];
  };

  nixpkgs.overlays = [ (import ./overlay.nix) ];
}
