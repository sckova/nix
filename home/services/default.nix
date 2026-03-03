{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./gtk.nix
    ./qt.nix
    ./systemd.nix
  ];

  home.file = {
    ".icons/default/index.theme" = {
      text = ''
        [Icon Theme]
        Name=Default
        Comment=Default Cursor Theme
        Inherits=${config.userOptions.cursor.name}
      '';
      force = true;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      clock-format = "12h";
      clock-show-weekday = true;
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":";
      action-double-click-titlebar = "'none'";
    };
    "org/gnome/desktop/media-handling" = {
      automount = false;
      automount-open = false;
      autorun-never = true;
    };
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
    };
    "org/gnome/mutter" = {
      edge-tiling = true;
      dynamic-workspaces = true;
      experimental-features = [ "variable-refresh-rate" ];
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = config.userOptions.cursor.name;
    package = config.userOptions.cursor.package;
    size = config.userOptions.cursor.size;
  };

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt6ct";
    # this makes electron apps work per the wiki
    NIXOS_OZONE_WL = "1";
  };

  gtk = {
    enable = true;

    colorScheme = "dark";
    iconTheme = {
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme;
    };

    cursorTheme = {
      name = config.home.pointerCursor.name;
      package = config.home.pointerCursor.package;
      size = config.home.pointerCursor.size;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = ":";
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = ":";
    };
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

      # Terminal
      "x-scheme-handler/terminal" = [ "kitty.desktop" ];

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
