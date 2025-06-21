{
  pkgs,
  config,
  constants,
  ...
}:

# wl-clipboard only works under wayland, dunno how to make this config work under X11
{
  ext.packages = [
    pkgs.wl-clipboard
  ];

  home-manager.users.${config.ext.system.user.name} = {
    home.shellAliases = {
      "copy" = "wl-copy";
      "paste" = "wl-paste";
    };
  };
}
