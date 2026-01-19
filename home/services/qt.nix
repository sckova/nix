{
  config,
  pkgs,
  ...
}: {
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
