{
  pkgs,
  musnix,
  constants,
  ...
}:

let
  inherit (constants) user;
in

{
  imports = [ musnix.nixosModules.musnix ];

  musnix = {
    enable = true;
    # kernel.realtime = true;
  };

  users.users.${user}.extraGroups = [ "audio" ];

  home-manager.users.${user} = {
    services = {
      playerctld.enable = true;
      # easyeffects = {
      #   enable = true;
      # };
    };
  };

  hardware.pulseaudio.enable = false;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
    # lowLatency = {
    #   enable = true;
    # };
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 64;
        "default.clock.min-quantum" = 64;
        "default.clock.max-quantum" = 64;
      };
    };
    wireplumber = {
      enable = true;
      extraConfig = {
        # "10-disable-camera" = {
        #   "wireplumber.profiles" = {
        #     main."monitor.libcamera" = "disabled";
        #   };
        # };
      };
      extraScripts = { };
    };

  };

  # Disable auto-adjusting of microphone volume from certain apps
  # services.pipewire.wireplumber.configPackages = [
  #   (pkgs.writeTextDir "share/wireplumber/main.lua.d/99-stop-microphone-auto-adjust.lua" ''
  #     table.insert(default_access.rules, {
  #       matches = {
  #         {
  #           { "application.process.binary", "=", "electron" },
  #           { "application.process.binary", "=", "webcord" },
  #           { "application.process.binary", "=", "vesktop" },
  #           { "application.process.binary", "=", "firefox" },
  #           { "application.process.binary", "=", "Chromium" },
  #           { "application.process.binary", "=", "Chromium input" }
  #         }
  #       },
  #       default_permissions = "rx",
  #     })
  #   '')
  # ];

  environment.systemPackages = with pkgs; [
    playerctl
    pulsemixer
    qpwgraph
    easyeffects
    helvum
    pavucontrol
    alsa-scarlett-gui
  ];

}
