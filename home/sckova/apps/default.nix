{ pkgs, ... }:
{
  imports = [
    ./firefox.nix
    ./mpv.nix
  ];

  home.packages = with pkgs; [
    # gui applications
    libreoffice-qt-fresh
    nur.repos.forkprince.helium-nightly
    nautilus
    fractal
    tuba

    # gui applications ( multimedia )
    audacity
    strawberry
    musescore
    gimp
    calibre
    loupe
  ];
}
