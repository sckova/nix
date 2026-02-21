{
  config,
  pkgs,
  ...
}:
{
  # https://github.com/sodiboo/niri-flake/blob/main/docs.md
  programs.niri = with config.scheme.withHashtag; {
    # handle package systemwide
    package = null;

    settings = {
      environment = {
        QT_QPA_PLATFORM = "wayland";
        QT_QPA_PLATFORMTHEME = "qt6ct";
        DISPLAY = ":0";
        XCURSOR_THEME = config.userOptions.cursor.name;
        XCURSOR_SIZE = toString config.userOptions.cursor.size;
      };
      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
      hotkey-overlay.skip-at-startup = true;
      prefer-no-csd = true;
      gestures.hot-corners.enable = false;
      spawn-at-startup = [ ]; # systemd is based sorry
      overview = {
        backdrop-color = base11;
        workspace-shadow.enable = false;
      };
      input = {
        focus-follows-mouse.enable = true;
        focus-follows-mouse.max-scroll-amount = "0%";
        mod-key = "Super";
        keyboard = {
          numlock = false;
          repeat-delay = 600;
          repeat-rate = 25;
        };
        mouse = {
          enable = true;
          accel-profile = "adaptive";
          natural-scroll = false;
        };
        touchpad = {
          enable = true;
          accel-profile = "adaptive";
          natural-scroll = true;
          tap = false;
          drag = false;
        };
      };
      outputs = {
        "eDP-1" = {
          scale = 1.5;
          position = {
            x = 272;
            y = 1440;
          };
        };
        "HDMI-A-1" = {
          mode = {
            width = 3840;
            height = 2160;
            refresh = 144.000;
          };
          scale = 1.5;
          position = {
            x = 0;
            y = 0;
          };
        };
        "DP-1" = {
          mode = {
            width = 3840;
            height = 2160;
            refresh = 143.999;
          };
          scale = 1.5;
          position = {
            x = 0;
            y = 0;
          };
        };
      };
      cursor = {
        hide-when-typing = false;
        # hide-after-inactive-ms = 10000;
        size = config.userOptions.cursor.size;
        theme = config.userOptions.cursor.name;
      };
      layout = {
        gaps = 4;
        # background-color = base10;
        background-color = "transparent";
        default-column-width = {
          proportion = 0.5;
        };
        preset-column-widths = [
          { proportion = 4.0 / 12.0; }
          { proportion = 6.0 / 12.0; }
          { proportion = 8.0 / 12.0; }
        ];
        border = {
          enable = true;
          width = 2;
          active.color = config.scheme.withHashtag.${config.colors.accent};
          inactive.color = base01;
          urgent.color = base12;
        };
        focus-ring = {
          enable = false;
          width = 2;
          active.color = config.scheme.withHashtag.${config.colors.accent};
          inactive.color = base01;
          urgent.color = base12;
        };
        shadow = {
          enable = true;
          spread = 10;
          offset.x = 0;
          offset.y = 0;
          softness = 30;
          color = base11 + "BF";
        };
        # blur = {
        #   enable = true;
        #   passes = 4;
        #   radius = 4;
        #   noise = 0.1;
        # };
      };
      window-rules = [
        {
          geometry-corner-radius = {
            top-left = 8.0;
            top-right = 8.0;
            bottom-left = 8.0;
            bottom-right = 8.0;
          };
          clip-to-geometry = true;
          opacity = 0.975;
        }
        {
          matches = [
            {
              app-id = "firefox$";
              title = "^Picture-in-Picture$";
            }
          ];
          open-floating = true;
          default-floating-position = {
            x = 16;
            y = 16;
            relative-to = "bottom-left";
          };
        }
        {
          matches = [
            {
              app-id = "vesktop$";
            }
            {
              app-id = "org.gnome.Nautilus$";
            }
          ];
          block-out-from = "screen-capture";
        }
        {
          matches = [
            {
              is-active = false;
            }
          ];
          opacity = 0.95;
        }
        {
          matches = [
            {
              app-id = "openmw";
              title = "OpenMW";
            }
            {
              app-id = "Minecraft";
              title = "Minecraft";
            }
          ];
          open-maximized = true;
          open-focused = true;
        }
        {
          matches = [
            {
              app-id = "mpv";
            }
          ];
          opacity = 1.0;
        }
      ];
      layer-rules = [
        {
          matches = [
            {
              namespace = "^wpaperd.*";
            }
            {
              namespace = "^awww-daemon";
            }
          ];
          place-within-backdrop = true;
        }
      ];
      binds = {
        "Mod+Shift+Slash".action.show-hotkey-overlay = { };

        "Mod+T" = {
          action.spawn = [ "kitty" ];
          hotkey-overlay.title = "Open a Terminal: kitty";
        };
        "Mod+Space" = {
          action.spawn = [ "fuzzel" ];
          hotkey-overlay.title = "Run an Application: Noctalia app launcher";
        };

        "XF86AudioRaiseVolume" = {
          action.spawn-sh = [
            "noctalia-shell ipc call volume increase"
          ];
          allow-when-locked = true;
        };
        "XF86AudioLowerVolume" = {
          action.spawn-sh = [
            "noctalia-shell ipc call volume decrease"
          ];
          allow-when-locked = true;
        };

        "Shift+XF86AudioRaiseVolume" = {
          action.spawn = [
            "wpctl"
            "set-volume"
            "@DEFAULT_AUDIO_SINK@"
            "0.01+"
          ];
          allow-when-locked = true;
        };
        "Shift+XF86AudioLowerVolume" = {
          action.spawn = [
            "wpctl"
            "set-volume"
            "@DEFAULT_AUDIO_SINK@"
            "0.01-"
          ];
          allow-when-locked = true;
        };

        "MouseForward" = {
          action.spawn-sh = [
            "noctalia-shell ipc call volume increase"
          ];
          allow-when-locked = true;
        };
        "MouseBack" = {
          action.spawn-sh = [
            "noctalia-shell ipc call volume decrease"
          ];
          allow-when-locked = true;
        };

        "Shift+MouseForward" = {
          action.spawn = [
            "wpctl"
            "set-volume"
            "@DEFAULT_AUDIO_SINK@"
            "0.01+"
          ];
          allow-when-locked = true;
        };
        "Shift+MouseBack" = {
          action.spawn = [
            "wpctl"
            "set-volume"
            "@DEFAULT_AUDIO_SINK@"
            "0.01-"
          ];
          allow-when-locked = true;
        };

        "XF86AudioMute" = {
          action.spawn-sh = [
            "noctalia-shell ipc call volume muteOutput"
          ];
          allow-when-locked = true;
        };
        "XF86AudioMicMute" = {
          action.spawn-sh = [
            "noctalia-shell ipc call volume muteInput"
          ];
          allow-when-locked = true;
        };

        "XF86MonBrightnessUp" = {
          action.spawn = [
            "noctalia-shell"
            "ipc"
            "call"
            "brightness"
            "increase"
          ];
          allow-when-locked = true;
        };

        "XF86MonBrightnessDown" = {
          action.spawn = [
            "noctalia-shell"
            "ipc"
            "call"
            "brightness"
            "decrease"
          ];
          allow-when-locked = true;
        };

        "Shift+XF86MonBrightnessUp" = {
          action.spawn = [
            "brightnessctl"
            "--class=backlight"
            "set"
            "+1%"
          ];
          allow-when-locked = true;
        };

        "Shift+XF86MonBrightnessDown" = {
          action.spawn = [
            "brightnessctl"
            "--class=backlight"
            "set"
            "1%-"
          ];
          allow-when-locked = true;
        };

        "XF86AudioPrev" = {
          action.spawn = [
            "playerctl"
            "previous"
          ];
          allow-when-locked = true;
        };

        "XF86AudioPlay" = {
          action.spawn = [
            "playerctl"
            "play-pause"
          ];
          allow-when-locked = true;
        };

        "XF86AudioNext" = {
          action.spawn = [
            "playerctl"
            "next"
          ];
          allow-when-locked = true;
        };

        "XF86Sleep" = {
          action.power-off-monitors = { };
        };

        "XF86Search" = {
          action.spawn = [
            "noctalia-shell"
            "ipc"
            "call"
            "launcher"
            "toggle"
          ];
          allow-when-locked = true;
        };

        "XF86LaunchA" = {
          action.spawn = [
            "niri"
            "msg"
            "action"
            "toggle-overview"
          ];
          allow-when-locked = true;
        };

        "Mod+O" = {
          action.toggle-overview = { };
          repeat = false;
        };

        "Mod+Q" = {
          action.close-window = { };
          repeat = false;
        };

        "Mod+Left".action.focus-column-left = { };
        "Mod+Down".action.focus-window-down = { };
        "Mod+Up".action.focus-window-up = { };
        "Mod+Right".action.focus-column-right = { };
        "Mod+H".action.focus-column-left = { };
        "Mod+J".action.focus-window-down = { };
        "Mod+K".action.focus-window-up = { };
        "Mod+L".action.focus-column-right = { };

        "Mod+Ctrl+Left".action.move-column-left = { };
        "Mod+Ctrl+Down".action.move-window-down = { };
        "Mod+Ctrl+Up".action.move-window-up = { };
        "Mod+Ctrl+Right".action.move-column-right = { };
        "Mod+Ctrl+H".action.move-column-left = { };
        "Mod+Ctrl+J".action.move-window-down = { };
        "Mod+Ctrl+K".action.move-window-up = { };
        "Mod+Ctrl+L".action.move-column-right = { };

        "Mod+Home".action.focus-column-first = { };
        "Mod+End".action.focus-column-last = { };
        "Mod+Ctrl+Home".action.move-column-to-first = { };
        "Mod+Ctrl+End".action.move-column-to-last = { };

        "Mod+Shift+Left".action.focus-monitor-left = { };
        "Mod+Shift+Down".action.focus-monitor-down = { };
        "Mod+Shift+Up".action.focus-monitor-up = { };
        "Mod+Shift+Right".action.focus-monitor-right = { };
        "Mod+Shift+H".action.focus-monitor-left = { };
        "Mod+Shift+J".action.focus-monitor-down = { };
        "Mod+Shift+K".action.focus-monitor-up = { };
        "Mod+Shift+L".action.focus-monitor-right = { };

        "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = { };
        "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = { };
        "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = { };
        "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = { };
        "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = { };
        "Mod+Shift+Ctrl+J".action.move-column-to-monitor-down = { };
        "Mod+Shift+Ctrl+K".action.move-column-to-monitor-up = { };
        "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = { };

        "Mod+Page_Down".action.focus-workspace-down = { };
        "Mod+Page_Up".action.focus-workspace-up = { };
        "Mod+U".action.focus-workspace-down = { };
        "Mod+I".action.focus-workspace-up = { };
        "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = { };
        "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = { };
        "Mod+Ctrl+U".action.move-column-to-workspace-down = { };
        "Mod+Ctrl+I".action.move-column-to-workspace-up = { };

        "Mod+Shift+Page_Down".action.move-workspace-down = { };
        "Mod+Shift+Page_Up".action.move-workspace-up = { };
        "Mod+Shift+U".action.move-workspace-down = { };
        "Mod+Shift+I".action.move-workspace-up = { };

        "Mod+WheelScrollDown" = {
          action.focus-workspace-down = { };
          cooldown-ms = 150;
        };
        "Mod+WheelScrollUp" = {
          action.focus-workspace-up = { };
          cooldown-ms = 150;
        };
        "Mod+Ctrl+WheelScrollDown" = {
          action.move-column-to-workspace-down = { };
          cooldown-ms = 150;
        };
        "Mod+Ctrl+WheelScrollUp" = {
          action.move-column-to-workspace-up = { };
          cooldown-ms = 150;
        };

        "Mod+WheelScrollRight".action.focus-column-right = { };
        "Mod+WheelScrollLeft".action.focus-column-left = { };
        "Mod+Ctrl+WheelScrollRight".action.move-column-right = { };
        "Mod+Ctrl+WheelScrollLeft".action.move-column-left = { };

        "Mod+Shift+WheelScrollDown".action.focus-column-right = { };
        "Mod+Shift+WheelScrollUp".action.focus-column-left = { };
        "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = { };
        "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = { };

        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;
        "Mod+Ctrl+1".action.move-column-to-workspace = 1;
        "Mod+Ctrl+2".action.move-column-to-workspace = 2;
        "Mod+Ctrl+3".action.move-column-to-workspace = 3;
        "Mod+Ctrl+4".action.move-column-to-workspace = 4;
        "Mod+Ctrl+5".action.move-column-to-workspace = 5;
        "Mod+Ctrl+6".action.move-column-to-workspace = 6;
        "Mod+Ctrl+7".action.move-column-to-workspace = 7;
        "Mod+Ctrl+8".action.move-column-to-workspace = 8;
        "Mod+Ctrl+9".action.move-column-to-workspace = 9;

        "Mod+BracketLeft".action.consume-or-expel-window-left = { };
        "Mod+BracketRight".action.consume-or-expel-window-right = { };

        "Mod+Comma".action.consume-window-into-column = { };
        "Mod+Period".action.expel-window-from-column = { };

        "Mod+R".action.switch-preset-column-width = { };
        "Mod+Shift+R".action.switch-preset-window-height = { };
        "Mod+Ctrl+R".action.reset-window-height = { };
        "Mod+F".action.maximize-column = { };
        "Mod+Shift+F".action.maximize-window-to-edges = { };
        "Mod+Ctrl+Shift+F".action.fullscreen-window = { };

        "Mod+C".action.center-column = { };

        "Mod+Ctrl+C".action.center-visible-columns = { };

        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";

        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";

        "Mod+Ctrl+Minus".action.set-column-width = "-0.25%";
        "Mod+Ctrl+Equal".action.set-column-width = "+0.25%";

        "Mod+Ctrl+Shift+Minus".action.set-window-height = "-0.25%";
        "Mod+Ctrl+Shift+Equal".action.set-window-height = "+0.25%";

        "Mod+V".action.toggle-window-floating = { };
        "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = { };

        "Mod+W".action.toggle-column-tabbed-display = { };

        "Print".action.screenshot = {
          show-pointer = false;
        };
        "Mod+Shift+S".action.screenshot = {
          show-pointer = false;
        };
        "Ctrl+Print".action.screenshot-screen = {
          show-pointer = false;
        };
        "Alt+Print".action.screenshot-window = {
          show-pointer = false;
        };

        "Mod+Escape" = {
          action.toggle-keyboard-shortcuts-inhibit = { };
          allow-inhibiting = false;
        };

        "Mod+Shift+E".action.quit = { };
        "Ctrl+Alt+Delete".action.quit = { };

        "Mod+Shift+P" = {
          action.power-off-monitors = { };
          hotkey-overlay.title = "Turn off the display";
        };
      };
    };
  };
}
