{
  pkgs,
  config,

  user,
  ...
}:

# wl-clipboard only works under wayland, dunno how to make this config work under X11
{
  environment.systemPackages = [
    pkgs.wl-clipboard
  ];

  home-manager.users.${user} = {
    home.shellAliases = {
      "copy" = "wl-copy";
      "paste" = "wl-paste";
    };
  };
}
