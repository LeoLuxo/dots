{
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

  nixpkgs.config.allowUnfree = true;

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
