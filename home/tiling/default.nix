{ pkgs, config, ... }:
{
  imports = [
    # ./hyprland.nix
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
        icon-theme = config.gtk.iconTheme.name;
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

  programs.swaylock = with config.scheme; {
    enable = true;
    package = pkgs.swaylock;
    settings = {
      # this would sometimes load the previous day's wallpaper
      # when it is run before the bing retrieval script finishes
      # image = "~/.local/share/wallpaper/daily-colored.jpg";
      # effect-blur = "7x5";
      color = "000000"; # black
      font-size = 24;
      indicator-idle-visible = true;
      indicator-radius = 100;
      show-failed-attempts = true;

      bs-hl-color = base09; # peach
      caps-lock-bs-hl-color = base09; # peach
      caps-lock-key-hl-color = base0E; # mauve
      inside-color = base00; # base
      inside-clear-color = base00; # base
      inside-caps-lock-color = base00; # base
      inside-ver-color = base00; # base
      inside-wrong-color = base00; # base
      key-hl-color = base0D; # blue
      layout-bg-color = base00; # base
      layout-border-color = base00; # base
      layout-text-color = base05; # text
      line-color = base00; # base
      line-clear-color = base00; # base
      line-caps-lock-color = base00; # base
      line-ver-color = base00; # base
      line-wrong-color = base00; # base
      ring-color = base00; # base
      ring-clear-color = base09; # peach
      ring-caps-lock-color = base00; # base
      ring-ver-color = base0B; # green
      ring-wrong-color = base00; # base
      separator-color = "00000000"; # transparent
      text-color = base05; # text
      text-clear-color = base09; # peach
      text-caps-lock-color = base0E; # mauve
      text-ver-color = base05; # text
      text-wrong-color = base08; # red
    };
  };

  systemd.user.services.swaylock = {
    Unit = {
      After = [ "niri.service" ];
      PartOf = [ "niri.service" ];
      Description = "Screen locker";
      Documentation = "https://github.com/swaywm/swaylock";
    };

    Service = {
      ExecStart = "${pkgs.swaylock}/bin/swaylock";
      Restart = "on-failure";
    };

    Install.WantedBy = [ "niri.service" ];
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
