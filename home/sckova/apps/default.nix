# home/sckova/apps/default.nix
{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./discord
    ./firefox
    ./ghostty.nix
    ./video
  ];

  home.packages =
    with pkgs;
    with nur.repos.forkprince;
    [
      # audacity # audio tool
      # google-chrome # proprietary web browser
      # helium-nightly # web browser
      musescore # music scoring
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      calibre # ebook tool
      file-roller # archive utility
      fractal # matrix client
      gapless # music player
      gimp # image editor
      libreoffice-stable # office suite
      loupe # image viewer
      nautilus # file browser
      papers # GNOME's document viewer
      snapshot # webcam tool
      tuba # mastodon client
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isLinux) [
      gimp2 # image editor
      iina # media player
      libreoffice-bin # office suite
    ];
}
