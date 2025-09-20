{
  pkgs,
  lib,
  osConfig ? null,
  ...
}:
{
  home.packages = [
    # Only install steam if it's not already managed by nixos
    (lib.mkIf (lib.isAttrs osConfig && !osConfig.programs.steam.enable) pkgs.steam)

    pkgs.r2modman # A mod manager for Risk of Rain 2 and other Unity games.
    pkgs.joystickwake # Prevents screen sleep when playing games with a gamepad
  ];
}
