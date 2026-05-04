{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.writeScriptWithDeps {
      name = "media-sort";
      file = ./mediaSort.sh;
      deps = [
        pkgs.rsync
      ];
    })
  ];
}
