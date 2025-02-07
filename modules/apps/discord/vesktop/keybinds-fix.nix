{ cfg, lib, ... }:

let
  inherit (lib) modules;
in

{
  config = modules.mkIf cfg.enable {
    # Overlay to patch global keybinds
    # TODO: Remove when the PR is merged
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
              rev = "3a84dbc0d28a8152284d82004b1315e7fe03778a";
              hash = "sha256-i+i0oOLST72cMWwtSHJnVDaWojMA3g7TXGvBBewGBcE=";
            };

            # Make sure the dependencies get updated as well
            pnpmDeps = prev.pnpm_9.fetchDeps {
              inherit (finalAttrs)
                pname
                version
                src
                patches
                ;
              hash = "sha256-IIR1iz/Un24/cv/kexRaV0lqFmnEAgXsIyQYOZUCVqI=";
            };
          }
        );
      })
    ];
  };
}
