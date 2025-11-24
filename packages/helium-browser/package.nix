{
  stdenv,
  lib,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  autoPatchelfHook,
  makeWrapper,

  helium-widevine,

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
  gsettings-desktop-schemas,
  gtk3,
}:
let
  architectures = {
    "x86_64-linux" = {
      arch = "x86_64";
      hash = "sha256-VB218vOY/9tI97Yhx2MNlNPb46jJHv/FqY96tJaokBE=";
    };
    "aarch64-linux" = {
      arch = "arm64";
      hash = "sha256-SApc3CSrYm6MSRgqtJS7IckUVJuoWeUMUgGxqgKakBg=";
    };
  };

  platformInfo =
    architectures.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

in
stdenv.mkDerivation rec {
  pname = "helium-browser";
  version = "0.6.7.1";
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
    gsettings-desktop-schemas
    gtk3
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


    cp -r ${helium-widevine}/share/helium/WidevineCdm $out/opt/helium/

    makeWrapper $out/opt/helium/chrome-wrapper $out/bin/helium-browser \
      --chdir $out/opt/helium \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}" \
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
