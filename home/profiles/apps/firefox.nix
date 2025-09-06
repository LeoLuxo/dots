{
  lib,
  ...
}:

{

  programs = {
    # Setup firefox.
    firefox = {
      enable = true;
      policies =
        let
          lock-false = {
            Value = false;
            Status = "locked";
          };
        in
        # lock-true = {
        #   Value = true;
        #   Status = "locked";
        # };
        {
          Preferences = {
            "middlemouse.paste" = lock-false;
          };
        };
    };
  };

  home.sessionVariables = {
    APP_BROWSER = lib.mkDefault "firefox";
  };

  # Fixes fullscreen freezes
  # home.sessionVariables = {
  #   MOZ_ENABLE_WAYLAND = "0";
  # };
  # Nevermind, xwayland cannot deal with multiple desktops at all

}
