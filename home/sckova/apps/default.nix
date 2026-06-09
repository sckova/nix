{ pkgs, ... }:
{
  imports = [
    ./firefox
    ./mpv.nix
  ];
  home.packages =
    with pkgs;
    [
      (if stdenv.isLinux then libreoffice-qt-fresh else libreoffice-bin)
      nur.repos.forkprince.helium-nightly # web browser
      audacity # audio tool
      musescore # music scoring
      (if stdenv.isLinux then gimp else gimp2) # image editor
    ]
    ++ lib.optionals stdenv.isLinux [
      calibre # ebook tool
      strawberry # mp3 player
      nautilus # file browser
      fractal # matrix client
      tuba # mastodon client
      snapshot # webcam tool
      loupe # image viewer
    ]
    ++ lib.optionals stdenv.isDarwin [
      iina # media player
    ];
}
