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
    suites.desktop = enabled;
    keyboard = {
      layout = "us";
      variant = "altgr-intl";
    };
  };
}
