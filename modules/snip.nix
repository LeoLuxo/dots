{
  pkgs,
  user,
  scriptSet,
  ...
}:
{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      dconf

      # Not putting these deps in the script because I don't want to wait to screenshot if they're missing
      gnome-screenshot
      wl-clipboard

      # The script
      scriptSet.snip
    ];

    dconf.settings = {
      # Custom shortcuts
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/screenshot/"
        ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/screenshot" = {
        binding = "<Super>s";
        command = "snip";
        name = "Instant screenshot";
      };
    };
  };
}
