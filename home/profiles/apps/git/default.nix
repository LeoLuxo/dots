{
  lib,
  config,
  host,
  ...
}:

let
  keys = host.users.${config.home.username}.publicKeys;
in
{
  imports = [ ./gitignore.nix ];

  # Add aliases
  home.shellAliases = {
    gs = "git status";
    gst = "git status";
  };

  # Needed for signing with ssh key
  # ref: https://jeppesen.io/git-commit-sign-nix-home-manager-ssh/
  home.file.".ssh/allowed_signers".text = lib.concatLines (lib.map (key: "* ${key}") keys);

  programs.git = {
    enable = true;

    extraConfig = {
      init.defaultBranch = "main";

      # Disable safe directory checks
      safe.directory = "*";

      # Automatically setup remote when pushing on a repo that was cloned (iirc?)
      push.autoSetupRemote = true;

      # Force using the CMD credentials prompt instead of a window
      credential.modalprompt = false;

      pull.rebase = false;

      # Enforce SSH
      url = {
        "ssh://git@github.com/".insteadOf = "https://github.com/";
        "ssh://git@gitlab.com/".insteadOf = "https://gitlab.com/";
        "ssh://git@bitbucket.org/".insteadOf = "https://bitbucket.org/";
      };

      # Sign all commits using ssh key
      commit.gpgsign = true;
      # Take first key by default
      user.signingkey = lib.head keys;
      gpg = {
        format = "ssh";
        ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      };
    };
  };
}
