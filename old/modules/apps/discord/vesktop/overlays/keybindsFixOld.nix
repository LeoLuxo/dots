{ ... }:
{
  # Overlay to patch global keybinds
  # TODO: Remove when the PR is merged
  # https://github.com/Vencord/Vesktop/pull/609/
  nixpkgs.overlays = [
    (final: prev: {
      vesktop = prev.vesktop.overrideAttrs (
        finalAttrs: oldAttrs: {
          # patches = [
          #   (prev.fetchpatch {
          #     url = "https://patch-diff.githubusercontent.com/raw/Vencord/Vesktop/pull/609.patch";
          #     hash = "sha256-UaAYbBmMN3/kYVUwNV0/tH7aNZk32JnaUwjsAaZqXwk=";
          #   })
          # ];

          # Patching isn't working because the nixpkgs version is behind, so just replace the entire source with the PR repo
          src = prev.fetchFromGitHub {
            owner = "PolisanTheEasyNick";
            repo = "Vesktop";
            rev = "99a74cf328a864d395bec0b52bd09427433d7aea";
            hash = "sha256-ai2CdTUJGbcdFRR2AxkEFga30a3Cy1DrVdHQs/F1Ak0=";
          };

          # Make sure the dependencies get updated as well
          pnpmDeps = prev.pnpm_9.fetchDeps {
            inherit (finalAttrs)
              pname
              version
              src
              patches
              ;
            hash = "sha256-xn3yE2S6hfCijV+Edx3PYgGro8eF76/GqarOIRj9Tbg=";
          };
        }
      );
    })
  ];
}
