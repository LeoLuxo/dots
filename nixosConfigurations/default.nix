{
  inputs,
  lib,
  lib2,
  ...
}:
let
  mkPkgsOverlay =
    name: nixpkgs:
    (final: prev: {
      ${name} = import nixpkgs {
        inherit prev;
        system = prev.system;
        config.allowUnfree = true;
      };
    });

  hostOverlays = [
    # Some extra instances of pkgs, so that my nixosConfigurations can pin packages more easily.
    # Can be used via:
    # ```
    #   packages = [ pkgs.unstable.firefox ];
    # ```
    (mkPkgsOverlay "stable" inputs.nixpkgs-stable)
    (mkPkgsOverlay "unstable" inputs.nixpkgs-unstable)
    (mkPkgsOverlay "25-05" inputs.nixpkgs-25-05)
    (mkPkgsOverlay "24-11" inputs.nixpkgs-24-11)
    (mkPkgsOverlay "24-05" inputs.nixpkgs-24-05)

    # Add my custom builders, accessible under `pkgs.<builder>`
    (
      final: prev:
      import ../builders.nix {
        inherit lib lib2;
        pkgs = prev;
      }
    )
  ];

  mkHost =
    user: hostname: module:
    inputs.nixpkgs.lib.nixosSystem (
      let
        #   # Sanitize a path so that it doesn't cause problems in the nix store
        #   sanitizePath =

        #     path:
        #     let
        #       inherit (lib) strings;
        #     in
        #     builtins.path {
        #       inherit path;
        #       name = strings.sanitizeDerivationName (builtins.baseNameOf path);
        #     };

        #   # Recursively find modules in a given directory and map them to a logical set:
        #   # dir/a/b/file.ext         => .a.b.file
        #   # dir/a/b/file/default.nix => .a.b.file
        #   findFiles =
        #     {
        #       dir,
        #       extensions,
        #       defaultFiles ? [ ],
        #     }:
        #     let
        #       inherit (lib) strings attrsets;

        #       extRegex = "(${strings.concatStrings (strings.intersperse "|" extensions)})";
        #       ignore = name: {
        #         name = "";
        #         value = null;
        #       };

        #       findFilesRecursive =
        #         dir:
        #         attrsets.filterAttrs
        #           # filter out ignored files/dirs
        #           (n: v: v != null)
        #           (
        #             attrsets.mapAttrs' (
        #               fileName: type:
        #               let
        #                 extMatch = builtins.match "(.*)\\.${extRegex}" fileName;
        #                 filePath = dir + "/${fileName}";
        #               in
        #               # If regular file, then add it to the file list only if the extension regex matches
        #               if type == "regular" then
        #                 if extMatch == null then
        #                   ignore fileName
        #                 else
        #                   {
        #                     # Filename without the extension
        #                     name = builtins.elemAt extMatch 0;
        #                     value = filePath;
        #                   }
        #               # If directory, ...
        #               else if type == "directory" then
        #                 let
        #                   # ... then search for a default file (ie. default.nix, ...)
        #                   files = builtins.readDir filePath;
        #                   hasDefault = builtins.any (defaultFile: files ? ${defaultFile}) defaultFiles; # builtins.any returns false given an empty list
        #                 in
        #                 # if a default file exists, add the directory to our file list
        #                 if hasDefault then
        #                   {
        #                     name = fileName;
        #                     value = filePath;
        #                   }
        #                 else
        #                   # otherwise search recursively in the directory,
        #                   # and map the results to a nested set with the name of the folder as top key.
        #                   # Also add the base directory path under the _dir key
        #                   {
        #                     name = fileName;
        #                     value = findFilesRecursive filePath // {
        #                       _dir = filePath;
        #                     };
        #                   }
        #               else
        #                 # any other file types we ignore (i.e. symlink and unknown)
        #                 ignore fileName
        #             ) (builtins.readDir dir)
        #           );
        #     in
        #     findFilesRecursive (sanitizePath dir);

        #   nixosModulesOld = findFiles {
        #     dir = ../old/modules;
        #     extensions = [ "nix" ];
        #     defaultFiles = [ "default.nix" ];
        #   };

        nixosModulesOld = inputs.self.nixosModules;
      in
      {
        modules = [
          module
          { nixpkgs.overlays = hostOverlays; }
        ];

        # Additional args passed to the modules
        specialArgs = {
          inherit
            inputs
            lib2
            hostname
            user
            ;

          # TODO remove
          inherit nixosModulesOld;
        };
      }
    );

in
{
  # Personal desktop computer
  coffee = mkHost "lili" "coffee" ./hosts/coffee;

  # Surface Pro 7 laptop
  pancake = mkHost "lili" "pancake" ./hosts/pancake;
}
