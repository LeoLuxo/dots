{
  pkgs,
  lib,
  lib2,
}:

let
  inherit (lib2) replaceScriptVariables toPascalCaseWithSpaces;
in
rec {
  # Write a script just like pkgs.writeShellScriptBin and pkgs.writeScriptBin, but optionally add some dependencies.
  # Is automatically wrapped in another script with the deps on the PATH.
  writeScriptWithDeps =
    {
      name,
      file ? null,
      text ? builtins.readFile file,
      deps ? [ ],
      addBashShebang ? false,
      binFolder ? true,
      replaceVariables ? { },
      elevate ? false,
    }:
    let
      scriptTextPreVars = lib.throwIf (text == null) "script needs text" text;
      scriptText = replaceScriptVariables scriptTextPreVars replaceVariables;

      # https://nixos.org/manual/nixpkgs/unstable/#trivial-builder-text-writing
      innerBuilder = if addBashShebang then pkgs.writeShellScript else pkgs.writeScript;
      outerBuilder = if binFolder then pkgs.writeShellScriptBin else pkgs.writeShellScript;

      # Using sudo to elevate the script
      elevation = if elevate then ''sudo'' else "";
    in
    outerBuilder name ''
      for i in ${lib.strings.concatStringsSep " " deps}; do
        export PATH="$i/bin:$PATH"
      done

      exec ${elevation} ${innerBuilder "${name}-no-deps" scriptText} $@
    '';

  # Write a nushell script akin to writeScriptWithDeps
  writeNushellScript =
    {
      name,
      file ? null,
      text ? null,
      deps ? [ ],
      elevate ? false,
      binFolder ? true,
    }@args:
    writeScriptWithDeps (
      args
      // {
        addBashShebang = false;
        text =
          if file == null then
            ''
              #!${pkgs.nushell}/bin/nu
              ${lib.throwIf (text == null) "script needs text" text}
            ''
          else
            ''
              #!${pkgs.bash}/bin/bash
              ${pkgs.nushell}/bin/nu ${file}
            '';
      }
    );

  mkDesktopItem =
    {
      package ? null,
      name ? package.name or package.pname,
      desktopName ? toPascalCaseWithSpaces name,
      exec ? "${package}/bin/${name}",
      icon ? null,
      keywords ? [ name ],
      categories ? [ ],
      elevate ? false,
    }:
    let
      # Using pkexec to elevate the script using the GUI-sudo-thing
      wrappedExec =
        if elevate then
          # Need to create an entire wrapped script because gnome complain about $ in the Exec field
          "${
            (writeScriptWithDeps {
              name = "${name}-desktop-icon-wrapper";
              text = ''pkexec env XAUTHORITY=$XAUTHORITY DISPLAY=$DISPLAY WAYLAND_DISPLAY=$WAYLAND_DISPLAY PATH=$PATH ${exec}'';
            })
          }/bin/${name}-desktop-icon-wrapper"
        else
          exec;

      desktopItemPackage =
        {
          stdenv,
          makeDesktopItem,
          copyDesktopItems,
        }:
        stdenv.mkDerivation (finalAttrs: {
          pname = "${name}-desktop-icon";
          version = "0.0.0";
          dontUnpack = true;
          nativeBuildInputs = [ copyDesktopItems ];
          desktopItems = (
            makeDesktopItem {
              inherit
                name
                desktopName
                icon
                keywords
                categories
                ;
              exec = wrappedExec;
            }
          );
        });
    in
    (pkgs.callPackage desktopItemPackage { });
}
