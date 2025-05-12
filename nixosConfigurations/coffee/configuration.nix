{
  inputs,
  ...
}:

let
  lib2 = inputs.self.lib;
  inherit (lib2) enabled;
in
{
  ext = {
    suites.pc.desktop = {
      enable = true;
      username = "lili";
    };

    keyboard = {
      layout = "us";
      variant = "altgr-intl";
    };

    scripts.bootWindows = enabled;
  };
}
