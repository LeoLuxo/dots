{
  pkgs,
  user,
  directories,
  ...
}:
{
  imports = [
    directories.modules.wallutils
  ];

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      wallutils
    ];
  };

  # services.wallutils = {
  #   enable = true;
  # };

}
