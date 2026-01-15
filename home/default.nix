{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}: {
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
    userOptions = {
      name = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        default = "Sean Kovacs";
      };
      username = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        default = "sckova";
      };
      hostname = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        default = config.system.name;
      };
      fontSans = {
        name = lib.mkOption {
          type = lib.types.str;
          readOnly = true;
          default = "Noto Sans";
        };
        size = lib.mkOption {
          type = lib.types.int;
          readOnly = true;
          default = 11;
        };
        package = lib.mkOption {
          type = lib.types.package;
          readOnly = true;
          default = pkgs.noto-fonts;
        };
      };
      fontSerif = {
        name = lib.mkOption {
          type = lib.types.str;
          readOnly = true;
          default = "Noto Serif";
        };
        size = lib.mkOption {
          type = lib.types.int;
          readOnly = true;
          default = 11;
        };
        package = lib.mkOption {
          type = lib.types.package;
          readOnly = true;
          default = pkgs.noto-fonts;
        };
      };
      fontMono = {
        name = lib.mkOption {
          type = lib.types.str;
          readOnly = true;
          default = "NotoSansM Nerd Font Mono";
        };
        size = lib.mkOption {
          type = lib.types.int;
          readOnly = true;
          default = 10;
        };
        package = lib.mkOption {
          type = lib.types.package;
          readOnly = true;
          default = pkgs.nerd-fonts.noto;
        };
      };
      fontEmoji = {
        name = lib.mkOption {
          type = lib.types.str;
          readOnly = true;
          default = "Noto Emoji";
        };
        size = lib.mkOption {
          type = lib.types.int;
          readOnly = true;
          default = 10;
        };
        package = lib.mkOption {
          type = lib.types.package;
          readOnly = true;
          default = pkgs.noto-fonts-color-emoji;
        };
      };
      cursor = let
        attrName = config.catppuccin.flavor + config.catppuccinUpper.accent;
      in {
        name = lib.mkOption {
          type = lib.types.str;
          readOnly = true;
          default = "catppuccin-${config.catppuccin.flavor}-${config.catppuccin.accent}-cursors";
        };
        package = lib.mkOption {
          type = lib.types.package;
          readOnly = true;
          default = pkgs.catppuccin-cursors.${attrName};
        };
        size = lib.mkOption {
          type = lib.types.int;
          readOnly = true;
          default = 24;
        };
        path = lib.mkOption {
          type = lib.types.str;
          readOnly = true;
          default = "${pkgs.catppuccin-cursors.${attrName}}/share/icons";
        };
      };
      isDark = lib.mkOption {
        type = lib.types.bool;
        readOnly = true;
        default = config.catppuccin.flavor != "latte";
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
        spotify-player
        gh

        # development & tooling
        jdk21_headless
        quickemu
        nerd-fonts.noto
        noto-fonts
        noto-fonts-color-emoji
        nix-prefetch

        # kde and kde theming
        kde-rounded-corners
        kdePackages.partitionmanager

        # gui applications
        input-leap
        libreoffice-qt-fresh
        # nur.repos.forkprince.helium-nightly
        qbittorrent
        nautilus

        # gui applications ( multimedia )
        audacity
        strawberry
        musescore
        gimp
        calibre
        spotify-qt

        # overrides
        # (chromium.override {
        #   enableWideVine = true;
        # })
        (catppuccin-kde.override {
          flavour = [config.catppuccin.flavor];
          accents = [config.catppuccin.accent];
        })
      ])
      ++ [
        pkgs.catppuccin-cursors."${config.catppuccin.flavor}${config.catppuccinUpper.accent}"
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
