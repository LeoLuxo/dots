{
  autologin,
  config,
  host,
  hostname,
  hosts,
  inputs,
  lib,
  lib2,
  pkgs,
  profiles,
  users,
  picture ? null,
  ...
}:

let
  defaultShell = "fish";
in
{
  imports = [
    profiles.agenix

    profiles.apps.git
    profiles.apps.direnv

    profiles.scripts.dots
    profiles.scripts.nixUtils
    profiles.scripts.terminalUtils

    inputs.home-manager.nixosModules.home-manager
    inputs.nix-monitored.nixosModules.default
  ];

  /*
    --------------------------------------------------------------------------------
    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------------------------------------------------------------------------
  */

  # ---------- Customization ----------

  # Set the time zone.
  time.timeZone = "Europe/Copenhagen";

  # Select internationalisation properties.
  # A good choice would also be english-(Ireland); see:
  # https://unix.stackexchange.com/questions/62316/why-is-there-no-euro-english-locale
  i18n.defaultLocale = "en_DK.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "en_IE.UTF-8";
    # LC_ADDRESS = "en_IE.UTF-8";
    # LC_IDENTIFICATION = "en_IE.UTF-8";
    # LC_MEASUREMENT = "en_IE.UTF-8";
    # LC_MONETARY = "en_IE.UTF-8";
    # LC_NAME = "en_IE.UTF-8";
    # LC_NUMERIC = "en_IE.UTF-8";
    # LC_PAPER = "en_IE.UTF-8";
    # LC_TELEPHONE = "en_IE.UTF-8";
  };

  # Essential system packages
  environment.systemPackages = with pkgs; [
    nano
    wget
    curl
    git
  ];

  # Set the default editor
  environment.variables = {
    EDITOR = lib.mkDefault "nano";
  };

  # Set nix-monitored as the default nix package, which automatically integrates nix-output-monitor into all commands
  nix.monitored = {
    enable = true;
    notify = false;
  };

  # Enable zoxide, the smarter `cd` command
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  /*
    --------------------------------------------------------------------------------
    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------------------------------------------------------------------------
  */

  # ---------- Nix settings ----------

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    # Enable the new nix cli tool and flakes
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # A list of names of users that have additional rights when connecting to the Nix daemon, such as the ability to specify additional binary caches, or to import unsigned NARs.
    # Add all manually-defined users to it
    trusted-users = [ "root" ] ++ (lib.mapAttrsToList (username: _: username) users);

    # Use all available cores for building (0 is already the default)
    cores = 0;
  };

  /*
    --------------------------------------------------------------------------------
    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------------------------------------------------------------------------
  */

  # ---------- Host machine important settings ----------

  # Define and set up all the manually-defined users
  users = {
    mutableUsers = false;

    users = lib.concatMapAttrs (username: userCfg: {
      ${username} = {
        # This automatically sets group to users, `createHome` to true, `home` to /`home/«username»`, `useDefaultShell` to true, and `isSystemUser` to false. Exactly one of `isNormalUser` and `isSystemUser` must be true.
        isNormalUser = true;

        hashedPasswordFile = config.age.secrets."userpwds/${hostname}/${username}".path;
        extraGroups = [ "wheel" ];

        # Set default shell (can't be done in home-manager)
        shell = pkgs.${defaultShell};
      }
      # Add all other attributes except special ones
      // (builtins.removeAttrs userCfg [ "publicKeys" ]);
    }) users;
  };

  # Enable default shell
  programs.${defaultShell}.enable = true;

  # Enable autologin if relevant
  services.displayManager.autoLogin = lib.mkIf (autologin != null) {
    enable = true;
    user = autologin;
  };

  # The keyboard mapping table for the virtual consoles
  console.keyMap = "us";

  /*
    --------------------------------------------------------------------------------
    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------------------------------------------------------------------------
  */

  # ---------- Networking / SSH settings ----------

  # Set the hostname
  networking.hostName = hostname;

  # Add all IPs defined in my hosts list to the networking hosts map `/etc/hosts` (hostname -> IP)
  networking.hosts = lib.concatMapAttrs (
    name: hostCfg:
    lib.concatMapAttrs (_: ip: {
      "${ip}" = [ name ];
    }) (hostCfg.ip or { })
  ) hosts;

  services.openssh = {
    enable = true;

    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  # Configure known_hosts based on all the ssh host keys
  programs.ssh.knownHosts = lib.concatMapAttrs (
    hostname: hostCfg:
    if (hostCfg ? "ssh" && hostCfg.ssh ? "hostKeys") then
      let
        hostRaw = hostCfg.ssh.hostname or hostCfg.hostname or hostname;
        host = if hostCfg.ssh ? port then "[${hostRaw}]:${builtins.toString hostCfg.ssh.port}" else hostRaw;
        hostKeys = hostCfg.ssh.hostKeys;
      in
      lib.mergeAttrsList (
        lib.imap (
          i: key:
          let
            # The module for this is really stupid and doesn't let use define multiple keys for a single host so we have to use a "unique" name for the attribute set for each key
            name = "${host}-${builtins.toString i}";
          in
          {
            ${name} = {
              hostNames = [ host ];
              publicKey = key;
            };
          }
        ) hostKeys
      )
    else
      { }
  ) hosts;

  /*
    --------------------------------------------------------------------------------
    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------------------------------------------------------------------------
  */

  # ---------- Home-Manager config ----------

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    # On activation move existing files by appending the given file extension rather than exiting with an error.
    # Applies to home.file and also xdg.*File
    # backupFileExtension = "bak";

    extraSpecialArgs = {
      inherit inputs lib2;
      inherit hostname hosts host;
    };

    users = lib.concatMapAttrs (username: userCfg: {
      ${username} =
        { lib, ... }:
        {
          # Do not change
          home.stateVersion = "24.05";

          # Home Manager needs a bit of information about you and the paths it should manage.
          home.username = username;
          home.homeDirectory = "/home/${username}";

          # Let Home Manager install and manage itself.
          programs.home-manager.enable = true;

          # Customize default directories
          xdg.userDirs = {
            enable = true;
            createDirectories = true;

            download = "/home/${username}/downloads";

            music = "/home/${username}/media";
            pictures = "/home/${username}/media";
            videos = "/home/${username}/media";

            desktop = "/home/${username}/misc";
            documents = "/home/${username}/misc";

            templates = null;
            publicShare = null;
          };

          # Set the display manager profile picture
          home.file.".face" = lib.mkIf (userCfg ? face || picture != null) {
            source = userCfg.face or picture;
          };

          # Create SSH aliases from the `ssh` block in the host definitions
          programs.ssh = {
            enable = true;
            enableDefaultConfig = false;

            matchBlocks = lib.concatMapAttrs (
              hostname: hostCfg:
              if (hostCfg ? "ssh") then
                let
                  sshCfg = hostCfg.ssh;
                in
                {
                  ${hostname} = {
                    host = hostname;
                  }
                  // (builtins.removeAttrs sshCfg [ "hostKeys" ]);
                }
              else
                { }
            ) hosts;
          };

          # Workaround for the whole `Bad owner or permissions on ~/.ssh/config` error in vscode.
          # https://github.com/nix-community/home-manager/issues/322

          home.file.".ssh/config".force = true; # home-manager wrongly thinks it doesn't manage (and thus shouldn't clobber) this file due to the activation script
          home.activation = {
            fixSshPermissions = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
              run install -d -m 0700 "$HOME/.ssh"
              if [ -L "$HOME/.ssh/config" ]; then
                src="$(readlink -f "$HOME/.ssh/config")"
                run rm -f "$HOME/.ssh/config"
                run install -m 0600 "$src" "$HOME/.ssh/config"
              fi
            '';
          };

          # Starship shell prompt
          programs.starship = {
            enable = true;
            # enableTransience = true;
          };

          # Fish shell
          programs.fish = {
            enable = true;

            # Use fish_key_reader to get keycodes
            # https://fishshell.com/docs/current/cmds/bind.html
            shellInit = ''
              # Bind backspace correctly just to make sure
              bind backspace backward-delete-char

              # Rebind CTRL-backspace
              bind ctrl-h backward-kill-path-component

              # Bind CTRL-W
              bind ctrl-w backward-kill-bigword

              # Bind CTRL-Delete
              bind ctrl-delete kill-bigword

              # Bind CTRL-\|
              bind ctrl-\\ beginning-of-line

              # Rebind right to accept only a single char instead of the entire autosuggestion
              bind right forward-single-char

              # Bind CTRL-Space to open autocomplete search
              bind ctrl-space complete-and-search

              # Rebind tab to accept suggestion
              bind tab accept-autosuggestion
            '';

            functions = {
              cd = ''
                if type -q z
                  z $argv
                else
                  builtin cd $argv
                end
              '';

              fish_title = ''
                string join / -- (string split / -- $PWD)[-4..-1]
              '';
            };
          };

        };
    }) users;
  };
}
