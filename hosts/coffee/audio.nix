{
  pkgs,
  inputs,
  constants,
  extraLib,
  ...
}:

let
  inherit (constants) user;
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
      '';
    })

    (mkGlobalKeybind {
      name = "Toggle audio to headphones";
      binding = "XF86Launch5"; # F14
      command = ''
        id=$(${getIdForDevice "alsa_output.pci-0000_0c_00.6.analog-stereo"})
        wpctl set-default $id
      '';
    })
  ];

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
          "default.clock.max-quantum" = 64;
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
          "pulse.default.req" = "64/48000";
          "pulse.max.req" = "64/48000";
          "pulse.min.quantum" = "64/48000";
          "pulse.max.quantum" = "64/48000";
        };
        "stream.properties" = {
          "node.latency" = "64/48000";
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
