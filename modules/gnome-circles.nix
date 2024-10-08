{ pkgs, user, ... }:

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      dialect
      commit
      textpieces
      hieroglyphic
    ];
  };
}
