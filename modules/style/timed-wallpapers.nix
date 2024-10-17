{
  pkgs,
  user,
  writeScriptWithDeps,
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
      wallutils-install = writeScriptWithDeps {
        name = "heic-install";
        text = builtins.readFile "${prev.wallutils.src}/scripts/heic-install";
        deps = with pkgs; [
          wallutils
          imagemagick
        ];
        shell = true;
      };
    })
  ];
}
