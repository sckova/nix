{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    catppuccinUpper = {
      accent = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        default =
          builtins.substring 0 1 (lib.toUpper config.catppuccin.accent)
          + builtins.substring 1 (-1) config.catppuccin.accent;
      };
      flavor = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        default =
          builtins.substring 0 1 (lib.toUpper config.catppuccin.flavor)
          + builtins.substring 1 (-1) config.catppuccin.flavor;
      };
    };
  };

  config = {
    home.packages =
      (with pkgs; [
        # cli utilities
        tmux
        fastfetch
        btop
        killall
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

        # development & tooling
        gh
        deno
        prettier
        prettierd
        nixfmt-rfc-style
        jdk21_headless

        # kde and kde theming
        kde-rounded-corners
        kdePackages.partitionmanager
        colloid-icon-theme

        # gui applications
        vesktop
        input-leap
        libreoffice-qt-fresh
        # helium-browser
        bitwarden-desktop
        qbittorrent

        # gui applications ( games )
        openmw
        prismlauncher

        # gui applications ( multimedia )
        audacity
        strawberry
        musescore
        mpv
        gimp
        calibre
        spotify-player

        # overrides
        # (chromium.override {
        #   enableWideVine = true;
        # })
        (catppuccin-kde.override {
          flavour = [
            "latte"
            config.catppuccin.flavor
          ];
          accents = [
            config.catppuccin.accent
          ];
        })
      ])
      ++ [
        pkgs.catppuccin-cursors.latteDark
        pkgs.catppuccin-cursors.latteLight
        pkgs.catppuccin-cursors."latte${config.catppuccinUpper.accent}"
        pkgs.catppuccin-cursors."${config.catppuccin.flavor}Dark"
        pkgs.catppuccin-cursors."${config.catppuccin.flavor}Light"
        pkgs.catppuccin-cursors."${config.catppuccin.flavor}${config.catppuccinUpper.accent}"
      ];

    services = {
      spotifyd = {
        enable = true;
        settings = {
          global = {
            device_type = "computer";
            dbus_type = "session";
            disable_discovery = true;
            use_mpris = true;
            bitrate = 320;
            initial_volume = 100;
            volume_normalisation = true;
            normalisation_pregain = -10;
          };
        };
      };
    };

    catppuccin = {
      enable = false;
      cursors.enable = false;
      cache.enable = true;
    };

    programs.plasma = {
      workspace = {
        colorScheme = "Catppuccin${config.catppuccinUpper.flavor}${config.catppuccinUpper.accent}";
        cursor.theme = "catppuccin-${config.catppuccin.flavor}-${config.catppuccin.accent}-cursors";
        splashScreen.theme = "Catpppuccin-${config.catppuccinUpper.flavor}-${config.catppuccinUpper.accent}";
      };

      configFile = {
        kdeglobals.KDE = {
          DefaultDarkLookAndFeel = "Catpppuccin-${config.catppuccinUpper.flavor}-${config.catppuccinUpper.accent}";
          DefaultLightLookAndFeel = "Catpppuccin-Latte-${config.catppuccinUpper.accent}";
        };
      };
    };

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
