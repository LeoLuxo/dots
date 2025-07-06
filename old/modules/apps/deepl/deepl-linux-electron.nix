{
  lib,
  pkgs,
  constants,
  config,
  ...
}:

{
  # Package for https://github.com/kumakichi/Deepl-linux-electron
  nixpkgs.overlays = [
    (
      final: prev: with pkgs; {
        deepl-linux-electron = stdenv.mkDerivation (finalAttrs: {
          pname = "Deepl-Linux-Electron";
          version = "1.5.0";

          src = fetchFromGitHub {
            owner = "kumakichi";
            repo = "Deepl-linux-electron";
            rev = "v${finalAttrs.version}";
            hash = "sha256-L8lFljQBMUK5TmFlQqCQI69oVaox0cTgYMBYByowdGk=";
          };

          offlineCache = fetchYarnDeps {
            yarnLock = "${finalAttrs.src}/yarn.lock";
            hash = lib.fakeHash;
          };

          nativeBuildInputs = [
            yarn
            fixup-yarn-lock
            nodejs
          ];

          configurePhase = ''
            runHook preConfigure

            export HOME=$(mktemp -d)

            yarn generate-lock-entry --offline

            yarn config --offline set yarn-offline-mirror ${finalAttrs.offlineCache}
            fixup-yarn-lock yarn.lock
            yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
            patchShebangs node_modules/

            runHook postConfigure
          '';

          # Build the package
          buildPhase = ''
            runHook preBuild

            export HOME=$(mktemp -d)
            yarn --offline build

            runHook postBuild
          '';

        });
      }
    )
  ];

  # Add dark mode css
  home-manager.users.${config.my.user.name}.xdg.configFile."Deepl-Linux-Electron/user_theme.css".text =
    ''
      html {
        filter: invert(90%) hue-rotate(180deg) brightness(110%) contrast(110%);
        background: white;
      }
    '';
}
