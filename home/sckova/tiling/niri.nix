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
    environment = {
      DISPLAY = ":0";
      XCURSOR_THEME = config.cursor.name;
      XCURSOR_SIZE = toString config.cursor.size;
    };
    screenshot-path = "~/Pictures/Screenshots/%a %b %e %Y @%l:%M %p.png";
    hotkey-overlay.skip-at-startup = { };

    # --- Input ---
    input = {
      mod-key = "Super";
      keyboard = {
        repeat-delay = 600;
        repeat-rate = 25;
      };
      mouse.accel-profile = "adaptive";
      touchpad = {
        accel-profile = "adaptive";
        natural-scroll = { };
        dwt = { };
        drag = true;
      };
      focus-follows-mouse._props.max-scroll-amount = "5%";
    };
    cursor = {
      xcursor-theme = config.cursor.name;
      xcursor-size = config.cursor.size;
    };

    # --- Layout ---
    overview = {
      backdrop-color = config.scheme.withHashtag.base11;
      workspace-shadow.off = { };
      zoom = 0.75;
    };
    layout = {
      background-color = "transparent";
      gaps = 4;
      preset-column-widths._children = [
        { proportion._args = [ 0.33333 ]; }
        { proportion._args = [ 0.50000 ]; }
        { proportion._args = [ 0.66667 ]; }
      ];
      default-column-width.proportion = 0.5;
      border = with config.scheme; {
        width = 2;
        active-color = withHashtag.${config.colors.accent};
        inactive-color = withHashtag.base01;
        urgent-color = withHashtag.base12;
      };
      focus-ring.off = { };
      shadow = {
        on = { };
        spread = 5;
        softness = 10;
        offset._props = {
          x = 0;
          y = 0;
        };
        color = config.scheme.withHashtag.base11 + "bf";
      };
      struts = {
        top = if hostname == "peach" then 46 else 0; # make sure the notch is always blocked
      };
      tab-indicator = {
        width = 6;
        gap = 4;
        length._props."total-proportion" = 1.0;
        position = "top";
        place-within-column = { };
      };
      insert-hint.color = config.scheme.withHashtag.${config.colors.accent} + "80";
    };

    # --- Keybinds ---
    binds = {
      "Mod+Shift+Slash".show-hotkey-overlay = { };
      "Mod+D".toggle-window-rule-opacity = { };
      "Mod+M".spawn._args = [
        "${pkgs.wireplumber}/bin/wpctl"
        "set-mute"
        "@DEFAULT_AUDIO_SOURCE@"
        "toggle"
      ];
      "Mod+T".spawn._args = [ "${pkgs.ghostty}/bin/ghostty" ];
      "Mod+Space".spawn._args = [
        "${pkgs.vicinae}/bin/vicinae"
        "toggle"
      ];
      # Open a Terminal with Fastfetch
      "Mod+Shift+T".spawn._args = [
        "sh"
        "-c"
        "${pkgs.ghostty}/bin/ghostty --title='fastfetch' -e sh -c 'fastfetch; sleep 10'"
      ];

      # --- Media Controls ---
      "XF86AudioRaiseVolume".spawn._args = [
        "${pkgs.wireplumber}/bin/wpctl"
        "set-volume"
        "@DEFAULT_AUDIO_SINK@"
        "0.05+"
      ];
      "XF86AudioLowerVolume".spawn._args = [
        "${pkgs.wireplumber}/bin/wpctl"
        "set-volume"
        "@DEFAULT_AUDIO_SINK@"
        "0.05-"
      ];
      "Shift+XF86AudioRaiseVolume".spawn._args = [
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
      "MouseForward".spawn._args = [
        "${pkgs.wireplumber}/bin/wpctl"
        "set-volume"
        "@DEFAULT_AUDIO_SINK@"
        "0.05+"
      ];
      "MouseBack".spawn._args = [
        "${pkgs.wireplumber}/bin/wpctl"
        "set-volume"
        "@DEFAULT_AUDIO_SINK@"
        "0.05-"
      ];
      "Shift+MouseForward".spawn._args = [
        "${pkgs.wireplumber}/bin/wpctl"
        "set-volume"
        "@DEFAULT_AUDIO_SINK@"
        "0.01+"
      ];
      "Shift+MouseBack".spawn._args = [
        "${pkgs.wireplumber}/bin/wpctl"
        "set-volume"
        "@DEFAULT_AUDIO_SINK@"
        "0.01-"
      ];
      "XF86AudioMute".spawn._args = [
        "${pkgs.wireplumber}/bin/wpctl"
        "set-mute"
        "@DEFAULT_AUDIO_SINK@"
        "toggle"
      ];
      "XF86AudioMicMute".spawn._args = [
        "${pkgs.wireplumber}/bin/wpctl"
        "set-mute"
        "@DEFAULT_AUDIO_SOURCE@"
        "toggle"
      ];
      "XF86MonBrightnessUp".spawn._args = [
        "${pkgs.noctalia-shell}/bin/noctalia-shell"
        "ipc"
        "call"
        "brightness"
        "increase"
      ];
      "XF86MonBrightnessDown".spawn._args = [
        "${pkgs.noctalia-shell}/bin/noctalia-shell"
        "ipc"
        "call"
        "brightness"
        "decrease"
      ];
      "Shift+XF86MonBrightnessUp".spawn._args = [
        "${pkgs.brightnessctl}/bin/brightnessctl"
        "--class=backlight"
        "set"
        "+1%"
      ];
      "Shift+XF86MonBrightnessDown".spawn._args = [
        "${pkgs.brightnessctl}/bin/brightnessctl"
        "--class=backlight"
        "set"
        "1%-"
      ];
      "XF86AudioPrev".spawn._args = [
        "${pkgs.playerctl}/bin/playerctl"
        "previous"
      ];
      "XF86AudioPlay".spawn._args = [
        "${pkgs.playerctl}/bin/playerctl"
        "play-pause"
      ];
      "XF86AudioNext".spawn._args = [
        "${pkgs.playerctl}/bin/playerctl"
        "next"
      ];

      # --- Launchers & System ---
      "XF86Search".spawn._args = [ "${pkgs.vicinae}/bin/vicinae" ];
      "Mod+Shift+L".spawn._args = [ "${pkgs.swaylock}/bin/swaylock" ];
      "XF86LaunchA".toggle-overview = { };
      "Mod+O".toggle-overview = { };
      "XF86Sleep".power-off-monitors = { };
      "Mod+Shift+P".power-off-monitors = { };
      "Mod+Q".close-window = { };
      "Mod+Escape" = {
        _props.allow-inhibiting = false;
        toggle-keyboard-shortcuts-inhibit = { };
      };
      "Mod+Shift+E".quit = { };
      "Ctrl+Alt+Delete".quit = { };

      # --- Window & Column Management ---
      "Mod+Left".focus-column-left = { };
      "Mod+Down".focus-window-down = { };
      "Mod+Up".focus-window-up = { };
      "Mod+Right".focus-column-right = { };
      "Mod+Ctrl+Left".move-column-left = { };
      "Mod+Ctrl+Down".move-window-down = { };
      "Mod+Ctrl+Up".move-window-up = { };
      "Mod+Ctrl+Right".move-column-right = { };
      "Mod+Ctrl+H".move-column-left = { };
      "Mod+Ctrl+J".move-window-down = { };
      "Mod+Ctrl+K".move-window-up = { };
      "Mod+Ctrl+L".move-column-right = { };
      "Mod+Home".focus-column-first = { };
      "Mod+End".focus-column-last = { };
      "Mod+Ctrl+Home".move-column-to-first = { };
      "Mod+Ctrl+End".move-column-to-last = { };
      "Mod+BracketLeft".consume-or-expel-window-left = { };
      "Mod+BracketRight".consume-or-expel-window-right = { };
      "Mod+Comma".consume-window-into-column = { };
      "Mod+Period".expel-window-from-column = { };
      "Mod+R".switch-preset-column-width = { };
      "Mod+Shift+R".switch-preset-window-height = { };
      "Mod+Ctrl+R".reset-window-height = { };
      "Mod+F".maximize-column = { };
      "Mod+Shift+F".maximize-window-to-edges = { };
      "Mod+Ctrl+Shift+F".fullscreen-window = { };
      "Mod+C".center-column = { };
      "Mod+Ctrl+C".center-visible-columns = { };
      "Mod+Minus".set-column-width._args = [ "-10%" ];
      "Mod+Equal".set-column-width._args = [ "+10%" ];
      "Mod+Shift+Minus".set-window-height._args = [ "-10%" ];
      "Mod+Shift+Equal".set-window-height._args = [ "+10%" ];
      "Mod+Ctrl+Minus".set-column-width._args = [ "-0.25%" ];
      "Mod+Ctrl+Equal".set-column-width._args = [ "+0.25%" ];
      "Mod+Ctrl+Shift+Minus".set-window-height._args = [ "-0.25%" ];
      "Mod+Ctrl+Shift+Equal".set-window-height._args = [ "+0.25%" ];
      "Mod+V".toggle-window-floating = { };
      "Mod+Shift+V".switch-focus-between-floating-and-tiling = { };
      "Mod+W".toggle-column-tabbed-display = { };

      # --- Monitor Movement ---
      "Mod+Shift+Left".focus-monitor-left = { };
      "Mod+Shift+Down".focus-monitor-down = { };
      "Mod+Shift+Up".focus-monitor-up = { };
      "Mod+Shift+Right".focus-monitor-right = { };
      "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = { };
      "Mod+Shift+Ctrl+Down".move-column-to-monitor-down = { };
      "Mod+Shift+Ctrl+Up".move-column-to-monitor-up = { };
      "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = { };
      "Mod+Shift+Ctrl+H".move-column-to-monitor-left = { };
      "Mod+Shift+Ctrl+J".move-column-to-monitor-down = { };
      "Mod+Shift+Ctrl+K".move-column-to-monitor-up = { };
      "Mod+Shift+Ctrl+L".move-column-to-monitor-right = { };

      # --- Workspaces ---
      "Mod+Page_Down".focus-workspace-down = { };
      "Mod+Page_Up".focus-workspace-up = { };
      "Mod+U".focus-workspace-down = { };
      "Mod+I".focus-workspace-up = { };
      "Mod+Ctrl+Page_Down".move-column-to-workspace-down = { };
      "Mod+Ctrl+Page_Up".move-column-to-workspace-up = { };
      "Mod+Ctrl+U".move-column-to-workspace-down = { };
      "Mod+Ctrl+I".move-column-to-workspace-up = { };
      "Mod+Shift+Page_Down".move-workspace-down = { };
      "Mod+Shift+Page_Up".move-workspace-up = { };
      "Mod+Shift+U".move-workspace-down = { };
      "Mod+Shift+I".move-workspace-up = { };
      "Mod+1".focus-workspace._args = [ 1 ];
      "Mod+2".focus-workspace._args = [ 2 ];
      "Mod+3".focus-workspace._args = [ 3 ];
      "Mod+4".focus-workspace._args = [ 4 ];
      "Mod+5".focus-workspace._args = [ 5 ];
      "Mod+6".focus-workspace._args = [ 6 ];
      "Mod+7".focus-workspace._args = [ 7 ];
      "Mod+8".focus-workspace._args = [ 8 ];
      "Mod+9".focus-workspace._args = [ 9 ];
      "Mod+Ctrl+1".move-column-to-workspace._args = [ 1 ];
      "Mod+Ctrl+2".move-column-to-workspace._args = [ 2 ];
      "Mod+Ctrl+3".move-column-to-workspace._args = [ 3 ];
      "Mod+Ctrl+4".move-column-to-workspace._args = [ 4 ];
      "Mod+Ctrl+5".move-column-to-workspace._args = [ 5 ];
      "Mod+Ctrl+6".move-column-to-workspace._args = [ 6 ];
      "Mod+Ctrl+7".move-column-to-workspace._args = [ 7 ];
      "Mod+Ctrl+8".move-column-to-workspace._args = [ 8 ];
      "Mod+Ctrl+9".move-column-to-workspace._args = [ 9 ];

      # --- Mouse Wheel & Scrolling Navigation ---
      "Mod+WheelScrollDown" = {
        _props.cooldown-ms = 150;
        focus-workspace-down = { };
      };
      "Mod+WheelScrollUp" = {
        _props.cooldown-ms = 150;
        focus-workspace-up = { };
      };
      "Mod+Ctrl+WheelScrollDown" = {
        _props.cooldown-ms = 150;
        move-column-to-workspace-down = { };
      };
      "Mod+Ctrl+WheelScrollUp" = {
        _props.cooldown-ms = 150;
        move-column-to-workspace-up = { };
      };
      "Mod+WheelScrollRight".focus-column-right = { };
      "Mod+WheelScrollLeft".focus-column-left = { };
      "Mod+Ctrl+WheelScrollRight".move-column-right = { };
      "Mod+Ctrl+WheelScrollLeft".move-column-left = { };
      "Mod+Shift+WheelScrollDown".focus-column-right = { };
      "Mod+Shift+WheelScrollUp".focus-column-left = { };
      "Mod+Ctrl+Shift+WheelScrollDown".move-column-right = { };
      "Mod+Ctrl+Shift+WheelScrollUp".move-column-left = { };

      # --- Screenshots ---
      "Mod+Shift+S".screenshot._props.show-pointer = false;
      "Ctrl+Shift+S".screenshot-screen._props.show-pointer = false;
      "Alt+Shift+S".screenshot-window._props.show-pointer = false;
    };

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
            scale = 1.5;
            mode = "3024x1964@120.000";
            position._props = {
              x = 272;
              y = 1440;
            };
          };
        }
        {
          output = {
            _args = [ "HDMI-A-1" ];
            scale = 1.5;
            mode = "3840x2160@144.000";
            position._props = {
              x = 0;
              y = 0;
            };
          };
        }
        {
          output = {
            _args = [ "DP-1" ];
            scale = 1.5;
            mode = "3840x2160@143.999";
            position._props = {
              x = 0;
              y = 0;
            };
          };
        }

        # --- Rules ---
        {
          window-rule = {
            geometry-corner-radius._args = [
              16.0
              16.0
              8.0
              8.0
            ];
            clip-to-geometry = true;
            opacity = 0.90;
            draw-border-with-background = false;
            background-effect = {
              xray = false;
              blur = true;
              noise = 0.03;
              saturation = 1.0;
            };
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
        # for games that we want 100% opacity and windowed fullscreen for
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
            ];
            open-maximized = true;
            open-focused = true;
            opacity = 1.00;
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
            match._props = {
              app-id = "^com.mitchellh.ghostty$";
              title = "^fastfetch$";
            };
            open-floating = true;
            baba-is-float = true;
            min-width = 960;
            min-height = 480;
            max-width = 960;
            max-height = 480;
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
                  title = ".* - mpv \(nix\)$";
                };
              }
              { match._props.app-id = "^org.gnome.Fractal$"; }
              { match._props.app-id = "^firefox$"; }
              { match._props.app-id = "^org.gnome.Snapshot$"; }
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
  };
}
