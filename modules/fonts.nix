{
  config,
  pkgs,
  lib,
  constants,
  extra-libs,
  ...
}:

let
  inherit (lib) modules;
  inherit (constants) user;
  inherit (extra-libs) mkBoolDefaultTrue;
in

{
  options.fonts = {
    enable = mkBoolDefaultTrue;
  };

  config = modules.mkIf config.fonts.enable {
    home-manager.users.${user} = {
      home.packages = with pkgs; [
        # FUTURE:
        # Install certain nerd fonts
        # nerd-fonts.fantasque-sans-mono
        # nerd-fonts.mononoki
        # nerd-fonts.fira-code

        (nerdfonts.override {
          fonts = [
            "FantasqueSansMono"
            "Mononoki"
            "FiraCode"
          ];
        })

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
    };
  };
}
