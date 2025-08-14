{
  pkgs,
  ...
}:

{
  imports = [ ../../modules/apps/joycons.nix ];

  my.packages = [
    pkgs.ryubing
  ];
}
