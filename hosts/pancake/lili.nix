{
  pkgs,
  ...
}:
{
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "lili";
  home.homeDirectory = "/home/lili";

  imports = [
    ../../modules/user/discord
    ../../modules/user/gnome

    # TODO: Make those into folders
    ../../modules/user/git.nix
    ../../modules/user/vscode.nix
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    bitwarden-desktop

    obsidian

    # gpaste

    # Scripts
    (writeShellScriptBin "rebuild" (builtins.readFile ../../scripts/rebuild.sh))

    # Not putting these deps in the script because I don't want to wait to screenshot if they're missing
    gnome-screenshot
    wl-clipboard
    (writeShellScriptBin "snip" (builtins.readFile ../../scripts/snip.sh))

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Environment variables
  home.sessionVariables = {
    EDITOR = "code";
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };

}
