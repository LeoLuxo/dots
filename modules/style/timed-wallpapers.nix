{ pkgs, user, ... }:
{
  home-manager.users.${user} = {
    home.packages = with pkgs; [ wallutils ];
  };

  nixpkgs.overlays = [
    (final: prev: {
      wallutils = prev.wallutils.overrideAttrs (
        finalAttrs: oldAttrs: {
          installPhase =
            (oldAttrs.installPhase or "")
            + ''
              cp scripts/heic-install $out
            '';
        }
      );
    })
  ];

}
