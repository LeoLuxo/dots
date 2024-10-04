{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Discord fork that fixes streaming issues on linux
    vesktop
  ];
}
