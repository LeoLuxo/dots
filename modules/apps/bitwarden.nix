{
  pkgs,
  constants,
  ...
}:
let
  inherit (constants) user;
in
{
  home-manager.users.${constants.user} = {
    home.packages = with pkgs; [ bitwarden-desktop ];
  };
}
