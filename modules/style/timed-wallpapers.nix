{
  pkgs,
  user,
  writeShellScriptBinWithDeps,
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
      wallutils-install = writeShellScriptBinWithDeps {
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
