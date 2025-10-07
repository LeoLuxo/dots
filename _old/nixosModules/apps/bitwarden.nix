{
  pkgs,
  config,
  user,
  ...
}:
{
  environment.systemPackages = with pkgs; [ bitwarden-desktop ];
}
