{ pkgs, user, ... }:

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      guake
    ];
  };

  # Needs to start on boot
}
