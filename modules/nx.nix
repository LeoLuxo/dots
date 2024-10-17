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

      # Set the location of the file used for dconf-diff
      DCONF_DIFF = "/home/${user}/.dconf_activation";
    };

    # Add all scripts from the nx directory
    home.packages = lib.traceVal (builtins.map (nx: nx { }) (lib.attrsets.attrValues scriptBin.nx));
  };

}
