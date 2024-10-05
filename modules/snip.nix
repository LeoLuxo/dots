{
  pkgs,
  user,
  scriptSet,
  ...
}:
{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      # Not putting these deps in the script because I don't want to wait to screenshot if they're missing
      gnome-screenshot
      wl-clipboard

      # The script
      scriptSet.snip
    ];
  };
}
