{
  pkgs,
  user,
  musnix,
  ...
}:
{
  imports = [ musnix.nixosModules.musnix ];

  musnix.enable = true;
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
    # extraConfig.pipewire = {
    #   pipewire-pulse = {
    #     "92-low-latency" = {
    #       context.modules = [
    #         {
    #           name = "libpipewire-module-protocol-pulse";
    #           args = {
    #             pulse.min.req = "32/48000";
    #             pulse.default.req = "32/48000";
    #             pulse.max.req = "32/48000";
    #             pulse.min.quantum = "32/48000";
    #             pulse.max.quantum = "32/48000";
    #           };
    #         }
    #       ];
    #       stream.properties = {
    #         node.latency = "32/48000";
    #         resample.quality = 1;
    #       };
    #     };
    #   };
    # };
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

  environment.systemPackages = with pkgs; [
    playerctl
    pulsemixer
    qpwgraph
  ];

}
