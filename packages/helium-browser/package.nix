# taken (stolen?) from two places:
# https://github.com/fpletz/flake/blob/main/pkgs/by-name/helium-browser.nix
# https://github.com/nix-community/nur-combined/blob/main/repos/Ev357/pkgs/helium/default.nix
# so shoutout those guys
{
  stdenv,
  lib,
  appimageTools,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  widevine-helium ? null,
}:
let
  pname = "helium-browser";
  version = "0.6.4.1";

  architectures = {
    "x86_64-linux" = {
      arch = "x86_64";
      hash = "sha256-DlEFuFwx2Qjr9eb6uiSYzM/F3r2hdtkMW5drJyJt/YE=";
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

  appImageContents = appimageTools.extractType2 { inherit pname version src; };

in
appimageTools.wrapType2 {
  inherit pname version src;
  extraInstallCommands = ''
    mkdir -p "$out/share/applications"
    mkdir -p "$out/share/lib/helium"
    cp -r ${appImageContents}/opt/helium/locales "$out/share/lib/helium"
    cp -r ${appImageContents}/usr/share/* "$out/share"
    cp "${appImageContents}/helium.desktop" "$out/share/applications/"
    substituteInPlace $out/share/applications/helium.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname} \
      --replace-fail 'Icon=helium' 'Icon=web-browser

      ${lib.optionalString (stdenv.hostPlatform.system == "aarch64-linux") ''
        cp -r ${widevine-helium}/share/helium/WidevineCdm "$out/share/lib/helium/"
      ''}
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
