{ pkgs, user, ... }:
{
  imports = [
    ./icons.nix
    ./keybinds.nix
  ];

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      # Discord fork that fixes streaming issues on linux
      vesktop
    ];
  };
}
