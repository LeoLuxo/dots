{
  pkgs,
  user,
  directories,
  ...
}:
{
  imports = with directories.modules; [ dev.coq ];

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      coqPackages.iris
    ];
  };

  nixpkgs.overlays =

    [
      (
        final: prev:
        let
          inherit (prev.coqPackages) overrideScope' callPackage;
        in
        {
          coqPackages = overrideScope' (
            self: super: {
              # Add iris coq package
              iris = callPackage ./iris-coq.nix { };
            }
          );
        }
      )
    ];
}
