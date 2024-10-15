{ pkgs, user, ... }:

{
  programs.dconf.enable = true;

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      # Gnome circles translator app
      dialect
    ];

    dconf.settings = {
      # Custom shortcut
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
