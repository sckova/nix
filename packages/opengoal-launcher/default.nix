# packages/opengoal-launcher/default.nix
{
  lib,
  SDL2,
  alsa-lib,
  buildFHSEnv,
  cmake,
  fetchFromGitHub,
  fetchYarnDeps,
  fixup-yarn-lock,
  gtk3,
  libGL,
  libGLU,
  libayatana-appindicator,
  libpulseaudio,
  librsvg,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxinerama,
  libxkbcommon,
  libxrandr,
  nodejs,
  openssl,
  pkg-config,
  rustPlatform,
  udev,
  wayland,
  wayland-protocols,
  webkitgtk_4_1,
  wrapGAppsHook3,
  writeShellScript,
  yarn,
}:

let
  src = fetchFromGitHub {
    hash = "sha256-8ceTadkf1E4uTrxkLj131KoBf34GuIiku1CCqyLwbwU=";
    owner = "open-goal";
    repo = "launcher";
    rev = "v${version}";
  };
  unwrapped = rustPlatform.buildRustPackage {
    inherit version src;
    buildAndTestSubdir = "src-tauri";

    buildInputs = [
      webkitgtk_4_1
      gtk3
      libayatana-appindicator
      librsvg
      openssl
    ];

    cargoLock.lockFile = "${src}/src-tauri/Cargo.lock";
    cargoRoot = "src-tauri";
    doCheck = false;

    nativeBuildInputs = [
      pkg-config
      cmake
      nodejs
      yarn
      fixup-yarn-lock
      wrapGAppsHook3
    ];

    pname = "opengoal-launcher-unwrapped";

    preBuild = ''
      export HOME="$(mktemp -d)"
      yarn config set yarn-offline-mirror "$yarnOfflineCache"
      fixup-yarn-lock yarn.lock
      unset NODE_ENV
      yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --production=false
      patchShebangs node_modules
      yarn build
    '';

    yarnOfflineCache = fetchYarnDeps {
      hash = "sha256-be8jhKeVkomrYFjYu/cM21mCDRRysjbtUUW9+MWB4Fo=";
      yarnLock = "${src}/yarn.lock";
    };
  };
  version = "2.10.4";
in
buildFHSEnv {
  extraInstallCommands = ''
    install -Dm644 ${unwrapped.src}/src-tauri/icons/128x128.png \
      $out/share/icons/hicolor/128x128/apps/opengoal-launcher.png
    install -Dm644 /dev/stdin $out/share/applications/opengoal-launcher.desktop <<EOF
    [Desktop Entry]
    Type=Application
    Name=OpenGOAL Launcher
    Comment=Launcher for the OpenGOAL project (Jak & Daxter decompilation toolchain)
    Exec=$out/bin/opengoal-launcher
    Icon=opengoal-launcher
    Categories=Game;
    Terminal=false
    EOF
  '';

  name = "opengoal-launcher";
  passthru.unwrapped = unwrapped;

  runScript = writeShellScript "opengoal-launcher-run" ''
    set -euo pipefail
    bin="$(find "${unwrapped}/bin" -maxdepth 1 -type f -executable | head -n1)"
    exec "$bin" "$@"
  '';

  targetPkgs = pkgs: [
    unwrapped
    webkitgtk_4_1
    gtk3
    libayatana-appindicator
    librsvg
    openssl
    SDL2
    libGL
    libGLU
    libpulseaudio
    alsa-lib
    libx11
    libxrandr
    libxinerama
    libxcursor
    libxi
    libxcb
    wayland
    wayland-protocols
    libxkbcommon
    udev
  ];

  meta = with lib; {
    description = "Launcher for the OpenGOAL project (Jak & Daxter decompilation toolchain), run in an FHS env";
    homepage = "https://github.com/open-goal/launcher";
    license = licenses.isc;
    mainProgram = "opengoal-launcher";
    platforms = platforms.linux;
  };
}
