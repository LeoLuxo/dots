{
  user,
  scriptBin,
  ...
}:
{
  home-manager.users.${user} = {
    home.sessionVariables = {
      # Set the location of the config repo
      NX_REPO = "/etc/nixos/dots";
    };

    home.packages = [
      # Rebuild script
      scriptBin.nx-rebuild

      # Open the config repo in vscode
      scriptBin.nx-code

      # Clean up old NixOS generations and garbage-collect the nix store
      scriptBin.nx-cleanup
    ];
  };
}
