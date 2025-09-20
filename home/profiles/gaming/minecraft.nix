{ pkgs, lib2, ... }:
{
  imports = [
    (lib2.hm.mkSyncedPath {
      xdgDir = "data";
      target = "PrismLauncher/prismlauncher.cfg";
      syncName = "prismlauncher/settings.cfg";
    })
  ];

  home.packages = [
    (pkgs.symlinkJoin {
      name = "prismlauncher";
      paths = [ pkgs.prismlauncher ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/prismlauncher \
          --set QT_SCALE_FACTOR 1.5
      '';
    })
  ];
}
