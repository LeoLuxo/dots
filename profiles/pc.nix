{
  pkgs,
  profiles,
  lib2,
  ...
}:

let
  inherit (lib2.nixos) mkKeybind;
in
{
  imports = [
    profiles.apps.git
    profiles.apps.vesktop

    profiles.scripts.dotsTodo
    profiles.scripts.dconfDiff

    (mkKeybind {
      name = "Open terminal";
      binding = "<Super>grave";
      command = "$APP_TERMINAL";
    })

    (mkKeybind {
      name = "Open backup terminal";
      binding = "<Super>t";
      command = "$APP_TERMINAL_BACKUP";
    })

    (mkKeybind {
      name = "Open web browser";
      binding = "<Super>F1";
      command = "$APP_BROWSER";
    })

    (mkKeybind {
      name = "Open notes";
      binding = "<Super>F2";
      command = "$APP_NOTES";
    })

    (mkKeybind {
      name = "Open code editor";
      binding = "<Super>F3";
      command = "$APP_CODE_EDITOR";
    })

    (mkKeybind {
      name = "Open communication";
      binding = "<Super>F4";
      command = "$APP_COMMUNICATION";
    })
  ];

  /*
    --------------------------------------------------------------------------------
    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------------------------------------------------------------------------
  */

  # Enable and configure the X11 windowing system.
  services.xserver = {
    enable = true;

    # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "altgr-intl";
    };
  };

  /*
    --------------------------------------------------------------------------------
    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------------------------------------------------------------------------
  */

  # Install my fonts
  fonts.packages = with pkgs; [
    # Nice legible font, used for obsidian
    atkinson-hyperlegible-next

    # Nerd fonts (includes ligatures and symbols)
    nerd-fonts.fantasque-sans-mono
    nerd-fonts.mononoki
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.atkynson-mono

    # Iosevka is a hyper-customizable font, but the build is not working right now for some reason :(
    # https://typeof.net/Iosevka/customizer
    # (iosevka.override {
    #   set = "Custom ";
    #   privateBuildPlan = ''
    #     [buildPlans.IosevkaCustom]
    #     family = "Iosevka Custom"
    #     spacing = "normal"
    #     serifs = "sans"
    #     noCvSs = true
    #     exportGlyphNames = false

    #     [buildPlans.IosevkaCustom.variants.design]
    #     paren = "normal"
    #     brace = "straight"
    #     percent = "rings-continuous-slash"
    #     lig-ltgteq = "slanted"
    #     lig-equal-chain = "without-notch"
    #     lig-hyphen-chain = "without-notch"

    #     [buildPlans.IosevkaCustom.ligations]
    #     inherits = "dlig"
    #   '';
    # })
  ];

  /*
    --------------------------------------------------------------------------------
    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------------------------------------------------------------------------
  */

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
