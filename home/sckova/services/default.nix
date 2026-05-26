{
  osConfig,
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

  systemd.user.sessionVariables = {
    XCURSOR_THEME = config.cursor.name;
    XCURSOR_SIZE = toString config.cursor.size;
    XCURSOR_PATH = config.cursor.path;
  };

  home.packages = with pkgs; [
    adwaita-icon-theme
    morewaita-icon-theme
    config.fonts.sans.package
    config.fonts.serif.package
    config.fonts.mono.package
    config.fonts.emoji.package
  ];

  home.file = {
    ".icons/default/index.theme" = {
      text = /* ini */ ''
        [Icon Theme]
        Name=Default
        Comment=Default Cursor Theme
        Inherits=${config.cursor.name}
      '';
      force = true;
    };
  };

  services.spotifyd.enable = true;
  # comments taken from https://docs.spotifyd.rs/configuration/index.html
  services.spotifyd.settings.global = {
    #---------#
    # GENERAL #
    #---------#

    # The name that gets displayed under the connect tab on
    # official clients.
    device_name = "daemon@${osConfig.system.name}";

    # The displayed device type in Spotify clients.
    # Can be unknown, computer, tablet, smartphone, speaker, t_v,
    # a_v_r (Audio/Video Receiver), s_t_b (Set-Top Box), and audio_dongle.
    device_type = "computer";

    # The bus to bind to with the MPRIS interface.
    # Possible values: "session", "system"
    # The system bus can be used if no graphical session is available
    # (e.g. on headless systems) but you still want to be able to use MPRIS.
    # NOTE: You might need to add appropriate policies to allow spotifyd to
    # own the name.
    dbus_type = "session";

    # If set to true, `spotifyd` tries to bind to dbus (default is the session bus)
    # and expose MPRIS controls. When running headless, without the session bus,
    # you should set this to false, to avoid errors. If you still want to use MPRIS,
    # have a look at the `dbus_type` option.
    use_mpris = true;

    # The directory used to store credentials and audio cache.
    # Default: infers a sensible cache directory (e.g. on Linux: $XDG_CACHE_HOME)
    # Note: The file path does not get expanded. Environment variables and
    # shell placeholders like $HOME or ~ don't work!
    # cache_path = "";

    # If set to true, audio data does NOT get cached.
    # In this case, the cache is only used for credentials.
    no_audio_cache = false;

    # The maximal size of the cache directory in bytes
    # The value below corresponds to ~ 10GB
    max_cache_size = 10000000000;

    #-----------#
    # DISCOVERY #
    #-----------#

    # If set to true, this disables zeroconf discovery.
    # This can be useful, if one prefers to run a single-user instance.
    disable_discovery = true;

    #-------#
    # AUDIO #
    #-------#

    # The audio backend used to play music. To get
    # a list of possible backends, run `spotifyd --help`.
    backend = "alsa"; # use portaudio for macOS [homebrew]

    # The alsa audio device to stream audio. To get a
    # list of valid devices, run `aplay -L`,
    device = "default"; # omit for macOS

    # If set to true, enables volume normalisation between songs.
    volume_normalisation = true;

    # The normalisation pregain that is applied for each song.
    normalisation_pregain = 0;

    # The audio bitrate. 96, 160 or 320 kbit/s
    bitrate = 320;

    # Volume on startup between 0 and 100
    initial_volume = 100;

    #-------ä
    # OTHER #
    #-------#

    # After the music playback has ended, start playing similar songs based on the previous tracks.
    # By default, `spotifyd` infers this setting from the user settings.
    autoplay = false;
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = config.cursor.name;
    package = config.cursor.package;
    size = config.cursor.size;
  };

  home.sessionVariables = {
    # this makes electron apps work per the wiki
    NIXOS_OZONE_WL = "1";
    # allow non-free packages in shells
    NIXPKGS_ALLOW_UNFREE = 1;
  };

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/discord" = [ "vesktop.desktop" ];
      "x-scheme-handler/spotify" = [ "riff.desktop" ];
      "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
      "image/png" = [ "org.gnome.Loupe.desktop" ];
      "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
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
      "x-scheme-handler/terminal" = [ "ghostty.desktop" ];

      # Media
      "video/mp4" = [ "mpv.desktop" ];
      "video/mkv" = [ "mpv.desktop" ];
      "video/webm" = [ "mpv.desktop" ];
      "audio/mpeg" = [ "mpv.desktop" ];
      "audio/flac" = [ "mpv.desktop" ];
      "audio/wav" = [ "mpv.desktop" ];

      # Images
      "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
      "image/png" = [ "org.gnome.Loupe.desktop" ];
      "image/gif" = [ "org.gnome.Loupe.desktop" ];
      "image/webp" = [ "org.gnome.Loupe.desktop" ];
      "image/tiff" = [ "org.gnome.Loupe.desktop" ];
      "image/x-tga" = [ "org.gnome.Loupe.desktop" ];
      "image/vnd-ms.dds" = [ "org.gnome.Loupe.desktop" ];
      "image/x-dds" = [ "org.gnome.Loupe.desktop" ];
      "image/bmp" = [ "org.gnome.Loupe.desktop" ];
      "image/vnd.microsoft.icon" = [ "org.gnome.Loupe.desktop" ];
      "image/vnd.radiance" = [ "org.gnome.Loupe.desktop" ];
      "image/x-exr" = [ "org.gnome.Loupe.desktop" ];
      "image/x-portable-bitmap" = [ "org.gnome.Loupe.desktop" ];
      "image/x-portable-graymap" = [ "org.gnome.Loupe.desktop" ];
      "image/x-portable-pixmap" = [ "org.gnome.Loupe.desktop" ];
      "image/x-portable-anymap" = [ "org.gnome.Loupe.desktop" ];
      "image/x-qoi" = [ "org.gnome.Loupe.desktop" ];
      "image/qoi" = [ "org.gnome.Loupe.desktop" ];
      "image/svg+xml" = [ "org.gnome.Loupe.desktop" ];
      "image/svg+xml-compressed" = [ "org.gnome.Loupe.desktop" ];
      "image/avif" = [ "org.gnome.Loupe.desktop" ];
      "image/heic" = [ "org.gnome.Loupe.desktop" ];
      "image/jxl" = [ "org.gnome.Loupe.desktop" ];
    };
  };
}
