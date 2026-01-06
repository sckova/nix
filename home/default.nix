{
  config,
  pkgs,
  lib,
  types,
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

        # kde and kde theming
        kde-rounded-corners
        kdePackages.partitionmanager

        # gui applications
        input-leap
        libreoffice-qt-fresh
        # nur.repos.forkprince.helium-nightly
        bitwarden-desktop
        qbittorrent
        whatsapp-electron

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

    home.sessionVariables = {
      QT_QPA_PLATFORMTHEME = "qt6ct";
    };

    gtk = {
      enable = true;

      colorScheme =
        if config.userOptions.isDark
        then "dark"
        else "light";

      # theme = {
      #   package = pkgs.kdePackages.breeze-gtk;
      #   name =
      #     if config.userOptions.isDark
      #     then "Breeze-Dark"
      #     else "Breeze";
      # };

      iconTheme = {
        name =
          if config.userOptions.isDark
          then "Colloid-Dark"
          else "Colloid-Light";
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
          color_scheme_path = "/home/${config.userOptions.username}/.config/qt5ct/qt5ct.conf";
          custom_palette = true;
          standard_dialogs = "default";
        };
        Fonts = config.qt.qt6ctSettings.Fonts;
        ColorScheme = config.qt.qt6ctSettings.ColorScheme;
      };
      qt6ctSettings = {
        Appearance = {
          style = "Breeze";
          icon_theme = config.gtk.iconTheme.name;
          color_scheme_path = "/home/${config.userOptions.username}/.config/qt6ct/qt6ct.conf";
          custom_palette = true;
          standard_dialogs = "default";
        };
        Fonts = {
          fixed = "\"${config.userOptions.fontMono.name},${toString config.userOptions.fontMono.size}\"";
          general = "\"${config.userOptions.fontSans.name},${toString config.userOptions.fontSans.size}\"";
        };
        ColorScheme = let
          c = pkgs.catppuccin.bare.${config.catppuccin.flavor};
          accent = c.${config.catppuccin.accent};
          mkColors = roles: builtins.concatStringsSep ", " (map (r: "#ff${r}") roles);
        in {
          active_colors = mkColors [
            c.text
            c.surface0
            c.surface1
            c.surface0
            c.base
            c.mantle
            c.text
            c.text
            c.text
            c.base
            c.mantle
            c.crust
            accent
            c.base
            accent
            c.mauve
            c.mantle
            "000000"
            c.base
            c.text
            c.overlay0
            accent
          ];
          disabled_colors = mkColors [
            c.overlay0
            c.surface0
            c.surface1
            c.surface0
            c.overlay0
            c.mantle
            c.overlay0
            c.text
            c.overlay0
            c.surface0
            c.surface0
            c.mantle
            c.overlay1
            c.text
            "0000ff"
            "ff00ff"
            c.surface0
            "000000"
            c.surface0
            c.base
            "80000000"
            c.overlay1
          ];
          inactive_colors = mkColors [
            c.text
            c.surface0
            c.surface1
            c.surface0
            c.base
            c.mantle
            c.text
            c.text
            c.text
            c.base
            c.mantle
            c.crust
            accent
            c.base
            accent
            c.mauve
            c.mantle
            "000000"
            c.base
            c.text
            c.overlay0
            accent
          ];
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
