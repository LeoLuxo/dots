{
  pkgs,
  user,
  ...
}:

{
  environment.systemPackages = [
    (pkgs.writeScriptWithDeps {
      name = "snip";
      file = ./snip.sh;
      deps = [
        pkgs.gnome-screenshot
        pkgs.wl-clipboard
      ];
    })
  ];

  my.keybinds."Instant screenshot" = {
    binding = "<Super>s";
    command = "snip";
  };
}
