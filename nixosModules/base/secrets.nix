{
  lib,
  config,
  inputs,
  system,
  extraLib,
  pkgs,
  ...
}:
let
  inherit (lib) types;
  inherit (pkgs.lib2) mkSubmodule;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.modules) mkIf;

  inherit (extraLib) writeScriptWithDeps;

  cfg = config.my.secretManagement;
in
{
  imports = [
    inputs.agenix.nixosModules.default

    # Alias for abstraction, so clients of these modules don't have to think about age specifically
    (lib.mkAliasOptionModule [ "my" "secretManagement" "secrets" ] [ "age" "secrets" ])

    # Alias to map from the other paths option to the specific path for secretManagement
    (lib.mkAliasOptionModule
      [ "my" "paths" "secrets" ]
      [ "my" "secretManagement" "editSecretsCommand" "path" ]
    )
  ];

  options.my = {
    secretManagement = {
      enable = lib.mkEnableOption "secrets management using agenix";

      keys = mkOption {
        description = "keys to use for decryption";
        type = types.listOf types.path;
        default = lib.mapAttrsToList (_: keyPair: keyPair.private) config.my.keys;
      };

      editSecretsCommand = mkSubmodule {
        enable = mkEnableOption "the command to edit secrets";

        path = mkOption {
          description = "the path to the secrets repo";
          type = types.path;
        };

        key = mkOption {
          description = "the key/identify file to give agenix to decrypt secrets";
          type = types.path;
          default = config.my.keys.host.private;
        };
      };
    };

    # Option that's supposed to mirror agenix's secrets, see below in config
    secrets = lib.mkOption {
      description = "attribute set of secrets' path";
      type = types.attrsOf types.path;
      default = { };
    };
  };

  config = mkIf cfg.enable (
    let
      # Fetch secrets from private repo
      # Secrets are SUPPOSED to be fully independent from the dotfiles/nix configuration in my opinion, thus this (intentionally) makes my config impure
      # (note to self: the url MUST use git+ssh otherwise it won't properly authenticate and have access to the repo)
      secretsFlake = builtins.getFlake "git+ssh://git@github.com/LeoLuxo/nix-secrets";
    in
    {
      my.packages = [
        # Install agenix CLI
        inputs.agenix.packages.${system}.default

        # Add the edit-secret command
        (mkIf cfg.editSecretsCommand.enable (writeScriptWithDeps {
          name = "edit-secret";

          text = ''
            pushd ${cfg.editSecretsCommand.path}/secrets 1>/dev/null

            export EDITOR=nano
            export RULES="${cfg.editSecretsCommand.path}/secrets.nix"
            agenix --identity "${cfg.editSecretsCommand.key}" --edit $@

            popd 1>/dev/null
          '';

          # Needs elevation because the given key (for example host key) might be root-protected
          elevate = true;

          addBashShebang = true;
          deps = [ pkgs.nano ];
        }))
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

      # Add fish shell completions for edit-secret
      programs.fish.interactiveShellInit = mkIf cfg.editSecretsCommand.enable ''
        complete -c edit-secret -a '(pushd ${cfg.editSecretsCommand.path}/secrets; __fish_complete_path (commandline -ct); popd)'
      '';
    }
  );
}
