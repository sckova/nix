{
  lib,
  pkgs,
  inputs,
  pkgs-unstable,
  ...
}:
{
  imports = [
    ./firefox
    ./mpv.nix
    ./thunderbird.nix
  ];

  home.packages =
    with pkgs;
    with nur.repos.forkprince;
    [
      helium-nightly # web browser
      # google-chrome # proprietary web browser
      # audacity # audio tool
      pkgs-unstable.musescore # music scoring
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      calibre # ebook tool
      nautilus # file browser
      fractal # matrix client
      tuba # mastodon client
      snapshot # webcam tool
      loupe # image viewer
      gimp # image editor
      libreoffice-fresh # office suite
      papers # GNOME's document viewer
      gapless # music player
      (inputs.arnis.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
        cargoDeps = pkgs.rustPlatform.importCargoLock {
          lockFile = "${inputs.arnis}/Cargo.lock";

          outputHashes = {
            "bedrockrs_core-0.1.0" = "sha256-0HP6p2x6sulZ2u8FzEfAiNAeyaUjQQWgGyK/kPo0PuQ=";
            "dda-voxelize-0.2.0-alpha.1" = "sha256-MiSvqlzvezp7TXIDZl7+/x+zCPcsbFo2hhMWBJKqvaE=";
            "nbtx-0.1.0" = "sha256-JoNSL1vrUbxX6hKWB4i/DX02+hsQemANJhQaEELlT2o=";
          };
        };
      }))
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isLinux) [
      iina # media player
      gimp2 # image editor
      libreoffice-bin # office suite
    ];
}
