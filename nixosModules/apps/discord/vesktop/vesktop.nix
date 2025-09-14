{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  makeBinaryWrapper,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  vencord,
  electron,
  libicns,
  pipewire,
  libxkbcommon,
  libX11,
  libXtst,
  libpulseaudio,
  autoPatchelfHook,
  pnpm_10,
  nodejs,
  nix-update-script,
  withTTS ? true,
  withMiddleClickScroll ? false,
  # Enables the use of vencord from nixpkgs instead of
  # letting vesktop manage it's own version
  withSystemVencord ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vesktop";
  version = "1.5.8";

  # src = fetchFromGitHub {
  #   owner = "Vencord";
  #   repo = "Vesktop";
  #   rev = "v${finalAttrs.version}";
  #   hash = "sha256-9wYIg1TGcntUMMp6SqYrgDRl3P41eeOqt76OMjSAi5M=";
  # };

  src = fetchFromGitHub {
    owner = "tuxinal";
    repo = "Vesktop";
    rev = "25963c66bed4643377044dea36e44ee68d13a3c8";
    hash = "sha256-7u3kmpgCWCj+0sSxCg8cylulWVv8oAW6H5jy8f4o+tQ=";
  };

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      ;
    fetcherVersion = 2;
    hash = "sha256-Xmcx0hWS5F4nEi83Hc6BvRu7Okw3LTwa7zGU3rJ+Udk=";
  };

  nativeBuildInputs =
    [
      nodejs
      pnpm_10.configHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      # vesktop uses venmic, which is a shipped as a prebuilt node module
      # and needs to be patched
      autoPatchelfHook
      copyDesktopItems

      # we use a script wrapper here for environment variable expansion at runtime
      # https://github.com/NixOS/nixpkgs/issues/172583
      makeWrapper
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # on macos we don't need to expand variables, so we can use the faster binary wrapper
      makeBinaryWrapper
    ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libpulseaudio
    pipewire
    (lib.getLib stdenv.cc.cc)

    # Needed for the globalShortcuts patch
    libxkbcommon
    libX11
    libXtst
  ];

  patches = [
    ./patches/disableUpdateChecking.patch
    # ./patches/fixReadOnlySettings.patch
  ];
  # ++ lib.optional withSystemVencord (
  #   replaceVars ./patches/useSystemVencord.patch {
  #     inherit vencord;
  #   }
  # );

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  # disable code signing on macos
  # https://github.com/electron-userland/electron-builder/blob/77f977435c99247d5db395895618b150f5006e8f/docs/code-signing.md#how-to-disable-code-signing-during-the-build-process-on-macos
  postConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export CSC_IDENTITY_AUTO_DISCOVERY=false
  '';

  # electron builds must be writable on darwin
  preBuild =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      cp -r ${electron.dist}/Electron.app .
      chmod -R u+w Electron.app

    ''
    + ''
      cp -f "${./assets/discord.png}" build/Icon.png

      cp -f "${./assets/discord.png}" static/icon.png
      cp -f "${./assets/discord.ico}" static/icon.ico

      # Dancing anime gif
      cp -f "${./assets/bongo-cat.gif}" static/shiggy.gif
    '';

  buildPhase = ''
    runHook preBuild

    pnpm build
    pnpm exec electron-builder \
      --dir \
      -c.asarUnpack="**/*.node" \
      -c.electronDist=${if stdenv.hostPlatform.isDarwin then "." else electron.dist} \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  postBuild = lib.optionalString stdenv.hostPlatform.isLinux ''
    pushd build
    ${libicns}/bin/icns2png -x icon.icns
    popd
  '';

  preInstall = ''
    rm build/icon_*x32.png
    cp "${./assets/discord.png}" build/icon_512x512x32.png
  '';

  installPhase =
    ''
      runHook preInstall
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p $out/opt/Vesktop
      cp -r dist/*unpacked/resources $out/opt/Vesktop/

      for file in build/icon_*x32.png; do
        file_suffix=''${file//build\/icon_}
        install -Dm0644 $file $out/share/icons/hicolor/''${file_suffix//x32.png}/apps/vesktop.png
      done
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/{Applications,bin}
      mv dist/mac*/Vesktop.app $out/Applications/Vesktop.app
    ''
    + ''
      runHook postInstall
    '';

  postFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      makeWrapper ${electron}/bin/electron $out/bin/vesktop \
        --add-flags $out/opt/Vesktop/resources/app.asar \
        ${lib.strings.optionalString withTTS ''
          --run 'if [[ "''${NIXOS_SPEECH:-default}" != "False" ]]; then NIXOS_SPEECH=True; else unset NIXOS_SPEECH; fi' \
          --add-flags "\''${NIXOS_SPEECH:+--enable-speech-dispatcher}" \
        ''} \
        ${lib.optionalString withMiddleClickScroll "--add-flags \"--enable-blink-features=MiddleClickAutoscroll\""} \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      makeWrapper $out/Applications/Vesktop.app/Contents/MacOS/Vesktop $out/bin/vesktop
    '';

  desktopItems = lib.optional stdenv.hostPlatform.isLinux (makeDesktopItem {
    name = "vesktop";
    desktopName = "Discord";
    exec = "vesktop %U";
    icon = "vesktop";
    startupWMClass = "Discord";
    genericName = "Internet Messenger";
    keywords = [
      "discord"
      "vencord"
      "vesktop"
      "electron"
      "chat"
    ];
    categories = [
      "Network"
      "InstantMessaging"
      "Chat"
    ];
  });

  passthru = {
    inherit (finalAttrs) pnpmDeps;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Alternate client for Discord with Vencord built-in";
    homepage = "https://github.com/Vencord/Vesktop";
    changelog = "https://github.com/Vencord/Vesktop/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      getchoo
      Scrumplex
      vgskye
      pluiedev
    ];
    mainProgram = "vesktop";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
