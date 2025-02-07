{
  pkgs,
  constants,
  ...
}:

# wl-clipboard only works under wayland, dunno how to make this config work under X11
{
  config = {
    shell.aliases = {
      "copy" = "wl-copy";
      "paste" = "wl-paste";
    };

    home-manager.users.${constants.user} = {
      home.packages = [
        pkgs.wl-clipboard
      ];
    };
  };
}
