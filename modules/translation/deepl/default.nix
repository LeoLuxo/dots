{ pkgs, user, ... }:

{
  imports = [ ./deepl-linux-electron.nix ];

  # programs.dconf.enable = true;

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      deepl-linux-electron
    ];

    dconf.settings = {
      # Custom shortcut
      # "org/gnome/settings-daemon/plugins/media-keys" = {
      #   custom-keybindings = [
      #     "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/translate/"
      #   ];
      # };

      # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/translate" = {
      #   binding = "<Super>d";
      #   command = "dialect --selection";
      #   name = "Instant translate";
      # };
    };
  };
}
