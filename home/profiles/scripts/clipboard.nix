{
  pkgs,
  ...
}:

{
  home.packages = [
    # wl-clipboard only works under wayland
    pkgs.wl-clipboard
  ];

  home.shellAliases = {
    "copy" = "wl-copy";
    "paste" = "wl-paste";
  };
}
