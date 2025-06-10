{
  lib,
  ...
}:

{
  defaults.apps.browser = lib.mkDefault "firefox";

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

  # Fixes fullscreen freezes
  # environment.sessionVariables = {
  #   MOZ_ENABLE_WAYLAND = "0";
  # };
  # Nevermind, xwayland cannot deal with multiple desktops at all

}
