{
  config,
  pkgs,
  ...
}:
{
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DECORATION = "adwaita";
  };

  qt = {
    enable = true;
    style.name = "kvantum";
    platformTheme = {
      name = "qt6ct";
      package = with pkgs; [
        libsForQt5.qt5ct
        qt6Packages.qt6ct
      ];
    };

    kvantum = {
      enable = true;
      themes = with pkgs; [
        (
          (catppuccin-kvantum.override {
            accent = "blue";
            variant = "frappe";
          }).overrideAttrs
          (oldAttrs: {
            postPatch =
              let
                cleanScheme = {
                  inherit (config.scheme.withHashtag)
                    base00
                    base01
                    base02
                    base03
                    base04
                    base05
                    base06
                    base07
                    base08
                    base09
                    base0A
                    base0B
                    base0C
                    base0D
                    base0E
                    base0F
                    base10
                    base11
                    base12
                    base15
                    base16
                    base17
                    ;
                };
                themeColors =
                  cleanScheme
                  // (
                    if config.colors.accent != "base0D" then
                      {
                        base0D = cleanScheme.${config.colors.accent};
                        ${config.colors.accent} = cleanScheme.base0D;
                      }
                    else
                      {
                        # do a fun dance i guess
                      }
                  );
              in
              with themeColors;
              (oldAttrs.postPatch or "")
              + ''
                find . -type f \( -name "*.kvconfig" -o -name "*.svg" \) | xargs sed -i -E \
                -e 's/#303446/${base00}/gI' \
                -e 's/#414559/${base01}/gI' \
                -e 's/#51576d/${base02}/gI' \
                -e 's/#737994/${base03}/gI' \
                -e 's/#a5adce/${base04}/gI' \
                -e 's/#c6d0f5/${base05}/gI' \
                -e 's/#f2d5cf/${base06}/gI' \
                -e 's/#babbf1/${base07}/gI' \
                -e 's/#e78284/${base08}/gI' \
                -e 's/#ef9f76/${base09}/gI' \
                -e 's/#e5c890/${base0A}/gI' \
                -e 's/#a6d189/${base0B}/gI' \
                -e 's/#81c8be/${base0C}/gI' \
                -e 's/#8caaee/${base0D}/gI' \
                -e 's/#ca9ee6/${base0E}/gI' \
                -e 's/#eebebe/${base0F}/gI' \
                -e 's/#292c3c/${base10}/gI' \
                -e 's/#232634/${base11}/gI' \
                -e 's/#ea999c/${base12}/gI' \
                -e 's/#99d1db/${base15}/gI' \
                -e 's/#85c1dc/${base16}/gI' \
                -e 's/#f4b8e4/${base17}/gI'
              '';
          })
        )
      ];
      settings.General.theme = "catppuccin-frappe-blue";
    };

    qt5ctSettings = config.qt.qt6ctSettings;
    qt6ctSettings = {
      Appearance = {
        custom_palette = false;
        icon_theme = config.gtk.iconTheme.name;
        standard_dialogs = "xdgdesktopportal";
        style = "kvantum";
      };

      Fonts = {
        fixed = "\"${config.userOptions.fontMono.name},${toString config.userOptions.fontMono.size}\"";
        general = "\"${config.userOptions.fontSans.name},${toString config.userOptions.fontSans.size}\"";
      };

      Interface = {
        activate_item_on_single_click = 1;
        buttonbox_layout = 0;
        cursor_flash_time = 1000;
        dialog_buttons_have_icons = 1;
        double_click_interval = 400;
        gui_effects = "@Invalid()";
        keyboard_scheme = 2;
        menus_have_icons = true;
        show_shortcuts_in_context_menus = true;
        stylesheets = "@Invalid()";
        toolbutton_style = 4;
        underline_shortcut = 1;
        wheel_scroll_lines = 3;
      };
    };
  };
}
