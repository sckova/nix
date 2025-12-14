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
          default = 12;
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
          default = 12;
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
          default = 10;
        };
      };
      cursor =
        let
          attrName = config.catppuccin.flavor + config.catppuccinUpper.accent;
        in
        {
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
        nerd-fonts.noto
        xorg.xcursorgen

        # kde and kde theming
        kde-rounded-corners
        kdePackages.partitionmanager

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

    home.pointerCursor = {
      gtk.enable = true;
      name = config.userOptions.cursor.name;
      package = config.userOptions.cursor.package;
      size = config.userOptions.cursor.size;
    };

    gtk = {
      enable = true;

      iconTheme = {
        name = "Colloid-Dark";
        package = pkgs.colloid-icon-theme;
      };

      cursorTheme = {
        name = config.home.pointerCursor.name;
        package = config.home.pointerCursor.package;
        size = config.home.pointerCursor.size;
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };

      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };

    qt = {
      enable = true;
      qt5ctSettings = {
        Appearance = {
          style = "Breeze";
          icon_theme = config.gtk.iconTheme.name;
          color_scheme = "catppuccin-${config.catppuccin.flavor}-${config.catppuccin.accent}";
          standard_dialogs = "default";
        };
        Fonts = {
          fixed = "\"${config.userOptions.fontMono.name},${config.userOptions.fontMono.name}\"";
          general = "\"${config.userOptions.fontSans.name},${toString config.userOptions.fontSans.size}\"";
        };
      };
      qt6ctSettings = {
        Appearance = {
          style = "Breeze";
          icon_theme = config.gtk.iconTheme.name;
          color_scheme = "catppuccin-${config.catppuccin.flavor}-${config.catppuccin.accent}";
          standard_dialogs = "default";
        };
        Fonts = {
          fixed = "\"${config.userOptions.fontMono.name},${config.userOptions.fontMono.name}\"";
          general = "\"${config.userOptions.fontSans.name},${toString config.userOptions.fontSans.size}\"";
        };
      };
    };

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
