{ pkgs, user, ... }:

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      dconf

      # Gnome circles translator app
      dialect
    ];

    dconf.settings = {
      # Custom shortcuts
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/translate/"
        ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/translate" = {
        binding = "<Super>d";
        command = "dialect --selection";
        name = "Instant translate";
      };
    };
  };
}
