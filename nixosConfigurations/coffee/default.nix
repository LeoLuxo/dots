{ lib, inputs, ... }:
{
  system = "x86_64-linux";

  modules = [
    # ./configuration.nix
    # ./audio.nix
    # ./hardwareConfiguration.nix

    # inputs.self.nixosModules.default

    # inputs.self.nixosModules.apps-restic
    # inputs.self.nixosModules.desktop-autologin
    # inputs.self.nixosModules.desktop-defaultApps
    # inputs.self.nixosModules.desktop-defaultAppsShortcuts
    # inputs.self.nixosModules.desktop-fonts
    # inputs.self.nixosModules.desktop-keybinds
    # inputs.self.nixosModules.desktop-manager-gnome-customApps
    # inputs.self.nixosModules.desktop-manager-gnome-extensions-appIndicator
    # inputs.self.nixosModules.desktop-manager-gnome-extensions-bluetoothQuickConnect
    # inputs.self.nixosModules.desktop-manager-gnome-extensions-blurMyShell
    # inputs.self.nixosModules.desktop-manager-gnome-extensions-burnMyWindows
    # inputs.self.nixosModules.desktop-manager-gnome-extensions-clipboardIndicator
    # inputs.self.nixosModules.desktop-manager-gnome-extensions-ddterm
    # inputs.self.nixosModules.desktop-manager-gnome-extensions-emojiCopy
    # inputs.self.nixosModules.desktop-manager-gnome-extensions-gsconnect
    # inputs.self.nixosModules.desktop-manager-gnome-extensions-justPerfection
    # inputs.self.nixosModules.desktop-manager-gnome-extensions-mediaControls
    # inputs.self.nixosModules.desktop-manager-gnome-extensions-netSpeedSimplified
    # inputs.self.nixosModules.desktop-manager-gnome-extensions-openWeatherRefined
    # inputs.self.nixosModules.desktop-manager-gnome-extensions-removableDriveMenu
    # inputs.self.nixosModules.desktop-manager-gnome-extensions-roundedCorners
    # inputs.self.nixosModules.desktop-manager-gnome-extensions-systemMonitor
    # inputs.self.nixosModules.desktop-manager-gnome-extensions-touchpadGestureCustomization
    # inputs.self.nixosModules.desktop-manager-gnome-extensions-wallhub
    # inputs.self.nixosModules.desktop-manager-gnome-gnome
    # inputs.self.nixosModules.desktop-manager-gnome-tripleBuffering
    # inputs.self.nixosModules.desktop-terminal-ddterm
    # inputs.self.nixosModules.desktop-terminal-guake
    # inputs.self.nixosModules.desktop-wallpaper
    # inputs.self.nixosModules.hardware-gpu-nvidia
    inputs.self.nixosModules.nix-hm
    inputs.self.nixosModules.nix-nix
    inputs.self.nixosModules.nix-packages
    inputs.self.nixosModules.nix-secrets
    # inputs.self.nixosModules.scripts-bootWindows
    # inputs.self.nixosModules.scripts-clipboard
    # inputs.self.nixosModules.scripts-nx
    # inputs.self.nixosModules.scripts-snip
    # inputs.self.nixosModules.scripts-terminalUtils
    inputs.self.nixosModules.shell-aliases
    # inputs.self.nixosModules.shell-defaultShell
    # inputs.self.nixosModules.shell-prompt-ohmyposh
    # inputs.self.nixosModules.shell-prompt-starship
    # inputs.self.nixosModules.shell-shells-bash
    # inputs.self.nixosModules.shell-shells-fish
    # inputs.self.nixosModules.shell-shells-zsh
    # inputs.self.nixosModules.suites-pc
    # inputs.self.nixosModules.suites-pcDesktop
    # inputs.self.nixosModules.suites-pcLaptop
    inputs.self.nixosModules.suites-server
    inputs.self.nixosModules.system-base
    inputs.self.nixosModules.system-boot
    inputs.self.nixosModules.system-graphics
    inputs.self.nixosModules.system-hosts
    inputs.self.nixosModules.system-keyboard
    inputs.self.nixosModules.system-keys
    inputs.self.nixosModules.system-locale
    inputs.self.nixosModules.system-pinKernel
    inputs.self.nixosModules.system-printing
    inputs.self.nixosModules.system-touchscreen
    inputs.self.nixosModules.system-user
    inputs.self.nixosModules.system-wifi

    { system.stateVersion = "24.05"; }
  ];
}
