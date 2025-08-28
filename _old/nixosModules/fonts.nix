{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) modules types;
in

{
  config.fonts.packages = with pkgs; [
    atkinson-hyperlegible-next

    # Install certain nerd fonts
    nerd-fonts.fantasque-sans-mono
    nerd-fonts.mononoki
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.atkynson-mono

    # Install the Iosevka font
    # https://typeof.net/Iosevka/customizer
    # Build not working for some reason :shrug:

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
