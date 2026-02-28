{ pkgs, config, ... }:
{
  imports = [
    ./hyprland.nix
    ./niri.nix
    ./noctalia.nix
    ./wallpaper.nix
  ];

  home.packages = with pkgs; [
    xdg-desktop-portal
    brightnessctl
    qt6Packages.qt6ct
    libsForQt5.qt5ct
    catppuccin-qt5ct
    xwayland-satellite
    playerctl
  ];

  programs.fuzzel = {
    enable = true;
    package = pkgs.fuzzel;
    settings = {
      main = {
        terminal = "${pkgs.kitty}/bin/kitty";
        layer = "overlay";
        font = with config.userOptions.fontMono; name + ":size=" + toString (size + 2);
        launch-prefix = "${pkgs.niri}/bin/niri msg action spawn --";
        icon-theme = "Colloid-Dark";
      };
      border = {
        width = 2;
        radius = 8;
      };
      colors = with config.scheme; {
        background = base00 + "ff";
        text = base05 + "ff";
        prompt = base04 + "ff";
        placeholder = base04 + "ff";
        input = base05 + "ff";
        match = config.scheme.withHashtag.${config.colors.accent} + "ff";
        selection = base04 + "ff";
        selection-text = base00 + "ff";
        counter = base04 + "ff";
        border = config.scheme.withHashtag.${config.colors.accent} + "ff";
      };
    };
  };

  xsession = {
    enable = true;
    windowManager.command = "niri";
  };

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/discord" = [ "vesktop.desktop" ];
      "x-scheme-handler/spotify" = [ "riff.desktop" ];
      "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
      "image/png" = [ "loupe.desktop" ];
      "image/jpeg" = [ "loupe.desktop" ];
    };
    defaultApplications = {
      # Web
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "text/html" = [ "firefox.desktop" ];

      # Communication & Social
      "x-scheme-handler/discord" = [ "vesktop.desktop" ];
      "x-scheme-handler/spotify" = [ "riff.desktop" ];

      # File Management
      "inode/directory" = [ "org.gnome.Nautilus.desktop" ];

      # Torrents
      "application/x-bittorrent" = [ "org.qbittorrent.qBittorrent.desktop" ];
      "x-scheme-handler/magnet" = [ "org.qbittorrent.qBittorrent.desktop" ];

      # Documents
      "application/pdf" = [ "firefox.desktop" ]; # Or libreoffice-draw.desktop
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [
        "libreoffice-writer.desktop"
      ]; # docx
      "application/msword" = [ "libreoffice-writer.desktop" ]; # doc
      "application/vnd.oasis.opendocument.text" = [ "libreoffice-writer.desktop" ]; # odt
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = [
        "libreoffice-calc.desktop"
      ]; # xlsx
      "application/vnd.ms-excel" = [ "libreoffice-calc.desktop" ]; # xls
      "application/vnd.oasis.opendocument.spreadsheet" = [ "libreoffice-calc.desktop" ]; # ods

      # Text & Code
      "text/plain" = [ "nvim.desktop" ];
      "text/markdown" = [ "nvim.desktop" ];
      "application/x-shellscript" = [ "nvim.desktop" ];
      "application/json" = [ "nvim.desktop" ];
      "text/x-c" = [ "nvim.desktop" ];
      "text/x-c++" = [ "nvim.desktop" ];
      "text/x-python" = [ "nvim.desktop" ];
      "text/x-makefile" = [ "nvim.desktop" ];

      # Media
      "video/mp4" = [ "mpv.desktop" ];
      "video/mkv" = [ "mpv.desktop" ];
      "video/webm" = [ "mpv.desktop" ];
      "audio/mpeg" = [ "mpv.desktop" ];
      "audio/flac" = [ "mpv.desktop" ];
      "audio/wav" = [ "mpv.desktop" ];

      # Images
      "image/png" = [ "loupe.desktop" ];
      "image/jpeg" = [ "loupe.desktop" ];
      "image/webp" = [ "loupe.desktop" ];
      "image/gif" = [ "loupe.desktop" ];
    };
  };

}
