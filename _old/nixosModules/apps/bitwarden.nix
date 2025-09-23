{
  pkgs,
  config,
  ...
}:
{
  environment.systemPackages = with pkgs; [ bitwarden-desktop ];
}
