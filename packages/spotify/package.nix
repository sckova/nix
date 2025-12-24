{
  lib,
  stdenv,
  makeDesktopItem,
  copyDesktopItems,
  chromium,
  writeShellScriptBin,
}: let
  pname = "spotify-webapp";
  version = "1.0.0";

  chromiumWithWidevine = chromium.override {
    enableWideVine = true;
  };

  launchScript = writeShellScriptBin "spotify-webapp" ''
    exec ${chromiumWithWidevine}/bin/chromium \
      --app=https://open.spotify.com \
      --class=spotify-webapp \
      --name=spotify-webapp \
      --user-data-dir="$HOME/.config/spotify-webapp" \
      --enable-features=UseOzonePlatform \
      --ozone-platform=wayland \
      "$@"
  '';
in
  stdenv.mkDerivation {
    inherit pname version;

    dontUnpack = true;
    dontBuild = true;

    nativeBuildInputs = [copyDesktopItems];

    desktopItems = [
      (makeDesktopItem {
        name = "spotify-webapp";
        exec = "spotify-webapp %U";
        icon = "spotify";
        desktopName = "Spotify";
        genericName = "Music Streaming";
        comment = "Listen to music on Spotify";
        categories = [
          "Audio"
          "Music"
          "AudioVideo"
        ];
        mimeTypes = ["x-scheme-handler/spotify"];
        startupWMClass = "spotify-webapp";
        startupNotify = true;
      })
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      ln -s ${launchScript}/bin/spotify-webapp $out/bin/spotify-webapp

      runHook postInstall
    '';

    meta = with lib; {
      description = "Spotify web app running in Chromium";
      homepage = "https://open.spotify.com";
      license = licenses.free;
      maintainers = [];
      platforms = platforms.linux;
      mainProgram = "spotify-webapp";
    };
  }
