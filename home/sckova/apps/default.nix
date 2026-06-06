{ pkgs, ... }:
{
  imports = [
    ./firefox.nix
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
      moonlight-qt # game streaming client
      (shipwright.overrideAttrs (
        finalAttrs: previousAttrs: {
          desktopItems = [
            (makeDesktopItem {
              name = "Ship of Harkinian";
              icon = "soh";
              exec = "soh";
              comment = previousAttrs.meta.description;
              genericName = "Ship of Harkinian";
              desktopName = "Ship of Harkinian";
              keywords = [
                "The Legend of Zelda"
                "Ocarina of Time"
                "Shipwright"
              ];
              categories = [ "Game" ];
            })
          ];
        }
      ))
      # Ocarina of Time PC port
      melonds # Nintendo DS emulator
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
