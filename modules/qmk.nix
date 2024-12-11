{
  pkgs,
  constants,
  ...
}:

let
  inherit (constants) user;
in

{
  # https://nixos.wiki/wiki/Qmk

  # Gives access to the keyboard as non-root user
  hardware.keyboard.qmk.enable = true;

  # QMK CLI
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      qmk
    ];
  };
}
