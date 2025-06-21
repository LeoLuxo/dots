{
  pkgs,
  config,
  ...
}:
{
  ext.packages = with pkgs; [ bitwarden-desktop ];
}
