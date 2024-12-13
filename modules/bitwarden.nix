{
  pkgs,
  directories,
  constants,
  extra-libs,
  ...
}:
let
  inherit (constants) user;
  inherit (extra-libs) ;
in
{
  imports = with directories.modules; [ ];
  home-manager.users.${user} = {
    home.packages = with pkgs; [ bitwarden-desktop ];
  };
}
