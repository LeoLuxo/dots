{ pkgs, user, ... }:
{
  imports = [
    ./icons.nix
    ./keybinds-fix.nix
    ./settings.nix
  ];

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      # Discord fork that fixes streaming issues on linux
      vesktop
    ];
  };
}
