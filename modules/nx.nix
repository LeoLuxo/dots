{
  lib,
  user,
  scriptBin,
  ...
}:
{
  environment.variables = {
    # Set the location of the config repo
    NX_REPO = "/etc/nixos/dots";

    # Set the location of the file used for dconf-diff
    DCONF_DIFF = "/home/${user}/.dconf_activation";
  };

  home-manager.users.${user} = {
    # Add all scripts from the nx directory
    home.packages = builtins.map (nx: nx { }) (lib.attrsets.attrValues scriptBin.nx);
  };

}
