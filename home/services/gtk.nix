{
  config,
  ...
}:
let
  mkColorSection = name: value: "@define-color ${name} ${value};";

  generateCSS = with config.scheme.withHashtag; ''
    /* Kova's Nixified GTK */

    /* Base colors */
    ${mkColorSection "window_bg_color" base00}
    ${mkColorSection "window_fg_color" base05}

    /* View styling */
    ${mkColorSection "view_bg_color" base00}
    ${mkColorSection "view_fg_color" base05}

    /* Header bar */
    ${mkColorSection "headerbar_bg_color" base10}
    ${mkColorSection "headerbar_backdrop_color" base10}
    ${mkColorSection "headerbar_fg_color" base05}

    /* Popovers and dialogs */
    ${mkColorSection "popover_bg_color" base00}
    ${mkColorSection "popover_fg_color" base05}
    @define-color dialog_bg_color @popover_bg_color;
    @define-color dialog_fg_color @popover_fg_color;

    /* Cards and sidebars */
    ${mkColorSection "card_bg_color" base10}
    ${mkColorSection "card_fg_color" base05}
    ${mkColorSection "sidebar_bg_color" base10}
    ${mkColorSection "sidebar_fg_color" base05}
    @define-color sidebar_backdrop_color @sidebar_bg_color;
    ${mkColorSection "sidebar_border_color" base01}
    @define-color secondary_sidebar_bg_color @sidebar_bg_color;
    @define-color secondary_sidebar_fg_color @sidebar_fg_color;
    @define-color secondary_sidebar_backdrop_color @sidebar_backdrop_color;
    @define-color secondary_sidebar_border_color @sidebar_border_color;

    /* Catppuccin accent colors */
    ${mkColorSection "blue_1" base0D}
    ${mkColorSection "blue_2" base16}
    ${mkColorSection "blue_3" base15}
    ${mkColorSection "blue_4" base0C}
    ${mkColorSection "blue_5" base07}

    ${mkColorSection "green_1" base0B}
    ${mkColorSection "green_2" base0C}
    ${mkColorSection "green_3" base15}
    ${mkColorSection "green_4" base16}
    ${mkColorSection "green_5" base0D}

    ${mkColorSection "yellow_1" base0A}
    ${mkColorSection "yellow_2" base09}
    ${mkColorSection "yellow_3" base0A}
    ${mkColorSection "yellow_4" base08}
    ${mkColorSection "yellow_5" base12}

    ${mkColorSection "orange_1" base09}
    ${mkColorSection "orange_2" base08}
    ${mkColorSection "orange_3" base12}
    ${mkColorSection "orange_4" base0A}
    ${mkColorSection "orange_5" base0B}

    ${mkColorSection "red_1" base08}
    ${mkColorSection "red_2" base12}
    ${mkColorSection "red_3" base17}
    ${mkColorSection "red_4" base0F}
    ${mkColorSection "red_5" base13}

    ${mkColorSection "purple_1" base0E}
    ${mkColorSection "purple_2" base07}
    ${mkColorSection "purple_3" base17}
    ${mkColorSection "purple_4" base0F}
    ${mkColorSection "purple_5" base13}

    ${mkColorSection "brown_1" base02}
    ${mkColorSection "brown_2" base03}
    ${mkColorSection "brown_3" base03}
    ${mkColorSection "brown_4" base03}
    ${mkColorSection "brown_5" base04}

    ${mkColorSection "light_1" base05}
    ${mkColorSection "light_2" base04}
    ${mkColorSection "light_3" base04}
    ${mkColorSection "light_4" base0D}
    ${mkColorSection "light_5" base03}

    ${mkColorSection "dark_1" base01}
    ${mkColorSection "dark_2" base02}
    ${mkColorSection "dark_3" base02}
    ${mkColorSection "dark_4" base10}
    ${mkColorSection "dark_5" base11}

    /* Custom rules */
    toast {
      background-color: @window_bg_color;
      color: @window_fg_color;
    }

    toggle:checked {
      background-color: @card_bg_color;
      color: @window_fg_color;
    }

    .inline {
      background-color: rgba(0, 0, 0, 0);
    }

    /* Accent */
    ${mkColorSection "accent_bg_color" config.scheme.withHashtag.${config.colors.accent}}
    @define-color accent_fg_color @window_bg_color;
  '';
in
{
  home.file = {
    ".config/gtk-4.0/gtk.css" = {
      text = generateCSS;
      force = true;
    };
    ".config/gtk-3.0/gtk.css" = {
      text = generateCSS;
      force = true;
    };
  };
}
