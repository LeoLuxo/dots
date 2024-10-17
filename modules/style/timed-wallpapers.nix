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

  services.wallutils = {
    enable = true;
  };

}
