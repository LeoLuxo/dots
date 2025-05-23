{
  beets,
  pkgs,
  formats,
  makeWrapper,
  runCommand,
  symlinkJoin,
}:

let
  yaml = formats.yaml { };
  config = yaml.generate "config.yaml" (import ./config.nix);
  configDir = runCommand "config-dir" { } ''
    mkdir -p $out
    cp ${config} $out/config.yaml
  '';
in
symlinkJoin {
  name = "beets";
  paths = [
    (beets.override {
      pluginOverrides = {
        fetchartist = {
          enable = true;
          propagatedBuildInputs = [ (pkgs.callPackage ./beets-fetchartist.nix { }) ];
        };
      };
    })
  ];

  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/beet --set BEETSDIR ${configDir}
  '';
}
