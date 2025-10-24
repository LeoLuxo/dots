{ pkgs, ... }:
{

  # Enable and configure the X11 windowing system.
  services.xserver = {
    enable = true;

    # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "altgr-intl";
    };
  };

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
}
