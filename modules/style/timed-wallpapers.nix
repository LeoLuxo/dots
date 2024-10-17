{
  pkgs,
  user,
  writeScriptBinWithDeps,
  ...
}:
{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      wallutils
      wallutils-install
    ];
  };

  nixpkgs.overlays = [
    (final: prev: {
      wallutils-install = writeScriptBinWithDeps {
        name = "heic-install";
        text = builtins.readFile "${prev.wallutils.src}/scripts/heic-install";
        deps = with pkgs; [
          wallutils
          imagemagick
        ];
      };
    })
  ];
}
