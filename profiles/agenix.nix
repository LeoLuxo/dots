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

# TODO: add this back:
# # Add fish shell completions for edit-secret
# programs.fish.interactiveShellInit = mkIf cfg.editSecretsCommand.enable ''
#   complete -c edit-secret -a '(pushd ${cfg.editSecretsCommand.path}; __fish_complete_path (commandline -ct); popd)'
# '';

#  pkgs.writeScriptWithDeps {
#             name = "edit-secret";

#             text = ''
#               pushd ${cfg.editSecretsCommand.path} 1>/dev/null

#               export EDITOR=nano
#               export RULES="${cfg.editSecretsCommand.path}/secrets.nix"
#               agenix --identity "${cfg.editSecretsCommand.key}" --edit $@

#               popd 1>/dev/null
#             '';

#             # Needs elevation because the given key (for example host key) might be root-protected
#             elevate = true;

#             addBashShebang = true;
#             deps = [ pkgs.nano ];
#           }
