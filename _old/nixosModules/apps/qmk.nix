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
  environment.systemPackages = with pkgs; [
    qmk
  ];
}
