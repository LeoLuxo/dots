{
  lib,
  users,
  user,
  pkgs,
  ...
}:

let
  keys = users.${user}.publicKeys;
in
{
  imports = [ ./gitignore.nix ];

  environment.systemPackages = with pkgs; [
    # Gnome circles commit editor
    commit
  ];

  home-manager.users.${user} = {
    home.shellAliases = {
      gs = "git status";
      gst = "git status";
    };

    # Needed for signing with ssh key
    # ref: https://jeppesen.io/git-commit-sign-nix-home-manager-ssh/
    home.file.".ssh/allowed_signers".text = lib.concatLines (lib.map (key: "* ${key}") keys);

    programs.git = {
      enable = true;

      settings = {
        user.email = "contact@me.leoluxo.eu";
        user.name = "LeoLuxo";

        init.defaultBranch = "main";

        # Disable safe directory checks
        safe.directory = "*";

        # Set the commit editor to gnome commit
        # core.editor = "re.sonny.Commit";

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
  };
}
