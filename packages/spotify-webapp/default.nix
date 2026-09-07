# packages/spotify-webapp/default.nix
{
  lib,
  chromium,
  copyDesktopItems,
  makeDesktopItem,
  stdenv,
  writeShellScriptBin,
}:
let
  chromiumWithWidevine = chromium.override {
    enableWideVine = true;
  };
  pname = "spotify-webapp";
  version = "1.0.0";
in
stdenv.mkDerivation {
  inherit pname version;

  desktopItems = [
    (makeDesktopItem {
      categories = [
        "Audio"
        "Music"
        "AudioVideo"
      ];

      comment = "Listen to music on Spotify";
      desktopName = "Spotify";
      exec = "spotify-webapp %U";
      genericName = "Music Streaming";
      icon = "spotify";
      mimeTypes = [ "x-scheme-handler/spotify" ];
      name = "spotify-webapp";
      startupNotify = true;
      startupWMClass = "spotify-webapp";
    })
  ];

  dontBuild = true;
  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    ln -s ${writeShellScriptBin "spotify-webapp" ''
      exec ${chromiumWithWidevine}/bin/chromium \
        --app=https://open.spotify.com \
        --class=spotify-webapp \
        --name=spotify-webapp \
        --user-data-dir="$HOME/.config/spotify-webapp" \
        --enable-features=UseOzonePlatform \
        --ozone-platform=wayland \
        "$@"
    ''}/bin/spotify-webapp $out/bin/spotify-webapp

    runHook postInstall
  '';

  nativeBuildInputs = [ copyDesktopItems ];

  meta = with lib; {
    description = "Spotify web app running in Chromium";
    homepage = "https://open.spotify.com";
    license = licenses.free;
    mainProgram = "spotify-webapp";
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
