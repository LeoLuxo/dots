{ pkgs, user, ... }:
{
  imports = [
    ./icons-overlay.nix
    ./keybinds-overlay.nix
  ];

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      # Discord fork that fixes streaming issues on linux
      vesktop
    ];
  };
}
