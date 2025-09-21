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

  systemd.user.services.monado.environment = {
    # STEAMVR_LH_ENABLE = "1";
    XRT_COMPOSITOR_COMPUTE = "1";
  };

  environment.systemPackages = [
    pkgs.opencomposite
    pkgs.bs-manager
    pkgs.wlx-overlay-s

    (pkgs.writeScriptWithDeps {
      name = "vr";

      deps = [ ];

      text = ''
        #!/usr/bin/env bash
        systemctl --user start monado.service
        # wlx-overlay-s --replace
      '';
    })
  ];

  home-manager.users.${config.my.user.name} =
    { config, ... }:
    {
      xdg.configFile."openxr/1/active_runtime.json".source =
        "${pkgs.monado}/share/openxr/1/openxr_monado.json";

      xdg.configFile."openvr/openvrpaths.vrpath".text = ''
        {
          "config" :
          [
            "${config.xdg.dataHome}/Steam/config"
          ],
          "external_drivers" : null,
          "jsonid" : "vrpathreg",
          "log" :
          [
            "${config.xdg.dataHome}/Steam/logs"
          ],
          "runtime" :
          [
            "${pkgs.opencomposite}/lib/opencomposite"
          ],
          "version" : 1
        }
      '';
    };
}
