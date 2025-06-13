{ ... }:
{
  # Overlay to patch global keybinds
  # TODO: Remove when the PR is merged
  # https://github.com/Vencord/Vesktop/pull/326
  nixpkgs.overlays = [
    (final: prev: {
      vesktop = prev.vesktop.overrideAttrs (
        finalAttrs: oldAttrs: {
          # patches = [
          #   (prev.fetchpatch {
          #     url = "https://patch-diff.githubusercontent.com/raw/Vencord/Vesktop/pull/326.patch";
          #     hash = "sha256-UaAYbBmMN3/kYVUwNV0/tH7aNZk32JnaUwjsAaZqXwk=";
          #   })
          # ];

          # Nix is goddamn iritating and for some reason patching is not working at all :shrug:, so take the whole goddamn source of the fork
          src = prev.fetchFromGitHub {
            owner = "tuxinal";
            repo = "Vesktop";
            rev = "13199c22b869806afef924ed7bb0266c13062bb0";
            hash = "";
          };
        }
      );
    })
  ];
}
