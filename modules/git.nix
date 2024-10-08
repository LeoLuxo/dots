{ user, ... }:

{
  home-manager.users.${user} = {
    programs.git = {
      enable = true;

      userEmail = "contact@me.leoluxo.eu";
      userName = "LeoLuxo";

      extraConfig = {
        init.defaultBranch = "main";

        # Disable safe directory checks
        safe.directory = "*";

        # Some options transferred from my windows times, no idea if they're relevant here :shrug:
        core = {
          # Don't hide the .git directory on windows
          hideDotFiles = false;
          # Set the text editor
          editor = "code";
          # Disable the CRLF warning (but still auto convert)
          safecrlf = false;
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
      };
    };
  };
}
