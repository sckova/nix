{
  config,
  pkgs,
  gtk-nix,
  ...
}: {
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
    theme.name = "GtkNix";

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

  imports = [gtk-nix.homeManagerModule];

  gtkNix = let
    color = pkgs.catppuccin.bare.${config.catppuccin.flavor};
  in {
    enable = true;

    configuration = {
      spacing-small = "0.3em";
      spacing-medium = "0.6em";
      spacing-large = "0.9em";
      tint-weak = 0.3;
      tint-medium = 0.6;
      tint-strong = 0.9;
      border-size = "0.2em";
      radius = "0.5em";
      disabled-opacity = 0.3;
    };

    defaultTransparency = 255;

    palette = rec {
      base00 = color.base;
      base01 = color.mantle;
      base02 = color.surface0;
      base03 = color.surface1;
      base04 = color.surface2;
      base05 = color.text;
      base06 = color.rosewater;
      base07 = color.lavender;
      base08 = color.red;
      base09 = color.peach;
      base0A = color.yellow;
      base0B = color.green;
      base0C = color.teal;
      base0D = color.blue;
      base0E = color.mauve;
      base0F = color.flamingo;

      highlight = color.${config.catppuccin.accent};
      hialt0 = color.${config.catppuccin.accent};
      hialt1 = base0E;
      hialt2 = base0B;
      urgent = base09;
      warn = base0A;
      confirm = base0D;
      link = base0E;

      pfg-highlight = base00;
      pfg-hialt0 = base00;
      pfg-hialt1 = base00;
      pfg-hialt2 = base05;
      pfg-urgent = base00;
      pfg-warn = base00;
      pfg-confirm = base00;
      pfg-link = base00;

      ansi00 = base03;
      ansi01 = base09;
      ansi02 = base0D;
      ansi03 = base0A;
      ansi04 = base0C;
      ansi05 = base0E;
      ansi06 = base0B;
      ansi07 = base05;
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
        standard_dialogs = "xdgdesktopportal";
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
        standard_dialogs = "xdgdesktopportal";
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
}
