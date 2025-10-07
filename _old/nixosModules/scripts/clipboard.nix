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

  hm = {
    home.shellAliases = {
      "copy" = "wl-copy";
      "paste" = "wl-paste";
    };
  };
}
