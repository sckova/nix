{
  config,
  lib,
  pkgs,
  ...
}:
{
  dconf.settings =
    let
      flatten =
        stopAt: prefix: attrs:
        lib.concatMapAttrs (
          name: value:
          let
            key = if prefix == "" then name else "${prefix}.${name}";
          in
          if builtins.isAttrs value && !(builtins.elem key stopAt) then
            flatten stopAt key value
          else
            { ${key} = value; }
        ) attrs;
    in
    lib.mapAttrs'
      (name: value: {
        inherit value;
        name = (builtins.replaceStrings [ "." ] [ "/" ]) name;
      })
      (
        flatten
          [
            "org.gnome.desktop.background"
            "org.gnome.desktop.interface"
            "org.gnome.desktop.media-handling"
            "org.gnome.desktop.wm.preferences"
            "org.gnome.mutter"
            "org.gnome.settings-daemon.plugins.power"
          ]
          ""
          {
            org.gnome = {
              desktop = {
                background.picture-uri = "files://${config.xdg.dataHome}/wallpaper/daily-colored.jpg";

                interface = {
                  clock-format = "12h";
                  clock-show-weekday = true;
                  color-scheme = "prefer-dark";
                };

                media-handling = {
                  automount = false;
                  automount-open = false;
                  autorun-never = true;
                };

                wm.preferences = {
                  action-double-click-titlebar = "'none'";
                  button-layout = "menu:maximize,close";
                };
              };

              mutter = {
                dynamic-workspaces = true;
                edge-tiling = true;
                experimental-features = [ "variable-refresh-rate" ];
              };

              settings-daemon.plugins.power.sleep-inactive-ac-type = "nothing";
            };
          }
      );

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
      bookmarks =
        let
          home = "file://" + config.home.homeDirectory + "/";
        in
        [
          (home + "Documents")
          (home + "Downloads")
          (home + "Music")
          (home + "Pictures")
          (home + "Projects")
          (home + "Templates")
          (home + "Videos")
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

  home.file =
    with builtins;
    let
      colors = ''
        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (name: value: "@define-color ${name} ${value};") (
            lib.filterAttrs (_: v: builtins.isString v) config.scheme.withHashtag
          )
        )}
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
      ".config/gtk-3.0/colors.css".text = colors;
      ".config/gtk-3.0/gtk.css".text = readFile ./gtk.css;
      ".config/gtk-4.0/colors.css".text = colors;
      ".config/gtk-4.0/gtk.css".text = readFile ./gtk.css + "\n" + gtk4-exclusive;
    };
}
