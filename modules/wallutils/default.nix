{ pkgs, user, ... }:
{
  imports = [
    ./service.nix
    ./fix-dark-mode.nix
  ];

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      wallutils
    ];
  };
}
