{
  config,
  pkgs,
  ...
}:
let
  colors = with config.scheme.withHashtag; ''
    @define-color base00 ${base00};
    @define-color base01 ${base01};
    @define-color base02 ${base02};
    @define-color base03 ${base03};
    @define-color base04 ${base04};
    @define-color base05 ${base05};
    @define-color base06 ${base06};
    @define-color base07 ${base07};
    @define-color base08 ${base08};
    @define-color base09 ${base09};
    @define-color base0A ${base0A};
    @define-color base0B ${base0B};
    @define-color base0C ${base0C};
    @define-color base0D ${base0D};
    @define-color base0E ${base0E};
    @define-color base0F ${base0F};
    @define-color accent ${config.scheme.withHashtag.${config.colors.accent}};
  '';

  css = /* css */ ''
    /* kova's GTK
     *
     * thanks to taiwbi on github:
     * https://github.com/taiwbi/hypaurora/blob/main/gtk-4.0/tweaks/sidebar.css
     * https://github.com/taiwbi/hypaurora/blob/main/gtk-4.0/themes/glass.css
     * this was also helpful:
     * https://gnome.pages.gitlab.gnome.org/libadwaita/doc/1.2/css-variables.html
    */

    @import "./colors.css";

    /* Base colors */
    @define-color window_bg_color @base00;
    @define-color window_fg_color @base05;

    /* View styling */
    @define-color view_bg_color @base00;
    @define-color view_fg_color @base05;

    /* Header bar */
    @define-color headerbar_bg_color @base10;
    @define-color headerbar_backdrop_color @base10;
    @define-color headerbar_fg_color @base05;

    /* Popovers and dialogs */
    @define-color popover_bg_color @base00;
    @define-color popover_fg_color @base05;
    @define-color dialog_bg_color @popover_bg_color;
    @define-color dialog_fg_color @popover_fg_color;

    /* Cards and sidebars */
    @define-color card_bg_color @base10;
    @define-color card_fg_color @base05;
    @define-color sidebar_bg_color @base10;
    @define-color sidebar_fg_color @base05;
    @define-color sidebar_backdrop_color @sidebar_bg_color;
    @define-color sidebar_border_color @base01;
    @define-color secondary_sidebar_bg_color @sidebar_bg_color;
    @define-color secondary_sidebar_fg_color @sidebar_fg_color;
    @define-color secondary_sidebar_backdrop_color @sidebar_backdrop_color;
    @define-color secondary_sidebar_border_color @sidebar_border_color;

    /* Overview */
    @define-color overview_bg_color @sidebar_bg_color;
    @define-color overview_fg_color @sidebar_fg_color;

    /* Accent colors */
    @define-color blue_1 @base0D;
    @define-color blue_2 @base16;
    @define-color blue_3 @base15;
    @define-color blue_4 @base0C;
    @define-color blue_5 @base07;

    @define-color green_1 @base0B;
    @define-color green_2 @base0C;
    @define-color green_3 @base15;
    @define-color green_4 @base16;
    @define-color green_5 @base0D;

    @define-color yellow_1 @base0A;
    @define-color yellow_2 @base09;
    @define-color yellow_3 @base0A;
    @define-color yellow_4 @base08;
    @define-color yellow_5 @base12;

    @define-color orange_1 @base09;
    @define-color orange_2 @base08;
    @define-color orange_3 @base12;
    @define-color orange_4 @base0A;
    @define-color orange_5 @base0B;

    @define-color red_1 @base08;
    @define-color red_2 @base12;
    @define-color red_3 @base17;
    @define-color red_4 @base0F;
    @define-color red_5 @base13;

    @define-color purple_1 @base0E;
    @define-color purple_2 @base07;
    @define-color purple_3 @base17;
    @define-color purple_4 @base0F;
    @define-color purple_5 @base13;

    @define-color brown_1 @base02;
    @define-color brown_2 @base03;
    @define-color brown_3 @base03;
    @define-color brown_4 @base03;
    @define-color brown_5 @base04;

    @define-color light_1 @base05;
    @define-color light_2 @base04;
    @define-color light_3 @base04;
    @define-color light_4 @base0D;
    @define-color light_5 @base03;

    @define-color dark_1 @base01;
    @define-color dark_2 @base02;
    @define-color dark_3 @base02;
    @define-color dark_4 @base10;
    @define-color dark_5 @base11;

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
    @define-color accent_bg_color @accent;
    @define-color accent_fg_color @window_bg_color;

    .content-pane {
      background: transparent;
    }

    window.csd,
    window.csd decoration {
      border-radius: 8px;
      border: none;
      box-shadow: none;
    }

    window,
    #NautilusFileChooser.background {
      background-color: alpha(@view_bg_color, 0.9);
    }

    #NautilusFileChooser overlay-split-view.view {
      background: transparent;
    }

    .sidebar-pane,
    .sidebar,
    navigation-sidebar {
      background: alpha(@sidebar_bg_color, 0.9);
    }

    /* Enforce header bar background colors */
    headerbar,
    .titlebar {
      background-color: @headerbar_bg_color;
      background-image: none;
    }

    headerbar:backdrop,
    .titlebar:backdrop {
      background-color: @headerbar_backdrop_color;
      background-image: none;
    } /**/
  '';

  gtk4-exclusive = /* css */ ''
    window {
      --overview-bg-color: alpha(@sidebar_bg_color, 0.9);
      --overview-fg-color: @sidebar_fg_color;
    }
  '';
in
{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      clock-format = "12h";
      clock-show-weekday = true;
      color-scheme = "prefer-dark";
    };

    "org/gnome/desktop/media-handling" = {
      automount = false;
      automount-open = false;
      autorun-never = true;
    };

    "org/gnome/desktop/wm/preferences" = {
      action-double-click-titlebar = "\'none\'";
      button-layout = "menu:maximize,close";
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      edge-tiling = true;
      experimental-features = [ "variable-refresh-rate" ];
    };

    "org/gnome/settings-daemon/plugins/power".sleep-inactive-ac-type = "nothing";
  };

  gtk = {
    enable = true;

    cursorTheme = with config.home.pointerCursor; {
      package = package;
      name = name;
      size = size;
    };

    font = with config.fonts.sans; {
      package = package;
      name = name;
      size = size - 1;
    };

    gtk3 = {
      extraConfig.gtk-application-prefer-dark-theme = true;

      theme = {
        package = pkgs.adw-gtk3;
        name = "adw-gtk3";
      };
    };

    gtk4.theme = null;

    iconTheme = {
      package = pkgs.morewaita-icon-theme;
      name = "MoreWaita";
    };
  };

  home.file = {
    ".config/gtk-3.0/colors.css".text = colors;
    ".config/gtk-3.0/gtk.css".text = css;
    ".config/gtk-4.0/colors.css".text = colors;
    ".config/gtk-4.0/gtk.css".text = css + "\n" + gtk4-exclusive;
  };
}
