{ nixpkgs, extra-libs, ... }:

let
  inherit (extra-libs) findFiles writeScriptWithDeps;
  inherit (nixpkgs.lib) attrsets lists;
in

rec {
  modules = findFiles {
    dir = ./modules;
    extensions = [ "nix" ];
    allowDefault = true;
  };

  hosts = findFiles {
    dir = ./hosts;
    extensions = [ "nix" ];
    allowDefault = true;
  };

  scripts = findFiles {
    dir = ./scripts;
    extensions = [
      "sh"
      "nu"
      "py"
    ];
    allowDefault = true;
  };

  images = findFiles {
    dir = ./assets;
    extensions = [
      "png"
      "jpg"
      "jpeg"
      "gif"
      "svg"
      "heic"
    ];
  };

  wallpapers = images.wallpapers;

  icons = findFiles {
    dir = ./assets/icons;
    extensions = [
      "ico"
      "icns"
    ];
  };

  # Create scripts for every script file
  scriptBin =
    # (nix is maximally lazy so this is only run if and when a script is added to the packages)
    attrsets.mapAttrsRecursive (
      path: value:
      let
        filename = lists.last path;
      in
      {
        rename ? filename,
        deps ? [ ],
        shell ? false,
      }:
      writeScriptWithDeps {
        name = rename;
        text = (builtins.readFile value);
        inherit deps shell;
      }
      # (Ignores all _dir attributes)
    ) (attrsets.filterAttrsRecursive (n: v: n != "_dir") scripts);
}
