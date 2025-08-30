{
  config,
  inputs,
  user,
  hostname,
  ...
}:
{
  # === Enable boot loading
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # === Enable CUPS to print documents.
  services.printing.enable = true;

  # === Define the default user account.
  users = {
    mutableUsers = false;

    users.${user} = {
      home = "/home/user";
      description = "the default user '${user}'";
      isNormalUser = true;

      hashedPasswordFile = config.age.secrets."userpws/${hostname}".path;
      extraGroups = [ "wheel" ];

      # Not setting the uid will make it choose one that's available
      # uid = 1000;
    };
  };

  nix.settings = {
    trusted-users = [
      user
    ];
  };

  # === Handle agenix secrets
  imports = [
    # Include agenix module
    inputs.agenix.nixosModules.default
  ];

  environment.systemPackages = [
    # Install agenix CLI
    inputs.agenix.packages.${config.nixpkgs.hostPlatform}.default
  ];

  age = {
    # Use the special agenix key
    identityPaths = [
      "/etc/ssh/agenix_ed25519"
    ];

    # Add secrets from the flake to agenix config
    secrets =
      let
        # Fetch secrets from private repo
        # Secrets are SUPPOSED to be fully independent from the dots in my opinion, thus this (intentionally) makes my dots impure
        # (note to self: the url MUST use git+ssh otherwise it won't properly authenticate and have access to the repo)
        flake = builtins.getFlake "git+ssh://git@github.com/LeoLuxo/nix-secrets";
      in
      flake.ageSecrets;
  };

}
