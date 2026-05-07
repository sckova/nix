{
  config,
  pkgs,
  ...
}:
let
  generateCSS = with config.scheme.withHashtag; /* css */ ''
    /* kova's GTK
     *
     * thanks to taiwbi on github:
     * https://github.com/taiwbi/hypaurora/blob/main/gtk-4.0/tweaks/sidebar.css
     * https://github.com/taiwbi/hypaurora/blob/main/gtk-4.0/themes/glass.css
     * this was also helpful:
     * https://gnome.pages.gitlab.gnome.org/libadwaita/doc/1.2/css-variables.html
    */

    /* Base colors */
    @define-color window_bg_color ${base00};
    @define-color window_fg_color ${base05};

    /* View styling */
    @define-color view_bg_color ${base00};
    @define-color view_fg_color ${base05};

    /* Header bar */
    @define-color headerbar_bg_color ${base10};
    @define-color headerbar_backdrop_color ${base10};
    @define-color headerbar_fg_color ${base05};

    /* Popovers and dialogs */
    @define-color popover_bg_color ${base00};
    @define-color popover_fg_color ${base05};
    @define-color dialog_bg_color @popover_bg_color;
    @define-color dialog_fg_color @popover_fg_color;

    /* Cards and sidebars */
    @define-color card_bg_color ${base10};
    @define-color card_fg_color ${base05};
    @define-color sidebar_bg_color ${base10};
    @define-color sidebar_fg_color ${base05};
    @define-color sidebar_backdrop_color @sidebar_bg_color;
    @define-color sidebar_border_color ${base01};
    @define-color secondary_sidebar_bg_color @sidebar_bg_color;
    @define-color secondary_sidebar_fg_color @sidebar_fg_color;
    @define-color secondary_sidebar_backdrop_color @sidebar_backdrop_color;
    @define-color secondary_sidebar_border_color @sidebar_border_color;

    /* Accent colors */
    @define-color blue_1 ${base0D};
    @define-color blue_2 ${base16};
    @define-color blue_3 ${base15};
    @define-color blue_4 ${base0C};
    @define-color blue_5 ${base07};

    @define-color green_1 ${base0B};
    @define-color green_2 ${base0C};
    @define-color green_3 ${base15};
    @define-color green_4 ${base16};
    @define-color green_5 ${base0D};

    @define-color yellow_1 ${base0A};
    @define-color yellow_2 ${base09};
    @define-color yellow_3 ${base0A};
    @define-color yellow_4 ${base08};
    @define-color yellow_5 ${base12};

    @define-color orange_1 ${base09};
    @define-color orange_2 ${base08};
    @define-color orange_3 ${base12};
    @define-color orange_4 ${base0A};
    @define-color orange_5 ${base0B};

    @define-color red_1 ${base08};
    @define-color red_2 ${base12};
    @define-color red_3 ${base17};
    @define-color red_4 ${base0F};
    @define-color red_5 ${base13};

    @define-color purple_1 ${base0E};
    @define-color purple_2 ${base07};
    @define-color purple_3 ${base17};
    @define-color purple_4 ${base0F};
    @define-color purple_5 ${base13};

    @define-color brown_1 ${base02};
    @define-color brown_2 ${base03};
    @define-color brown_3 ${base03};
    @define-color brown_4 ${base03};
    @define-color brown_5 ${base04};

    @define-color light_1 ${base05};
    @define-color light_2 ${base04};
    @define-color light_3 ${base04};
    @define-color light_4 ${base0D};
    @define-color light_5 ${base03};

    @define-color dark_1 ${base01};
    @define-color dark_2 ${base02};
    @define-color dark_3 ${base02};
    @define-color dark_4 ${base10};
    @define-color dark_5 ${base11};

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
    @define-color accent_bg_color ${config.colors.accent};
    @define-color accent_fg_color @window_bg_color;

    .content-pane {
      background: transparent;
    }

    window.csd, window.csd decoration {
      border-radius: 8px;
      border: none;
      box-shadow: none;
    }

    window, #NautilusFileChooser.background {
      background-color: alpha(@view_bg_color, 0.9);

      /* Tab overview */
      --overview-bg-color: alpha(@sidebar_bg_color, 0.9);
      --overview-fg-color: @sidebar_fg_color;
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
    }
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

  gtk = {
    enable = true;
    gtk4.theme = null;
    colorScheme = "dark";

    iconTheme = {
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme;
    };

    cursorTheme = {
      name = config.home.pointerCursor.name;
      package = config.home.pointerCursor.package;
      size = config.home.pointerCursor.size;
    };

    font = {
      name = config.userOptions.fontSans.name;
      package = config.userOptions.fontSans.package;
      size = config.userOptions.fontSans.size - 1;
    };

    gtk3.theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      clock-format = "12h";
      clock-show-weekday = true;
    };
    "org/gnome/desktop/media-handling" = {
      automount = false;
      automount-open = false;
      autorun-never = true;
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "menu:maximize,close";
      action-double-click-titlebar = "\'none\'";
    };
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
    };
    "org/gnome/mutter" = {
      edge-tiling = true;
      dynamic-workspaces = true;
      experimental-features = [ "variable-refresh-rate" ];
    };
  };
}
