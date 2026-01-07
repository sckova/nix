{
  config,
  pkgs,
  lib,
  ...
}: let
  colors = pkgs.catppuccin.hex.${config.catppuccin.flavor};

  mkColorSection = name: value: "@define-color ${name} ${value};";

  generateCSS = ''
    /* Catppuccin ${lib.toUpper (builtins.substring 0 1 config.catppuccin.flavor)}${builtins.substring 1 (-1) config.catppuccin.flavor} ${lib.toUpper (builtins.substring 0 1 config.catppuccin.accent)}${builtins.substring 1 (-1) config.catppuccin.accent} Palette */

    /* Base colors */
    ${mkColorSection "window_bg_color" colors.base}
    ${mkColorSection "window_fg_color" colors.text}

    /* View styling */
    ${mkColorSection "view_bg_color" colors.base}
    ${mkColorSection "view_fg_color" colors.text}

    /* Header bar */
    ${mkColorSection "headerbar_bg_color" colors.mantle}
    ${mkColorSection "headerbar_backdrop_color" colors.mantle}
    ${mkColorSection "headerbar_fg_color" colors.text}

    /* Popovers and dialogs */
    ${mkColorSection "popover_bg_color" colors.base}
    ${mkColorSection "popover_fg_color" colors.text}
    @define-color dialog_bg_color @popover_bg_color;
    @define-color dialog_fg_color @popover_fg_color;

    /* Cards and sidebars */
    ${mkColorSection "card_bg_color" colors.mantle}
    ${mkColorSection "card_fg_color" colors.text}
    ${mkColorSection "sidebar_bg_color" colors.mantle}
    ${mkColorSection "sidebar_fg_color" colors.text}
    @define-color sidebar_backdrop_color @sidebar_bg_color;
    ${mkColorSection "sidebar_border_color" colors.surface0}
    @define-color secondary_sidebar_bg_color @sidebar_bg_color;
    @define-color secondary_sidebar_fg_color @sidebar_fg_color;
    @define-color secondary_sidebar_backdrop_color @sidebar_backdrop_color;
    @define-color secondary_sidebar_border_color @sidebar_border_color;

    /* Catppuccin accent colors */
    ${mkColorSection "blue_1" colors.blue}
    ${mkColorSection "blue_2" colors.sapphire}
    ${mkColorSection "blue_3" colors.sky}
    ${mkColorSection "blue_4" colors.teal}
    ${mkColorSection "blue_5" colors.lavender}

    ${mkColorSection "green_1" colors.green}
    ${mkColorSection "green_2" colors.teal}
    ${mkColorSection "green_3" colors.sky}
    ${mkColorSection "green_4" colors.sapphire}
    ${mkColorSection "green_5" colors.blue}

    ${mkColorSection "yellow_1" colors.yellow}
    ${mkColorSection "yellow_2" colors.peach}
    ${mkColorSection "yellow_3" colors.yellow}
    ${mkColorSection "yellow_4" colors.red}
    ${mkColorSection "yellow_5" colors.maroon}

    ${mkColorSection "orange_1" colors.peach}
    ${mkColorSection "orange_2" colors.red}
    ${mkColorSection "orange_3" colors.maroon}
    ${mkColorSection "orange_4" colors.yellow}
    ${mkColorSection "orange_5" colors.green}

    ${mkColorSection "red_1" colors.red}
    ${mkColorSection "red_2" colors.maroon}
    ${mkColorSection "red_3" colors.pink}
    ${mkColorSection "red_4" colors.flamingo}
    ${mkColorSection "red_5" colors.rosewater}

    ${mkColorSection "purple_1" colors.mauve}
    ${mkColorSection "purple_2" colors.lavender}
    ${mkColorSection "purple_3" colors.pink}
    ${mkColorSection "purple_4" colors.flamingo}
    ${mkColorSection "purple_5" colors.rosewater}

    ${mkColorSection "brown_1" colors.surface2}
    ${mkColorSection "brown_2" colors.overlay0}
    ${mkColorSection "brown_3" colors.overlay1}
    ${mkColorSection "brown_4" colors.overlay2}
    ${mkColorSection "brown_5" colors.subtext1}

    ${mkColorSection "light_1" colors.text}
    ${mkColorSection "light_2" colors.subtext0}
    ${mkColorSection "light_3" colors.subtext1}
    ${mkColorSection "light_4" colors.blue}
    ${mkColorSection "light_5" colors.overlay0}

    ${mkColorSection "dark_1" colors.surface0}
    ${mkColorSection "dark_2" colors.surface1}
    ${mkColorSection "dark_3" colors.surface2}
    ${mkColorSection "dark_4" colors.mantle}
    ${mkColorSection "dark_5" colors.crust}

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
    ${mkColorSection "accent_bg_color" colors.${config.catppuccin.accent}}
    @define-color accent_fg_color @window_bg_color;
  '';
in {
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
