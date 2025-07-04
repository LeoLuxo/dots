{
  config,
  pkgs,
  inputs,
  constants,
  extraLib,
  ...
}:

let

  inherit (extraLib) mkGlobalKeybind;
in

let
  getIdForDevice = device: "pw-cli ls \"${device}\" | grep -Poi '(?<=id )\\d+'";
in
{
  imports = [
    inputs.musnix.nixosModules.musnix

    # https://www.reddit.com/r/linuxquestions/comments/r9w8yh/disable_function_keys_beyond_f12/
    (mkGlobalKeybind {
      name = "Toggle audio to speakers";
      binding = "XF86Launch6"; # F15
      command = ''
        id=$(${getIdForDevice "alsa_output.usb-Focusrite_Scarlett_2i2_USB_Y8DBJHF253DDF2-00.HiFi__Line1__sink"})
        wpctl set-default $id

        # Link guitarix and outputs via pipewire directly
        pw-link "gx_head_fx:out_0" "Scarlett 2i2 USB:playback_FL"
        pw-link "gx_head_fx:out_1" "Scarlett 2i2 USB:playback_FR"
        pw-link --disconnect "gx_head_fx:out_0" "ALC1220 Analog:playback_FL" || true
        pw-link --disconnect "gx_head_fx:out_1" "ALC1220 Analog:playback_FR" || true
      '';
    })

    (mkGlobalKeybind {
      name = "Toggle audio to headphones";
      binding = "XF86Launch5"; # F14
      command = ''
        id=$(${getIdForDevice "alsa_output.pci-0000_0c_00.6.analog-stereo"})
        wpctl set-default $id

        # Link guitarix and outputs via pipewire directly
        pw-link "gx_head_fx:out_0" "ALC1220 Analog:playback_FL"
        pw-link "gx_head_fx:out_1" "ALC1220 Analog:playback_FR"
        pw-link --disconnect "gx_head_fx:out_0" "Scarlett 2i2 USB:playback_FL" || true
        pw-link --disconnect "gx_head_fx:out_1" "Scarlett 2i2 USB:playback_FR" || true
      '';
    })
  ];

  musnix = {
    enable = true;
    # kernel.realtime = true;
  };

  my.system.user.extraGroups = [ "audio" ];

  home-manager.users.${config.my.system.user.name} = {
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

  my.packages = with pkgs; [
    playerctl
    pulsemixer
    qpwgraph
    easyeffects
    helvum
    pavucontrol
    alsa-scarlett-gui
  ];

}
