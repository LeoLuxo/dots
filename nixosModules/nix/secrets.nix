{
  lib,
  config,
  inputs,
  system,
  options,
  ...
}:
let
  lib2 = inputs.self.lib;
  inherit (lib) types;
  cfg = config.my.secretManagement;
in
{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  options.my = with lib2.options; {
    secretManagement = {
      enable = lib.mkEnableOption "secrets management using agenix";

      keys = mkOptDefault "keys to use for decryption" (types.listOf types.path) (
        lib.mapAttrsToList (_: keyPair: keyPair.private) config.my.keys
      );

      # Alias for agenix's secrets for use in configurating the user/group/mode
      # secrets = lib.mkAliasDefinitions options.age.secrets;
    };

    # Option that's supposed to mirror agenix's secrets, see below in config
    secrets = lib.mkOption {
      description = ''
        Attribute set of secrets' path.
      '';
      type = types.attrsOf types.path;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable (
    let
      # Fetch secrets from private repo
      # Secrets are SUPPOSED to be fully independent from the dotfiles/nix configuration in my opinion, thus this (intentionally) makes my config impure
      # (note to self: the url MUST use git+ssh otherwise it won't properly authenticate and have access to the repo)
      secretsFlake = builtins.getFlake "git+ssh://git@github.com/LeoLuxo/nix-secrets";
    in
    {
      # Install agenix CLI
      my.packages = [
        inputs.agenix.packages.${system}.default
      ];

      age = {
        # Use the host key OR user key
        identityPaths = cfg.keys;

        # Add secrets from the flake to agenix config
        secrets = secretsFlake.ageSecrets;
      };

      # To fully abstract away from agenix, remap/alias all the secrets' path at
      #   age.secrets.<name>.path
      # to
      #   my.secrets.<name>
      my.secrets = lib.mapAttrs (_: value: value.path) config.age.secrets;
    }
  );
}
