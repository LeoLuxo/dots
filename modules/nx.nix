{
  lib,
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

    # Add all scripts from the nx directory
    home.packages = lib.attrsets.attrValues scriptBin.nx;
  };
}
