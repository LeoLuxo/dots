{ pkgs, lib2, ... }:
{
  imports = [
    (lib2.nixos.mkSyncedPath {
      target = "~/.local/share/PrismLauncher/prismlauncher.cfg";
      syncName = "prismlauncher/settings.cfg";
    })
  ];

  environment.systemPackages = [
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
