{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.musnix.nixosModules.musnix
  ];

  my.packages = with pkgs; [
    playerctl
    pulsemixer
    qpwgraph
    easyeffects
    helvum
    pavucontrol
    alsa-scarlett-gui
  ];

  my.user.extraGroups = [ "audio" ];

  my.keybinds =
    let
      getIdForDevice = device: "pw-cli ls \"${device}\" | grep -Poi '(?<=id )\\d+' ";
      setDefaultOutputDevice = device: ''
        id=$(${getIdForDevice device})
        wpctl set-default $id
      '';

      linkGXLeft = device: ''pw-link "gx_head_fx:out_0" "${device}:playback_FL" '';
      linkGXRight = device: ''pw-link "gx_head_fx:out_1" "${device}:playback_FR" '';

      linkGX = device: ''
        ${linkGXLeft device}
        ${linkGXRight device}
      '';
      unlinkGX = device: ''
        ${linkGXLeft device} --disconnect || true
        ${linkGXRight device} --disconnect || true\
      '';
    in
    {
      # I got the binding "ids" from here: https://www.reddit.com/r/linuxquestions/comments/r9w8yh/disable_function_keys_beyond_f12/

      "Toggle audio to speakers" = {
        binding = "XF86Launch6"; # F15
        command = ''
          # Set default output device to speakers using wireplumber
          ${setDefaultOutputDevice "alsa_output.usb-Focusrite_Scarlett_2i2_USB_Y8DBJHF253DDF2-00.HiFi__Line1__sink"}

          # Link guitarix and outputs via pipewire directly
          ${linkGX "Scarlett 2i2 USB"}
          ${unlinkGX "ALC1220 Analog"}
        '';
      };

      "Toggle audio to headphones" = {
        binding = "XF86Launch5"; # F14
        command = ''
          # Set default output device to headphones using wireplumber
          ${setDefaultOutputDevice "alsa_output.pci-0000_0c_00.6.analog-stereo"}

          # Link guitarix and outputs via pipewire directly
          ${linkGX "ALC1220 Analog"}
          ${unlinkGX "Scarlett 2i2 USB"}
        '';
      };
    };

  musnix = {
    enable = true;
    # kernel.realtime = true;
  };

  home-manager.users.${config.my.user.name} = {
    services = {
      playerctld.enable = true;
      # easyeffects = {
      #   enable = true;
      # };
    };
  };

  services.pulseaudio.enable = false;

  # security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;

    extraConfig = {
      # Low latency config for pipewire
      pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 64;
          "default.clock.min-quantum" = 64;
          "default.clock.max-quantum" = 256;
        };
      };

      # Low latency config for pulseaudio applications
      pipewire-pulse."92-low-latency" = {
        "context.properties" = [
          {
            name = "libpipewire-module-protocol-pulse";
            args = { };
          }
        ];
        "pulse.properties" = {
          "pulse.min.req" = "64/48000";
          "pulse.default.req" = "256/48000";
          "pulse.max.req" = "256/48000";
          "pulse.min.quantum" = "64/48000";
          "pulse.max.quantum" = "256/48000";
        };
        "stream.properties" = {
          "node.latency" = "256/48000";
          "resample.quality" = 1;
        };
      };
    };

    wireplumber = {
      enable = true;
      extraConfig = {
        "52-mic-pro-audio"."monitor.alsa.rules" = [
          {
            matches = [ { "device.name" = "alsa_input.usb-Anua_Mic_CM_900_Anua_Mic_CM_900-00"; } ];
            actions.update-props."device.profile" = "pro-audio";
          }
        ];
      };
      extraScripts = { };
    };
  };

}
