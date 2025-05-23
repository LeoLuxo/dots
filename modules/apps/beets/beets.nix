{
  beets,
  pkgs,
  makeWrapper,
  runCommand,
  symlinkJoin,
}:

let
  configDir = runCommand "config-dir" { } ''
    mkdir -p $out
    cp ${./config.yaml} $out/config.yaml
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
