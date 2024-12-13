{
  pkgs,
  constants,
  ...
}:
let
  inherit (constants) user;
in
{
  home-manager.users.${user} = {
    home.packages = with pkgs; [ bitwarden-desktop ];
  };
}
