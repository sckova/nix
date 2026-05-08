{ pkgs, ... }:
{
  imports = [
    ./firefox.nix
    ./mpv.nix
  ];

  home.packages = with pkgs; [
    libreoffice-qt-fresh # office suite
    nur.repos.forkprince.helium-nightly # web browser
    nautilus # file browser
    fractal # matrix client
    tuba # mastodon client
    snapshot # webcam tool
    audacity # audio tool
    strawberry # mp3 player
    musescore # music scoring
    gimp # image editor
    calibre # ebook tool
    loupe # image viewer
  ];
}
