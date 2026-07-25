{
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  imports = [
    ./firefox
    ./mpv.nix
  ];

  home.packages =
    with pkgs;
    with nur.repos.forkprince;
    [
      helium-nightly # web browser
      audacity # audio tool
      pkgs-unstable.musescore # music scoring
    ]
    ++ lib.optionals stdenv.isLinux [
      calibre # ebook tool
      strawberry # mp3 player
      nautilus # file browser
      fractal # matrix client
      tuba # mastodon client
      snapshot # webcam tool
      loupe # image viewer
      gimp # image editor
      libreoffice-fresh # office suite
    ]
    ++ lib.optionals stdenv.isDarwin [
      iina # media player
      gimp2 # image editor
      libreoffice-bin # office suite
    ];
}
