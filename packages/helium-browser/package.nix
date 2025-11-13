{
  stdenv,
  lib,
  appimageTools,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
}:
let
  pname = "helium-browser";
  version = "0.6.4.1";

  architectures = {
    "x86_64-linux" = {
      arch = "x86_64";
      hash = lib.fakeHash;
    };
    "aarch64-linux" = {
      arch = "arm64";
      hash = "sha256-B63tvOtSRlMRJozvzC7lqG2LM0ZgLIq2G/AHABl+Qqg=";
    };
  };

  src =
    let
      inherit (architectures.${stdenv.hostPlatform.system}) arch hash;
    in
    fetchurl {
      url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-${arch}.AppImage";
      inherit hash;
    };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;
  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/helium.desktop -t $out/share/applications
    install -Dm444 ${appimageContents}/helium.png -t $out/share/pixmaps

    substituteInPlace $out/share/applications/helium.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}' \
      --replace-fail 'Icon=helium' 'Icon=web-browser'
  '';
  meta = {
    description = "A private, respectful browser";
    homepage = "https://github.com/imputnet/helium-linux";
    downloadPage = "https://github.com/imputnet/helium-linux/releases";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.attrNames architectures;
  };
}
