{
  lib,
  SDL2,
  alsa-lib,
  buildFHSEnv,
  cmake,
  draco,
  fetchFromGitHub,
  libGL,
  libGLU,
  libpulseaudio,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxinerama,
  libxkbcommon,
  libxrandr,
  llvmPackages,
  nasm,
  ninja,
  openssl,
  pkg-config,
  python3,
  udev,
  wayland,
  wayland-protocols,
  writeShellScript,
}:

let
  # `opengoal gk ...` / `opengoal goalc ...` / `opengoal extractor ...`
  # all resolve to the matching binary in unwrapped's $out/bin.
  runScript = writeShellScript "opengoal-run" ''
    set -euo pipefail
    bindir="${unwrapped}/bin"
    if [ "$#" -eq 0 ]; then
      exec "$bindir/gk"
    fi
    bin="$1"; shift
    exec "$bindir/$bin" "$@"
  '';
  # Pin explicitly — don't track a branch. To bump: set `rev` to a real
  # commit sha, set `hash = lib.fakeHash;`, build once, and paste in the
  # real hash from the mismatch error.
  src = fetchFromGitHub {
    fetchSubmodules = true;
    hash = "sha256-gKJa2RGXbHIGjyFNS6pLa+f9CyOtiZ5b41/3YhFNnLM=";
    owner = "open-goal";
    repo = "jak-project";
    rev = "v0.3.6";
  };
  # Upstream's CMakePresets.json defines "Release-linux-clang" and builds
  # with clang/lld explicitly, not gcc — llvmPackages' stdenv keeps that
  # consistent across nativeBuildInputs and the compiler itself.
  unwrapped = llvmPackages.stdenv.mkDerivation {
    inherit src;

    buildInputs = [
      SDL2
      libGL
      libGLU
      openssl
      libpulseaudio
      alsa-lib
      libx11
      libxcb
      libxrandr
      libxinerama
      libxcursor
      libxi
      draco
    ];

    buildPhase = ''
      runHook preBuild
      cmake --build build/Release/bin --parallel "$NIX_BUILD_CORES"
      runHook postBuild
    '';

    configurePhase = ''
      runHook preConfigure
      cmake --preset Release-linux-clang -DCMAKE_INSTALL_PREFIX=$out
      runHook postConfigure
    '';

    dontUseCmakeConfigure = true;

    installPhase = ''
      runHook preInstall
      # google/draco's install() rule for draco_features.h expects a header
      # generated at $CMAKE_BINARY_DIR/draco/draco_features.h, but that
      # generation step never runs when draco is vendored via
      # add_subdirectory() rather than built standalone — reproduced
      # independently for the same embedding pattern in
      # KhronosGroup/COLLADA2GLTF#289. Nothing in this build actually
      # #includes the header (buildPhase completes cleanly without it),
      # so a placeholder satisfies the install rule without affecting
      # anything that gets compiled.
      mkdir -p build/Release/bin/draco
      touch build/Release/bin/draco/draco_features.h
      cmake --install build/Release/bin
      runHook postInstall
    '';

    nativeBuildInputs = [
      cmake
      ninja
      nasm
      python3
      pkg-config
    ];

    pname = "opengoal-unwrapped";
    version = "unstable-2026-09-07";
  };
in
buildFHSEnv {
  name = "opengoal";
  passthru.unwrapped = unwrapped;
  runScript = "${runScript}";

  targetPkgs = pkgs: [
    unwrapped
    SDL2
    libGL
    libGLU
    openssl
    draco
    libpulseaudio
    alsa-lib
    libxcb
    libx11
    libxrandr
    libxinerama
    libxcursor
    libxi
    # Wayland/Niri-native SDL2 video driver, rather than relying on Xwayland
    wayland
    wayland-protocols
    libxkbcommon
    # Gamepad support (SDL2 controller DB reads udev)
    udev
  ];

  meta = with lib; {
    description = "OpenGOAL toolchain (goalc/gk/extractor) for Jak & Daxter, built from source and run in an FHS env";
    homepage = "https://github.com/open-goal/jak-project";
    license = licenses.isc;
    platforms = platforms.linux;
  };
}
