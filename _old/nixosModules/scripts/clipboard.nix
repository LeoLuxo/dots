{
  pkgs,
  config,

  ...
}:

# wl-clipboard only works under wayland, dunno how to make this config work under X11
{
  environment.systemPackages = [
    pkgs.wl-clipboard
  ];

  home-manager.users.${config.my.user.name} = {
    home.shellAliases = {
      "copy" = "wl-copy";
      "paste" = "wl-paste";
    };
  };
}
