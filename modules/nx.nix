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
      scriptBin.nx.nx-rebuild

      # Clean up old NixOS generations and garbage-collect the nix store
      scriptBin.nx.nx-cleanup

      # Open the config repo in vscode or cd to the config repo
      scriptBin.nx.nx-code
      scriptBin.nx.nx-cd
    ];
  };
}
