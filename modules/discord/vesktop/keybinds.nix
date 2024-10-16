{ user, ... }:
{
  programs.dconf.enable = true;

  home-manager.users.${user} = {
    dconf.settings = {
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/discord-mute/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/discord-deafen/"
        ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/discord-mute" = {
        binding = "<Super>m";
        command = "echo $XDG_RUNTIME_DIR; echo VCD_TOGGLE_SELF_MUTE >> $XDG_RUNTIME_DIR/vesktop-ipc";
        name = "Discord mute";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/discord-deafen" = {
        binding = "<Super><Shift>m";
        command = "echo VCD_TOGGLE_SELF_DEAF >> $XDG_RUNTIME_DIR/vesktop-ipc";
        name = "Discord deafen";
      };
    };
  };

  # Overlay to patch global keybinds
  # TODO: Remove when the PR is merged
  nixpkgs.overlays = [
    (final: prev: {
      vesktop = prev.vesktop.overrideAttrs (
        finalAttrs: oldAttrs: {
          # Patching isn't working for some reason so just replace the entire source with the PR repo
          src = prev.fetchFromGitHub {
            owner = "PolisanTheEasyNick";
            repo = "Vesktop";
            rev = "3a84dbc0d28a8152284d82004b1315e7fe03778a";
            hash = "sha256-i+i0oOLST72cMWwtSHJnVDaWojMA3g7TXGvBBewGBcE=";
          };

          # patches = [
          #   (prev.fetchpatch {
          #     url = "https://patch-diff.githubusercontent.com/raw/Vencord/Vesktop/pull/609.patch";
          #     hash = "sha256-UaAYbBmMN3/kYVUwNV0/tH7aNZk32JnaUwjsAaZqXwk=";
          #   })
          # ];

          # Make sure the dependencies get updated as well
          pnpmDeps = prev.pnpm_9.fetchDeps {
            inherit (finalAttrs)
              pname
              version
              src
              patches
              ;
            hash = "sha256-Y55CeMKXZALes7X8uwsnFI6QVExHU8AbvU/gxCvTLHs=";
          };
        }
      );
    })
  ];
}
