{
  inputs,
  homeProfiles,
  config,
  ...
}:

{
  imports = [
    homeProfiles.common.agenix

    homeProfiles.shells.bash
    homeProfiles.shells.fish
    # homeProfiles.shells.zsh

    homeProfiles.shells.prompts.starship
    # homeProfiles.shells.prompts.ohmyposh

    homeProfiles.scripts.nixUtils
    homeProfiles.scripts.terminalUtils

    homeProfiles.apps.zoxide
    homeProfiles.apps.direnv
  ];

  /*
    --------------------------------------------------------------------------------
    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------------------------------------------------------------------------
  */

  # Do not change
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.homeDirectory = "/home/${config.home.username}";

  # Customize default directories
  xdg.userDirs =
    let
      home = config.home.homeDirectory;
    in
    {
      enable = true;
      createDirectories = true;

      download = "${home}/downloads";

      music = "${home}/media";
      pictures = "${home}/media";
      videos = "${home}/media";

      desktop = "${home}/misc";
      documents = "${home}/misc";

      templates = null;
      publicShare = null;
    };

  /*
    --------------------------------------------------------------------------------
    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------------------------------------------------------------------------
  */

  home.sessionVariables = {
    # Suppress the "git tree is dirty" warnings
    NIX_CONFIG = "warn-dirty = false";

    EDITOR = "nano";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Add our custom overlays
  nixpkgs.overlays = [
    inputs.self.overlays.extraPkgs
    inputs.self.overlays.builders
  ];

  nix.settings = {
    # Enable the new nix cli tool and flakes
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # A list of names of users that have additional rights when connecting to the Nix daemon, such as the ability to specify additional binary caches, or to import unsigned NARs.
    trusted-users = [
      "root"
      config.home.username
    ];
  };

}
