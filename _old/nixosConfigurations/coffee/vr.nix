{ config, pkgs, ... }:
{
  boot.kernelPatches = [
    {
      name = "amdgpu-ignore-ctx-privileges";
      patch = pkgs.fetchpatch {
        name = "cap_sys_nice_begone.patch";
        url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
        hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
      };
    }
  ];

  services.monado = {
    enable = true;
    defaultRuntime = true; # Register as default OpenXR runtime
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  my.scripts.nx.rebuild.postRebuildActions = ''
    if [[ ! -e ~/.local/share/monado/hand-tracking-models ]]; then
      echo Fixing hand tracking for monado VR
      mkdir -p ~/.local/share/monado
      cd ~/.local/share/monado
      git clone https://gitlab.freedesktop.org/monado/utilities/hand-tracking-models
      systemctl --user try-restart monado.service
    fi
  '';

  # To do the quick room setup when steamVR is being a bitch:
  # Go into X11 (steamVR doesn't work on gnome-wayland)
  # Maybe start steamvr if the next step is not working
  # Put the headset and controllers in the center of your play space.
  # Next, open two terminal windows with /home/user/.local/share/Steam/steamapps/common/SteamVR/bin/linux64 as the working directory. In one window, run the following command. This command will start the SteamVR server and generate pose data.
  # LD_LIBRARY_PATH=$(pwd) steam-run ./vrcmd --pollposes
  # In the second terminal window, run the following command. This command will perform a similar function to the Quick Calibration method described above.
  # LD_LIBRARY_PATH=$(pwd) steam-run ./vrcmd --resetroomsetup
  # Use Ctrl+C in the first terminal window to stop the SteamVR server.

  systemd.user.services.monado.environment = {
    STEAMVR_LH_ENABLE = "1";
    XRT_COMPOSITOR_COMPUTE = "1";
  };

  # environment.systemPackages = [
  # ];

  home-manager.users.${config.my.user.name} =
    { config, ... }:
    {
      home.packages = [
        pkgs.opencomposite
        pkgs.bs-manager
        pkgs.wlx-overlay-s

        (pkgs.writeScriptWithDeps {
          name = "vr";

          deps = [ ];

          text = ''
            #!/usr/bin/env bash
            systemctl --user restart monado.service
            eval "wlx-overlay-s" &>/dev/null &
          '';
        })
      ];

      xdg.configFile."openxr/1/active_runtime.json".source =
        "${pkgs.monado}/share/openxr/1/openxr_monado.json";

      xdg.configFile."openvr/openvrpaths.vrpath".text = ''
        {
          "config": [ "${config.xdg.dataHome}/Steam/config" ],
          "external_drivers": null,
          "jsonid": "vrpathreg",
          "log": [ "${config.xdg.dataHome}/Steam/logs" ],
          "runtime": [ "${pkgs.opencomposite}/lib/opencomposite" ],
          "version": 1
        }
      '';
    };
}
