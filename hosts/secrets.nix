{
  agenix,
  constants,
  ...
}:

let
  inherit (constants) system userKeyPrivate hostKeyPrivate;
in

let
  # Fetch secrets from private repo
  # Secrets are SUPPOSED to be fully indepent from the dots in my opinion, thus this (intentionally) makes my dots impure
  # (note to self: the url MUST use git+ssh otherwise it won't properly authenticate and have access to the repo)
  secrets = (builtins.getFlake "git+ssh://git@github.com/LeoLuxo/nix-secrets").secrets;
in
{

  imports = [
    # Include agenix module
    agenix.nixosModules.default
  ];

  environment.systemPackages = [
    # Install agenix CLI
    agenix.packages.${system}.default
  ];

  age = {
    # Use the host key OR user key
    identityPaths = [
      hostKeyPrivate
      userKeyPrivate
    ];

    # Add secrets from the flake to agenix config
    inherit secrets;
  };

}
