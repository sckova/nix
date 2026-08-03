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

  gtk4-exclusive = /* css */ ''
    window {
      --overview-bg-color: alpha(@sidebar_bg_color, 0.9);
      --overview-fg-color: @sidebar_fg_color;
    }
  '';
in
{
  dconf.settings = {
    "org/gnome/desktop/background".picture-uri =
      "files:///home/${config.home.homeDirectory}/.local/share/wallpaper/daily-colored.jpg";

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
      bookmarks = [
        "file://${config.home.homeDirectory}/Documents"
        "file://${config.home.homeDirectory}/Downloads"
        "file://${config.home.homeDirectory}/Music"
        "file://${config.home.homeDirectory}/Pictures"
        "file://${config.home.homeDirectory}/Projects"
        "file://${config.home.homeDirectory}/Templates"
        "file://${config.home.homeDirectory}/Videos"
      ];

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

  home.file = with builtins; {
    ".config/gtk-3.0/colors.css".text = colors;
    ".config/gtk-3.0/gtk.css".text = readFile ./gtk.css;
    ".config/gtk-4.0/colors.css".text = colors;
    ".config/gtk-4.0/gtk.css".text = readFile ./gtk.css + "\n" + gtk4-exclusive;
  };
}
