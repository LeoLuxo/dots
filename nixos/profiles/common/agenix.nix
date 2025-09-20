{ pkgs, inputs, ... }:
{

  # Handle agenix secrets
  imports = [
    # Include agenix module
    inputs.agenix.nixosModules.default
  ];

  # Install agenix CLI
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${system}.default
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
        # TODO: make them dependant
        flake = builtins.getFlake "git+ssh://git@github.com/LeoLuxo/nix-secrets";
      in
      flake.ageSecrets;
  };
}
