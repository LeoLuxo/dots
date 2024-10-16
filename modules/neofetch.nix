{ pkgs, user, ... }:
{
  imports = [ ];
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      neofetch
    ];
  };
}
