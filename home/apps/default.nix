{ pkgs, ... }:
{
  imports = [
    # ./discord.nix
    ./firefox.nix
    ./mpv.nix
    # ./vscode.nix
  ];

  home.packages = with pkgs; [
    # gui applications
    input-leap
    libreoffice-qt-fresh
    # nur.repos.forkprince.helium-nightly
    nautilus
    fractal
    tuba

    # gui applications ( multimedia )
    audacity
    strawberry
    musescore
    gimp
    # calibre
    # riff
    dissent
    loupe
    spotify-player

    # overrides
    (chromium.override {
      enableWideVine = true;
    })
  ];
}
