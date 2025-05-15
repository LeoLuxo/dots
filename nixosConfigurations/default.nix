{
  inputs,
  lib,
  moduleArgs,
  ...
}:

let
  extraArgs =
    value:
    let
      createPkgs =
        nixpkgs:
        import nixpkgs {
          inherit (value) system;
          config.allowUnfree = true;
        };
    in
    value
    // {
      # Give every nixos configuration access to speciliazed pkgs for every nixpkgs
      specialArgs = {
        pkgs-stable = createPkgs inputs.nixpkgs-stable;
        pkgs-unstable = createPkgs inputs.nixpkgs-unstable;
        pkgs-24-05 = createPkgs inputs.nixpkgs-24-05;
        pkgs-24-11 = createPkgs inputs.nixpkgs-24-11;
      };
    };

  importDir =
    path:
    lib.concatMapAttrs (
      name: type:
      let
        attrName = lib.removePrefix "_" (lib.removeSuffix ".nix" name);
        fullPath = path + "/${name}";
        isFile = type == "regular";
        isFileNotDefault = isFile && name != "default.nix";
        isDirWithDefault = type == "directory" && lib.pathExists (fullPath + "/default.nix");
      in
      if isFileNotDefault || isDirWithDefault then
        # Import the nixos configuration
        # and add the extraArgs to it
        { ${attrName} = extraArgs (import fullPath moduleArgs); }
      else
        { }
    ) (builtins.readDir path);
in

importDir ./.
