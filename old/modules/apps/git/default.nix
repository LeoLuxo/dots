{
  pkgs,
  config,
  ...
}:

{
  imports = [ ./gitignore.nix ];

  my.packages = with pkgs; [
    # Gnome circles commit editor
    commit
  ];

  home-manager.users.${config.my.user.name} = {
    # Add aliases
    home.shellAliases = {
      gs = "git status";
    };

    # Needed for signing with ssh key
    # ref: https://jeppesen.io/git-commit-sign-nix-home-manager-ssh/
    home.file.".ssh/allowed_signers".text = "* ${builtins.readFile config.my.keys.user.public}";

    programs.git = {
      enable = true;

      userEmail = "contact@me.leoluxo.eu";
      userName = "LeoLuxo";

      extraConfig = {
        init.defaultBranch = "main";

        # Disable safe directory checks
        safe.directory = "*";

        # Some options transferred from my old windows config, no idea if they're relevant here :shrug:
        core = {
          # Don't hide the .git directory on windows
          hideDotFiles = false;

          # Disable the CRLF warning (but still auto convert)
          safecrlf = false;

          # Set the commit editor to gnome commit
          editor = "re.sonny.Commit";
        };

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
        user.signingkey = "${config.my.keys.user.public}";
        gpg = {
          format = "ssh";
          ssh.allowedSignersFile = "~/.ssh/allowed_signers";
        };
      };
    };
  };
}
