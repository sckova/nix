{
  config,
  pkgs,
  ...
}:
{
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

      ColorScheme =
        with config.scheme;
        let
          accent = config.scheme.withHashtag.${config.colors.accent};
          mkColors = roles: builtins.concatStringsSep ", " (map (r: "#ff${r}") roles);
        in
        {
          active_colors = mkColors [
            base05
            base01
            base02
            base01
            base00
            base10
            base05
            base05
            base05
            base00
            base10
            base11
            accent
            base00
            accent
            base0E
            base10
            "000000"
            base00
            base05
            base03
            accent
          ];
          disabled_colors = mkColors [
            base03
            base01
            base02
            base01
            base03
            base10
            base03
            base05
            base03
            base01
            base01
            base10
            base03
            base05
            "0000ff"
            "ff00ff"
            base01
            "000000"
            base01
            base00
            "80000000"
            base03
          ];
          inactive_colors = mkColors [
            base05
            base01
            base02
            base01
            base00
            base10
            base05
            base05
            base05
            base00
            base10
            base11
            accent
            base00
            accent
            base0E
            base10
            "000000"
            base00
            base05
            base03
            accent
          ];
        };
    };
  };
}
