{
  lib,
  lib2,
  pkgs,
  profiles,
  user,
  ...
}:

let
  inherit (lib2.nixos) mkKeybind;
in
{
  imports = [
    profiles.apps.git
    profiles.apps.vesktop
    profiles.apps.distrobox
    profiles.apps.firefox
    profiles.apps.upscaler

    profiles.scripts.dotsTodo
    profiles.scripts.dconfDiff
    profiles.scripts.snip

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

  environment.systemPackages = with pkgs; [
    bitwarden-desktop
    obsidian
    wl-clipboard
    textpieces # A developer’s scratchpad that lets you quickly experiment with and transform text
    hieroglyphic # An application that helps you locate and select LaTeX symbols by drawing or sketching them
    impression # A utility for creating bootable USB drives from disk images
    switcheroo # A tool for converting and manipulating images (for example, resizing or reformatting them)
    video-trimmer # A simple app designed to quickly trim and edit video clips
    warp # A fast, secure file transfer utility for moving files efficiently between systems
    teams-for-linux # Microsoft Teams client recreated, the original electron teams package was abandoned
    eyedropper # A simple color picker tool that allows you to select a color from anywhere on the screen
    celluloid # A simple video player
  ];

  home-manager.users.${user}.home = {
    sessionVariables.APP_NOTES = lib.mkDefault "obsidian";

    shellAliases = {
      "copy" = "wl-copy";
      "paste" = "wl-paste";
    };
  };

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
