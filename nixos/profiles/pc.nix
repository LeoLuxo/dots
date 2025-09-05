{ nixosProfiles, ... }:
{
  imports = [
    nixosProfiles.base
  ];

  # Setup the boot menu
  boot = {
    plymouth = {
      enable = true;
      # By default if theme=breeze, themePackages will include a nixos-themed version of breeze
      theme = "breeze";

      # themePackages = with pkgs; [
      #   # By default this would install all themes
      #   (adi1090x-plymouth-themes.override {
      #     selected_themes = [ "deus_ex" ];
      #   })
      # ];
    };

    # Enable "Silent Boot"
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 0;
  };
}
