# since https://github.com/sodiboo/niri-flake doesn't currently
# have many of the latest options, we write this directly
# https://github.com/niri-wm/niri/wiki/
{
  config,
  lib,
  pkgs,
  hostname,
  ...
}:
{
  home.file.".config/niri/config.kdl".text = lib.hm.generators.toKDL { } {
    # --- Top-Level Repeated Nodes (_children approach) ---
    _children =
      lib.optionals (hostname == "peach") [
        { debug.render-drm-device._args = [ "/dev/dri/renderD128" ]; }
      ]
      ++ [

        # --- Outputs ---
        {
          output = {
            _args = [ "eDP-1" ];
            mode = "3024x1964@120.000";

            position._props = {
              x = 272;
              y = 1440;
            };

            scale = 1.5;
          };
        }
        {
          output = {
            _args = [ "HDMI-A-1" ];
            mode = "3840x2160@144.000";

            position._props = {
              x = 0;
              y = 0;
            };

            scale = 1.5;
          };
        }
        {
          output = {
            _args = [ "DP-1" ];
            mode = "3840x2160@143.999";

            position._props = {
              x = 0;
              y = 0;
            };

            scale = 1.5;
          };
        }

        # --- Rules ---
        {
          window-rule = {
            background-effect = {
              blur = true;
              noise = 0.03;
              saturation = 1.0;
              xray = false;
            };

            clip-to-geometry = true;
            draw-border-with-background = false;

            geometry-corner-radius._args = [
              16.0
              16.0
              8.0
              8.0
            ];

            opacity = 0.90;
          };
        }
        {
          window-rule = {
            _children = [
              { match._props.app-id = "org.gnome.Nautilus$"; }
            ];

            block-out-from = "screen-capture";
          };
        }
        # for games and apps that we want 100% opacity and windowed fullscreen for
        {
          window-rule = {
            _children = [
              {
                match._props = {
                  app-id = "openmw";
                  title = "OpenMW";
                };
              }
              {
                match._props = {
                  app-id = "Minecraft";
                  title = "Minecraft";
                };
              }
              {
                match._props = {
                  app-id = "com.moonlight_stream.Moonlight";
                  title = "Moonlight";
                };
              }
              {
                match._props = {
                  app-id = ".*soh.*";
                  title = "^Ship of Harkinian.*";
                };
              }
              {
                match._props = {
                  app-id = "^dolphin-emu$";
                  title = "Dolphin.*";
                };
              }
              {
                match._props = {
                  app-id = "net.kuribo64.melonDS";
                  title = "^melonDS.*";
                };
              }
              {
                match._props = {
                  app-id = "^helium$";
                  title = ".* - Helium$";
                };
              }
              {
                match._props.app-id = "^org.gnome.FileRoller$";
              }
              {
                match._props.app-id = "^org.gnome.Maps$";
              }
              {
                match._props.app-id = "^org.gnome.font-viewer$";
              }
              {
                match._props.app-id = "^org.gnome.Calendar$";
              }
            ];

            opacity = 1.00;
            open-focused = true;
            open-maximized = true;
          };
        }
        {
          window-rule = {
            _children = [
              {
                match._props = {
                  app-id = "firefox";
                  title = "Picture-in-Picture";
                };
              }
              {
                match._props = {
                  app-id = "";
                  title = "Picture in picture";
                };
              }
            ];

            opacity = 1.0;
          };
        }
        # Ghostty Fastfetch window
        {
          window-rule = {
            baba-is-float = true;

            match._props = {
              app-id = "^com.mitchellh.ghostty$";
              title = "^fastfetch$";
            };

            max-height = 480;
            max-width = 960;
            min-height = 480;
            min-width = 960;
            open-floating = true;
          };
        }
        # for apps that can handle their own background opacity
        {
          window-rule = {
            _children = [
              { match._props.app-id = "^com.mitchellh.ghostty$"; }
              { match._props.app-id = "^org.gnome.Nautilus$"; }
              {
                match._props = {
                  app-id = "^mpv$";
                  title = ".* - mpv \\\\(nix\\\\)$";
                };
              }
              { match._props.app-id = "^org.gnome.Fractal$"; }
              { match._props.app-id = "^firefox$"; }
              { match._props.app-id = "^org.gnome.Snapshot$"; }
              { match._props.app-id = "^org.gnome.Papers$"; }
              { match._props.app-id = "^vicinae$"; }
            ];

            opacity = 1.0;
          };
        }
        {
          layer-rule = {
            match._props.namespace = "^wallpaper$";
            place-within-backdrop = true;
          };
        }
      ];

    # --- Keybinds ---
    binds = {
      "Alt+Shift+S".screenshot-window._props.show-pointer = false;
      "Ctrl+Alt+Delete".quit = { };
      "Ctrl+Shift+S".screenshot-screen._props.show-pointer = false;

      "Ctrl+Shift+XF86AudioLowerVolume".spawn._args = [
        "${pkgs.wireplumber}/bin/wpctl"
        "set-volume"
        "@DEFAULT_AUDIO_SOURCE@"
        "0.01-"
      ];

      "Ctrl+Shift+XF86AudioRaiseVolume".spawn._args = [
        "${pkgs.wireplumber}/bin/wpctl"
        "set-volume"
        "@DEFAULT_AUDIO_SOURCE@"
        "0.01+"
      ];

      "Ctrl+Shift+XF86MonBrightnessDown".spawn._args = [
        "${pkgs.brightnessctl}/bin/brightnessctl"
        "-d"
        "kbd_backlight"
        "-c"
        "leds"
        "set"
        "1%-"
      ];

      "Ctrl+Shift+XF86MonBrightnessUp".spawn._args = [
        "${pkgs.brightnessctl}/bin/brightnessctl"
        "-d"
        "kbd_backlight"
        "-c"
        "leds"
        "set"
        "+1%"
      ];

      "Ctrl+XF86AudioLowerVolume".spawn._args = [
        "${pkgs.wireplumber}/bin/wpctl"
        "set-volume"
        "@DEFAULT_AUDIO_SOURCE@"
        "0.05-"
      ];

      "Ctrl+XF86AudioMute".spawn._args = [
        "${pkgs.wireplumber}/bin/wpctl"
        "set-mute"
        "@DEFAULT_AUDIO_SOURCE@"
        "toggle"
      ];

      "Ctrl+XF86AudioRaiseVolume".spawn._args = [
        "${pkgs.wireplumber}/bin/wpctl"
        "set-volume"
        "@DEFAULT_AUDIO_SOURCE@"
        "0.05+"
      ];

      "Ctrl+XF86MonBrightnessDown".spawn._args = [
        "${pkgs.brightnessctl}/bin/brightnessctl"
        "-d"
        "kbd_backlight"
        "-c"
        "leds"
        "set"
        "5%-"
      ];

      "Ctrl+XF86MonBrightnessUp".spawn._args = [
        "${pkgs.brightnessctl}/bin/brightnessctl"
        "-d"
        "kbd_backlight"
        "-c"
        "leds"
        "set"
        "+5%"
      ];

      "Mod+1".focus-workspace._args = [ 1 ];
      "Mod+2".focus-workspace._args = [ 2 ];
      "Mod+3".focus-workspace._args = [ 3 ];
      "Mod+4".focus-workspace._args = [ 4 ];
      "Mod+5".focus-workspace._args = [ 5 ];
      "Mod+6".focus-workspace._args = [ 6 ];
      "Mod+7".focus-workspace._args = [ 7 ];
      "Mod+8".focus-workspace._args = [ 8 ];
      "Mod+9".focus-workspace._args = [ 9 ];
      "Mod+BracketLeft".consume-or-expel-window-left = { };
      "Mod+BracketRight".consume-or-expel-window-right = { };
      "Mod+C".center-column = { };
      "Mod+Comma".consume-window-into-column = { };
      "Mod+Ctrl+1".move-column-to-workspace._args = [ 1 ];
      "Mod+Ctrl+2".move-column-to-workspace._args = [ 2 ];
      "Mod+Ctrl+3".move-column-to-workspace._args = [ 3 ];
      "Mod+Ctrl+4".move-column-to-workspace._args = [ 4 ];
      "Mod+Ctrl+5".move-column-to-workspace._args = [ 5 ];
      "Mod+Ctrl+6".move-column-to-workspace._args = [ 6 ];
      "Mod+Ctrl+7".move-column-to-workspace._args = [ 7 ];
      "Mod+Ctrl+8".move-column-to-workspace._args = [ 8 ];
      "Mod+Ctrl+9".move-column-to-workspace._args = [ 9 ];
      "Mod+Ctrl+C".center-visible-columns = { };
      "Mod+Ctrl+Down".move-window-down = { };
      "Mod+Ctrl+End".move-column-to-last = { };
      "Mod+Ctrl+Equal".set-column-width._args = [ "+0.25%" ];
      "Mod+Ctrl+H".move-column-left = { };
      "Mod+Ctrl+Home".move-column-to-first = { };
      "Mod+Ctrl+I".move-column-to-workspace-up = { };
      "Mod+Ctrl+J".move-window-down = { };
      "Mod+Ctrl+K".move-window-up = { };
      "Mod+Ctrl+L".move-column-right = { };
      "Mod+Ctrl+Left".move-column-left = { };
      "Mod+Ctrl+Minus".set-column-width._args = [ "-0.25%" ];
      "Mod+Ctrl+Page_Down".move-column-to-workspace-down = { };
      "Mod+Ctrl+Page_Up".move-column-to-workspace-up = { };
      "Mod+Ctrl+R".reset-window-height = { };
      "Mod+Ctrl+Right".move-column-right = { };
      "Mod+Ctrl+Shift+Equal".set-window-height._args = [ "+0.25%" ];
      "Mod+Ctrl+Shift+F".fullscreen-window = { };
      "Mod+Ctrl+Shift+Minus".set-window-height._args = [ "-0.25%" ];
      "Mod+Ctrl+Shift+WheelScrollDown".move-column-right = { };
      "Mod+Ctrl+Shift+WheelScrollUp".move-column-left = { };
      "Mod+Ctrl+U".move-column-to-workspace-down = { };
      "Mod+Ctrl+Up".move-window-up = { };

      "Mod+Ctrl+WheelScrollDown" = {
        _props.cooldown-ms = 150;
        move-column-to-workspace-down = { };
      };

      "Mod+Ctrl+WheelScrollLeft".move-column-left = { };
      "Mod+Ctrl+WheelScrollRight".move-column-right = { };

      "Mod+Ctrl+WheelScrollUp" = {
        _props.cooldown-ms = 150;
        move-column-to-workspace-up = { };
      };

      "Mod+D".toggle-window-rule-opacity = { };
      "Mod+Down".focus-window-down = { };
      "Mod+End".focus-column-last = { };
      "Mod+Equal".set-column-width._args = [ "+10%" ];

      "Mod+Escape" = {
        _props.allow-inhibiting = false;
        toggle-keyboard-shortcuts-inhibit = { };
      };

      "Mod+F".maximize-column = { };
      "Mod+Home".focus-column-first = { };
      "Mod+I".focus-workspace-up = { };
      # --- Window & Column Management ---
      "Mod+Left".focus-column-left = { };
      "Mod+Minus".set-column-width._args = [ "-10%" ];
      "Mod+O".toggle-overview = { };
      # --- Workspaces ---
      "Mod+Page_Down".focus-workspace-down = { };
      "Mod+Page_Up".focus-workspace-up = { };
      "Mod+Period".expel-window-from-column = { };
      "Mod+Q".close-window = { };
      "Mod+R".switch-preset-column-width = { };
      "Mod+Right".focus-column-right = { };
      "Mod+Shift+Ctrl+Down".move-column-to-monitor-down = { };
      "Mod+Shift+Ctrl+H".move-column-to-monitor-left = { };
      "Mod+Shift+Ctrl+J".move-column-to-monitor-down = { };
      "Mod+Shift+Ctrl+K".move-column-to-monitor-up = { };
      "Mod+Shift+Ctrl+L".move-column-to-monitor-right = { };
      "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = { };
      "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = { };
      "Mod+Shift+Ctrl+Up".move-column-to-monitor-up = { };
      "Mod+Shift+Down".focus-monitor-down = { };
      "Mod+Shift+E".quit = { };
      "Mod+Shift+Equal".set-window-height._args = [ "+10%" ];
      "Mod+Shift+F".maximize-window-to-edges = { };
      "Mod+Shift+I".move-workspace-up = { };
      "Mod+Shift+L".spawn._args = [ "${pkgs.swaylock}/bin/swaylock" ];
      # --- Monitor Movement ---
      "Mod+Shift+Left".focus-monitor-left = { };
      "Mod+Shift+Minus".set-window-height._args = [ "-10%" ];
      "Mod+Shift+P".power-off-monitors = { };
      "Mod+Shift+Page_Down".move-workspace-down = { };
      "Mod+Shift+Page_Up".move-workspace-up = { };
      "Mod+Shift+R".switch-preset-window-height = { };
      "Mod+Shift+Right".focus-monitor-right = { };
      # --- Screenshots ---
      "Mod+Shift+S".screenshot._props.show-pointer = false;
      "Mod+Shift+Slash".show-hotkey-overlay = { };

      # Open a Terminal with Fastfetch
      "Mod+Shift+T".spawn._args = [
        "sh"
        "-c"
        "${pkgs.ghostty}/bin/ghostty --title='fastfetch' -e sh -c 'fastfetch; sleep 10'"
      ];

      "Mod+Shift+U".move-workspace-down = { };
      "Mod+Shift+Up".focus-monitor-up = { };
      "Mod+Shift+V".switch-focus-between-floating-and-tiling = { };
      "Mod+Shift+WheelScrollDown".focus-column-right = { };
      "Mod+Shift+WheelScrollUp".focus-column-left = { };

      "Mod+Space".spawn._args = [
        "${pkgs.vicinae}/bin/vicinae"
        "toggle"
      ];

      "Mod+T".spawn._args = [ "${pkgs.ghostty}/bin/ghostty" ];
      "Mod+U".focus-workspace-down = { };
      "Mod+Up".focus-window-up = { };
      "Mod+V".toggle-window-floating = { };
      "Mod+W".toggle-column-tabbed-display = { };

      # --- Mouse Wheel & Scrolling Navigation ---
      "Mod+WheelScrollDown" = {
        _props.cooldown-ms = 150;
        focus-workspace-down = { };
      };

      "Mod+WheelScrollLeft".focus-column-left = { };
      "Mod+WheelScrollRight".focus-column-right = { };

      "Mod+WheelScrollUp" = {
        _props.cooldown-ms = 150;
        focus-workspace-up = { };
      };

      "MouseBack".spawn._args = [
        "${pkgs.wireplumber}/bin/wpctl"
        "set-volume"
        "@DEFAULT_AUDIO_SINK@"
        "0.05-"
      ];

      "MouseForward".spawn._args = [
        "${pkgs.wireplumber}/bin/wpctl"
        "set-volume"
        "@DEFAULT_AUDIO_SINK@"
        "0.05+"
      ];

      "Shift+MouseBack".spawn._args = [
        "${pkgs.wireplumber}/bin/wpctl"
        "set-volume"
        "@DEFAULT_AUDIO_SINK@"
        "0.01-"
      ];

      "Shift+MouseForward".spawn._args = [
        "${pkgs.wireplumber}/bin/wpctl"
        "set-volume"
        "@DEFAULT_AUDIO_SINK@"
        "0.01+"
      ];

      "Shift+XF86AudioLowerVolume".spawn._args = [
        "${pkgs.wireplumber}/bin/wpctl"
        "set-volume"
        "@DEFAULT_AUDIO_SINK@"
        "0.01-"
      ];

      "Shift+XF86AudioRaiseVolume".spawn._args = [
        "${pkgs.wireplumber}/bin/wpctl"
        "set-volume"
        "@DEFAULT_AUDIO_SINK@"
        "0.01+"
      ];

      "Shift+XF86MonBrightnessDown".spawn._args = [
        "${pkgs.noctalia}/bin/noctalia"
        "msg"
        "brightness-down"
        "all"
        "1"
      ];

      "Shift+XF86MonBrightnessUp".spawn._args = [
        "${pkgs.noctalia}/bin/noctalia"
        "msg"
        "brightness-up"
        "all"
        "1"
      ];

      "XF86AudioLowerVolume".spawn._args = [
        "${pkgs.wireplumber}/bin/wpctl"
        "set-volume"
        "@DEFAULT_AUDIO_SINK@"
        "0.05-"
      ];

      "XF86AudioMicMute".spawn._args = [
        "${pkgs.wireplumber}/bin/wpctl"
        "set-mute"
        "@DEFAULT_AUDIO_SOURCE@"
        "toggle"
      ];

      "XF86AudioMute".spawn._args = [
        "${pkgs.wireplumber}/bin/wpctl"
        "set-mute"
        "@DEFAULT_AUDIO_SINK@"
        "toggle"
      ];

      "XF86AudioNext".spawn._args = [
        "${pkgs.playerctl}/bin/playerctl"
        "next"
      ];

      "XF86AudioPlay".spawn._args = [
        "${pkgs.playerctl}/bin/playerctl"
        "play-pause"
      ];

      "XF86AudioPrev".spawn._args = [
        "${pkgs.playerctl}/bin/playerctl"
        "previous"
      ];

      # --- Media Controls ---
      "XF86AudioRaiseVolume".spawn._args = [
        "${pkgs.wireplumber}/bin/wpctl"
        "set-volume"
        "@DEFAULT_AUDIO_SINK@"
        "0.05+"
      ];

      "XF86LaunchA".toggle-overview = { };

      "XF86MonBrightnessDown".spawn._args = [
        "${pkgs.noctalia}/bin/noctalia"
        "msg"
        "brightness-down"
        "all"
        "5"
      ];

      "XF86MonBrightnessUp".spawn._args = [
        "${pkgs.noctalia}/bin/noctalia"
        "msg"
        "brightness-up"
        "all"
        "5"
      ];

      # --- Launchers & System ---
      "XF86Search".spawn._args = [ "${pkgs.vicinae}/bin/vicinae" ];
      "XF86Sleep".power-off-monitors = { };
    };

    cursor = {
      xcursor-size = config.cursor.size;
      xcursor-theme = config.cursor.name;
    };

    environment = {
      DISPLAY = ":0";
      XCURSOR_SIZE = toString config.cursor.size;
      XCURSOR_THEME = config.cursor.name;
    };

    gestures.hot-corners.off = { };
    hotkey-overlay.skip-at-startup = { };

    # --- Input ---
    input = {
      focus-follows-mouse._props.max-scroll-amount = "5%";

      keyboard = {
        repeat-delay = 600;
        repeat-rate = 25;
      };

      mod-key = "Super";
      mouse.accel-profile = "adaptive";

      touchpad = {
        accel-profile = "adaptive";
        drag = true;
        natural-scroll = { };
      };
    };

    layout = {
      background-color = "transparent";

      border = with config.scheme; {
        active-color = withHashtag.${config.colors.accent};
        inactive-color = withHashtag.base01;
        urgent-color = withHashtag.base12;
        width = 2;
      };

      default-column-width.proportion = 0.5;
      focus-ring.off = { };
      gaps = 6;
      insert-hint.color = config.scheme.withHashtag.${config.colors.accent} + "80";

      preset-column-widths._children = [
        { proportion._args = [ 0.33333 ]; }
        { proportion._args = [ 0.50000 ]; }
        { proportion._args = [ 0.66667 ]; }
      ];

      shadow = {
        color = config.scheme.withHashtag.base11 + "bf";

        offset._props = {
          x = 0;
          y = 0;
        };

        on = { };
        softness = 10;
        spread = 5;
      };

      tab-indicator = {
        gap = 4;
        length._props."total-proportion" = 1.0;
        place-within-column = { };
        position = "top";
        width = 6;
      };
    };

    # --- Layout ---
    overview = {
      backdrop-color = config.scheme.withHashtag.base11;
      workspace-shadow.off = { };
      zoom = 0.75;
    };

    screenshot-path = "~/Pictures/Screenshots/%a %b %e %Y @%l:%M %p.png";
  };
}
