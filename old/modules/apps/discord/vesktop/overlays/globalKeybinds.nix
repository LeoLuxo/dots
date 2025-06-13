{ ... }:
{
  # Overlay to patch global keybinds
  # TODO: Remove when the PR is merged
  # https://github.com/Vencord/Vesktop/pull/609/
  nixpkgs.overlays = [
    (
      final: prev:

      let
        pinnedPkgs = import (builtins.fetchTarball {
          url = "https://github.com/NixOS/nixpkgs/archive/482d1c3fffc3f3fa3ba8e5f0429c48dc525c9ecf.tar.gz";
        }) { };
      in
      {
        vesktop = pinnedPkgs.vesktop.overrideAttrs (
          finalAttrs: oldAttrs: {
            src = prev.fetchFromGitHub {
              owner = "PolisanTheEasyNick";
              repo = "Vesktop";
              rev = "99a74cf328a864d395bec0b52bd09427433d7aea";
              hash = "sha256-ai2CdTUJGbcdFRR2AxkEFga30a3Cy1DrVdHQs/F1Ak0=";
            };
          }
        );
      }
    )
  ];
}
