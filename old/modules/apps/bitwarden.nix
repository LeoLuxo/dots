{
  pkgs,
  ...
}:
{
  ext.packages = with pkgs; [ bitwarden-desktop ];
}
