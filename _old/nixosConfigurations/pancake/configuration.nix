{
  pkgs,
  nixosModules,
  lib2,
  inputs,
  user,
  ...
}:

let
  inherit (lib2) enabled;
in
{
  imports = [
    # Include hardware stuff and kernel patches for surface pro 7
    # inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
  ];

  # hardware.microsoft-surface.kernelVersion = "longterm";

  # Extra packages that don't necessarily need an entire dedicated module
  environment.systemPackages = with pkgs; [
    styluslabs-write
  ];

  # wallpaper.image = inputs.wallpapers.dynamic."treeAndShore";

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
}
