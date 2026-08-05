{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./gtk.nix
    ./qt.nix
    ./synology.nix
  ];

  home = {
    file.".icons/default/index.theme" = {
      force = true;

      text = /* ini */ ''
        [Icon Theme]
        Name=Default
        Comment=Default Cursor Theme
        Inherits=${config.cursor.name}
      '';
    };

    packages = with pkgs; [
      adwaita-icon-theme
      morewaita-icon-theme
      config.fonts.sans.package
      config.fonts.serif.package
      config.fonts.mono.package
      config.fonts.emoji.package
    ];

    pointerCursor = {
      package = config.cursor.package;
      gtk.enable = true;
      name = config.cursor.name;
      size = config.cursor.size;
    };

    sessionVariables = {
      # this makes electron apps work per the wiki
      NIXOS_OZONE_WL = "1";
      # allow non-free packages in shells
      NIXPKGS_ALLOW_UNFREE = 1;
    };
  };

  systemd.user.sessionVariables = {
    XCURSOR_PATH = config.cursor.path;
    XCURSOR_SIZE = toString config.cursor.size;
    XCURSOR_THEME = config.cursor.name;
  };

  xdg.mimeApps = {
    enable = true;

    associations.added = {
      "application/pdf" = [ "org.gnome.Papers.desktop" ];
      "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
      "image/png" = [ "org.gnome.Loupe.desktop" ];
      "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
      "text/plain" = [ "nvim.desktop" ];
      "x-scheme-handler/discord" = [ "vesktop.desktop" ];
      "x-scheme-handler/geo" = [ "org.gnome.Maps.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/spotify" = [ "riff.desktop" ];
    };

    defaultApplications = {
      # Archives (GNOME File Roller)
      "application/gzip" = [ "org.gnome.FileRoller.desktop" ];
      "application/json" = [ "nvim.desktop" ];
      "application/msword" = [ "libreoffice-writer.desktop" ]; # doc
      # Documents & Viewers (GNOME Papers)
      "application/oxps" = [ "org.gnome.Papers.desktop" ];
      "application/pdf" = [ "org.gnome.Papers.desktop" ];
      # Spreadsheets & Office (LibreOffice)
      "application/vnd.ms-excel" = [ "libreoffice-calc.desktop" ]; # xls
      "application/vnd.ms-xpsdocument" = [ "org.gnome.Papers.desktop" ];
      "application/vnd.oasis.opendocument.spreadsheet" = [ "libreoffice-calc.desktop" ]; # ods
      "application/vnd.oasis.opendocument.text" = [ "libreoffice-writer.desktop" ]; # odt

      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = [
        "libreoffice-calc.desktop"
      ]; # xlsx

      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [
        "libreoffice-writer.desktop"
      ]; # docx

      "application/x-7z-compressed" = [ "org.gnome.FileRoller.desktop" ];
      # Torrents
      "application/x-bittorrent" = [ "org.qbittorrent.qBittorrent.desktop" ];
      "application/x-bzip2-compressed-tar" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-cbr" = [ "org.gnome.Papers.desktop" ];
      "application/x-cbz" = [ "org.gnome.Papers.desktop" ];
      "application/x-compressed-tar" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-ext-djvu" = [ "org.gnome.Papers.desktop" ];
      "application/x-rar" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-shellscript" = [ "nvim.desktop" ];
      "application/x-tar" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-xz-compressed-tar" = [ "org.gnome.FileRoller.desktop" ];
      "application/zip" = [ "org.gnome.FileRoller.desktop" ];
      # Audio
      "audio/aiff" = [ "mpv.desktop" ];
      "audio/flac" = [ "mpv.desktop" ];
      "audio/mpeg" = [ "mpv.desktop" ];
      "audio/opus" = [ "mpv.desktop" ];
      "audio/wav" = [ "mpv.desktop" ];
      # Fonts (GNOME Font Viewer)
      "font/otf" = [ "org.gnome.font-viewer.desktop" ];
      "font/ttf" = [ "org.gnome.font-viewer.desktop" ];
      "font/woff" = [ "org.gnome.font-viewer.desktop" ];
      "font/woff2" = [ "org.gnome.font-viewer.desktop" ];
      # Images (GNOME Loupe)
      "image/avif" = [ "org.gnome.Loupe.desktop" ];
      "image/bmp" = [ "org.gnome.Loupe.desktop" ];
      "image/gif" = [ "org.gnome.Loupe.desktop" ];
      "image/heic" = [ "org.gnome.Loupe.desktop" ];
      "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
      "image/jxl" = [ "org.gnome.Loupe.desktop" ];
      "image/png" = [ "org.gnome.Loupe.desktop" ];
      "image/qoi" = [ "org.gnome.Loupe.desktop" ];
      "image/svg+xml" = [ "org.gnome.Loupe.desktop" ];
      "image/svg+xml-compressed" = [ "org.gnome.Loupe.desktop" ];
      "image/tiff" = [ "org.gnome.Loupe.desktop" ];
      "image/vnd-ms.dds" = [ "org.gnome.Loupe.desktop" ];
      "image/vnd.microsoft.icon" = [ "org.gnome.Loupe.desktop" ];
      "image/vnd.radiance" = [ "org.gnome.Loupe.desktop" ];
      "image/webp" = [ "org.gnome.Loupe.desktop" ];
      "image/x-dds" = [ "org.gnome.Loupe.desktop" ];
      "image/x-exr" = [ "org.gnome.Loupe.desktop" ];
      "image/x-portable-anymap" = [ "org.gnome.Loupe.desktop" ];
      "image/x-portable-bitmap" = [ "org.gnome.Loupe.desktop" ];
      "image/x-portable-graymap" = [ "org.gnome.Loupe.desktop" ];
      "image/x-portable-pixmap" = [ "org.gnome.Loupe.desktop" ];
      "image/x-qoi" = [ "org.gnome.Loupe.desktop" ];
      "image/x-tga" = [ "org.gnome.Loupe.desktop" ];
      # File Management & System
      "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
      "text/calendar" = [ "org.gnome.Calendar.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "text/markdown" = [ "nvim.desktop" ];
      # Text & Code
      "text/plain" = [ "nvim.desktop" ];
      "text/x-c" = [ "nvim.desktop" ];
      "text/x-c++" = [ "nvim.desktop" ];
      "text/x-makefile" = [ "nvim.desktop" ];
      "text/x-python" = [ "nvim.desktop" ];
      # Video
      "video/mkv" = [ "mpv.desktop" ];
      "video/mp4" = [ "mpv.desktop" ];
      "video/webm" = [ "mpv.desktop" ];
      # URI Handlers
      "x-scheme-handler/discord" = [ "vesktop.desktop" ];
      "x-scheme-handler/geo" = [ "org.gnome.Maps.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/magnet" = [ "org.qbittorrent.qBittorrent.desktop" ];
      "x-scheme-handler/spotify" = [ "riff.desktop" ];
      "x-scheme-handler/terminal" = [ "ghostty.desktop" ];
    };
  };
}
