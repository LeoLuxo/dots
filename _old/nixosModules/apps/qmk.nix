{
  pkgs,
  config,
  ...
}:

{
  # https://nixos.wiki/wiki/Qmk

  # Gives access to the keyboard as non-root user
  hardware.keyboard.qmk.enable = true;

  # QMK CLI
  my.packages = with pkgs; [
    qmk
  ];
}
