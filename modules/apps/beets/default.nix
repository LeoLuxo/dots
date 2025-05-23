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
    home.packages = [
      (pkgs.callPackage ./beets.nix { })
    ];
  };
}
