{
  lib,
  config,
  inputs,
  inputs',
  ...
}:
let
  lib2 = inputs.self.lib;
  inherit (lib) types;
  cfg = config.my.nix.secrets;
in
{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  options.my.nix.secrets = with lib2.options; {
    enable = lib.mkEnableOption "secrets management using agenix";

    keys = mkOpt "keys to use for decryption" (types.listOf types.path) (
      if config.my.system.keys.enable then
        (lib.mapAttrsToList (_: keyFiles: keyFiles.private) config.my.keys.keys)
      else
        [ ]
    );
  };

  config = lib.mkIf cfg.enable (
    let
      # Fetch secrets from private repo
      # Secrets are SUPPOSED to be fully independent from the dotfiles/nix configuration in my opinion, thus this (intentionally) makes my config impure
      # (note to self: the url MUST use git+ssh otherwise it won't properly authenticate and have access to the repo)
      flake = builtins.getFlake "git+ssh://git@github.com/LeoLuxo/nix-secrets";
    in
    {
      # Install agenix CLI
      my.packages = [
        inputs'.agenix.packages.default
      ];

      age = {
        # Use the host key OR user key
        identityPaths = cfg.keys;

        # Add secrets from the flake to agenix config
        secrets = flake.ageSecrets;
      };
    }
  );
}
