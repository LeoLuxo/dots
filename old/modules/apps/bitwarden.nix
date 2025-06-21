{
  pkgs,
  config,
  ...
}:
{
  my.packages = with pkgs; [ bitwarden-desktop ];
}
