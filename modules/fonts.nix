{ pkgs, user, ... }:

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      # Install nerdfonts, but only with a limited amount of fonts
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
}