{ pkgs, user, ... }:
{
  imports = [
    ./module.nix
    ./fix-dark-mode.nix
  ];

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      wallutils
    ];
  };
}
