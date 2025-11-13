{
  stdenv,
  lib,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  autoPatchelfHook,
  makeWrapper,

  # runtime dependencies
  xorg,
  libGL,
  mesa,
  cairo,
  pango,
  systemd,
  alsa-lib,
  gcc-unwrapped,
  qt5,
  qt6,
  glib,
  nspr,
  nss,
  at-spi2-atk,
  at-spi2-core,
  cups,
}:
let
  architectures = {
    "x86_64-linux" = {
      arch = "x86_64";
      hash = "sha256-9xEVnGym579rR6RunS4HWYV3nLk1ODEIGfg8PtNDSUk=";
    };
    "aarch64-linux" = {
      arch = "arm64";
      hash = "sha256-S5kF+K2Kwhqa0GG691NvnU/2frUCWL9BKrVK7y3bzSE=";
    };
  };

  platformInfo =
    architectures.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

in
stdenv.mkDerivation rec {
  pname = "helium-browser";
  version = "0.6.4.1";
  xzName = "helium-${version}-${platformInfo.arch}_linux";

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/${xzName}.tar.xz";
    hash = platformInfo.hash;
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb
    xorg.libXdamage
    xorg.libXcomposite
    mesa
    cairo
    pango
    systemd
    alsa-lib
    gcc-unwrapped.lib
    qt5.qtbase.out
    qt6.qtbase.out
    glib
    nspr
    nss
    at-spi2-atk
    at-spi2-core
    cups
  ];

  dontWrapQtApps = true;

  unpackPhase = ''
    runHook preUnpack
    tar xf $src
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/helium
    mv ${xzName}/helium.desktop .
    mv ${xzName}/product_logo_256.png .
    cp -r ${xzName}/* $out/opt/helium/
    chmod +x $out/opt/helium/chrome-wrapper $out/opt/helium/chrome

    makeWrapper $out/opt/helium/chrome-wrapper $out/bin/helium-browser \
      --chdir $out/opt/helium \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libGL
          mesa
        ]
      }"

    install -Dm644 product_logo_256.png $out/share/icons/hicolor/256x256/apps/helium.png
    install -Dm644 helium.desktop $out/share/applications/helium.desktop
    substituteInPlace $out/share/applications/helium.desktop \
      --replace-fail 'Exec=chromium' "Exec=$out/bin/helium-browser" \

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://helium.computer";
    description = "Helium web browser";
    platforms = platforms.linux;
    mainProgram = "helium";
  };
}
