{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:
{

  config = {
    home.packages = with pkgs; [
      # cli utilities
      tmux
      fastfetch
      btop
      wget
      ripgrep
      ncdu
      fzf
      wl-clipboard
      rclone
      waypipe
      spotdl
      browsh
      mosh
      gh

      # development & tooling
      jdk21_headless
      quickemu
      nerd-fonts.noto
      noto-fonts
      noto-fonts-color-emoji
      nix-prefetch
      prowlarr
      radarr
      sonarr
      flaresolverr
      nerd-fonts.fira-mono
      ffmpeg-full

      # kde and kde theming
      kde-rounded-corners
      kdePackages.partitionmanager
      pkgs.catppuccin-cursors.mochaPeach

      # gui applications
      input-leap
      libreoffice-qt-fresh
      # nur.repos.forkprince.helium-nightly
      chromium
      qbittorrent
      nautilus
      fractal
      tuba

      # gui applications ( multimedia )
      audacity
      strawberry
      musescore
      gimp
      calibre
      riff
      dissent
      loupe
      spotify-player

      # overrides
      # (chromium.override {
      #   enableWideVine = true;
      # })
    ];

    services = {
      spotifyd = {
        enable = true;
        package = pkgs-unstable.spotifyd;
        settings = {
          global = {
            device_type = "computer";
            dbus_type = "session";
            disable_discovery = true;
            use_mpris = true;
            bitrate = 320;
            initial_volume = 100;
            volume_normalisation = true;
            normalisation_pregain = 0;
          };
        };
      };
    };

    # programs.plasma = {
    #   workspace = {
    #     colorScheme = "Catppuccin${config.catppuccinUpper.flavor}${config.catppuccinUpper.accent}";
    #     cursor.theme = "catppuccin-${config.catppuccin.flavor}-${config.catppuccin.accent}-cursors";
    #     splashScreen.theme = "Catpppuccin-${config.catppuccinUpper.flavor}-${config.catppuccinUpper.accent}";
    #   };

    #   configFile = {
    #     kdeglobals.KDE = {
    #       DefaultDarkLookAndFeel = "Catpppuccin-${config.catppuccinUpper.flavor}-${config.catppuccinUpper.accent}";
    #       DefaultLightLookAndFeel = "Catpppuccin-Latte-${config.catppuccinUpper.accent}";
    #     };
    #   };
    # };

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "25.05";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
