{
  config,
  ...
}:
{
  wayland.windowManager.hyprland = with config.scheme; {
    enable = true;

    settings = {
      # -----------------------------------------------------
      # Environment Variables & Debug
      # -----------------------------------------------------
      env = [
        "QT_QPA_PLATFORM,wayland"
        "QT_QPA_PLATFORMTHEME,qt6ct"
        "DISPLAY,:0"
        "XCURSOR_THEME,${config.userOptions.cursor.name}"
        "XCURSOR_SIZE,${toString config.userOptions.cursor.size}"
      ];

      debug = {
        disable_scale_checks = true;
      };

      # -----------------------------------------------------
      # Monitors (Outputs)
      # -----------------------------------------------------
      monitor = [
        "eDP-1, 3024x1964@120.000, 0x0, 1.5"
        "HDMI-A-1, 3840x2160@144.000, 0x0, 1.5"
        "DP-1, 3840x2160@143.999, 0x0, 1.5"
      ];

      # -----------------------------------------------------
      # Autostart
      # -----------------------------------------------------
      exec-once = [ ]; # systemd is based sorry

      # -----------------------------------------------------
      # Input
      # -----------------------------------------------------
      input = {
        kb_layout = "us";
        numlock_by_default = false;
        repeat_delay = 600;
        repeat_rate = 25;

        follow_mouse = 1;

        touchpad = {
          natural_scroll = true;
          tap-to-click = false;
          drag_lock = false;
        };
      };

      device = [
        {
          name = "epic-mouse-v1";
          accel_profile = "adaptive";
          natural_scroll = false;
        }
      ];

      # -----------------------------------------------------
      # General & Layout
      # -----------------------------------------------------
      general = {
        gaps_in = 2;
        gaps_out = 4;
        border_size = 2;

        "col.active_border" = "rgba(${config.scheme.${config.colors.accent}}E6)";
        "col.inactive_border" = "rgba(${base01}E6)";

        layout = "dwindle";
      };

      scrolling = {
        column_width = 0.5;
        follow_focus = true;
        explicit_column_widths = "0.333,0.5,0.667";
        direction = "right";
      };

      # -----------------------------------------------------
      # Decoration (0.54 Syntax)
      # -----------------------------------------------------
      decoration = {
        rounding = 8;

        active_opacity = 0.90;
        inactive_opacity = 0.90;
        fullscreen_opacity = 1.0;

        blur = {
          enabled = true;
          size = 3;
          passes = 2;
          noise = 0.05;
          contrast = 1.0;
        };

        # Shadows now live in their own dedicated block
        shadow = {
          enabled = true;
          range = 10;
          render_power = 3;
          color = "rgba(${base11}BF)";
        };
      };

      # -----------------------------------------------------
      # Misc Settings
      # -----------------------------------------------------
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      # -----------------------------------------------------
      # Window Rules (0.54 Block Syntax)
      # -----------------------------------------------------
      windowrule = [
        {
          name = "games-openmw";
          "match:class" = "^(openmw)$";
          opacity = "1.0 1.0";
          maximize = "on";
        }
        {
          name = "games-minecraft";
          "match:class" = "^(Minecraft)$";
          opacity = "1.0 1.0";
          maximize = "on";
        }
        {
          name = "media-mpv";
          "match:class" = "^(mpv)$";
          opacity = "1.0 1.0";
        }
        {
          name = "media-pip";
          "match:class" = "^(firefox)$";
          "match:title" = "^(Picture-in-Picture)$";
          opacity = "1.0 1.0";
          float = "on";
        }
        {
          name = "terminal-fastfetch";
          "match:class" = "^(kitty)$";
          "match:title" = "^(fastfetch)$";
          float = "on";
          size = "960 480";
          center = "on";
        }
      ];

      # -----------------------------------------------------
      # Layer Rules (0.54 Block Syntax)
      # -----------------------------------------------------
      layerrule = [
        {
          name = "bar-blur";
          "match:namespace" = "^(noctalia-bar-content-.*)$";
          blur = "on";
          ignore_alpha = "0";
        }
        {
          name = "launcher-blur";
          "match:namespace" = "^(launcher)$";
          blur = "on";
          ignore_alpha = "0";
        }
      ];

      # -----------------------------------------------------
      # Keybindings
      # -----------------------------------------------------
      "$mod" = "SUPER";

      bind = [
        "$mod, T, exec, kitty"
        "$mod SHIFT, T, exec, kitty --title fastfetch sh -c 'fastfetch; sleep 10'"
        "$mod, Space, exec, fuzzel"
        ", XF86Search, exec, fuzzel"

        "$mod, M, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"

        "$mod, Q, killactive,"
        "$mod SHIFT, E, exit,"
        "CTRL ALT, Delete, exit,"
        "$mod, V, togglefloating,"
        "$mod SHIFT, F, fullscreen, 1"
        "$mod CTRL SHIFT, F, fullscreen, 0"
        "$mod, W, togglegroup,"

        "$mod SHIFT, left, focusmonitor, l"
        "$mod SHIFT, down, focusmonitor, d"
        "$mod SHIFT, up, focusmonitor, u"
        "$mod SHIFT, right, focusmonitor, r"
        "$mod SHIFT, H, focusmonitor, l"
        "$mod SHIFT, J, focusmonitor, d"
        "$mod SHIFT, K, focusmonitor, u"
        "$mod SHIFT, L, focusmonitor, r"

        "$mod SHIFT CTRL, left, movewindow, mon:l"
        "$mod SHIFT CTRL, down, movewindow, mon:d"
        "$mod SHIFT CTRL, up, movewindow, mon:u"
        "$mod SHIFT CTRL, right, movewindow, mon:r"

        "$mod, Page_Down, workspace, e+1"
        "$mod, Page_Up, workspace, e-1"
        "$mod, U, workspace, e+1"
        "$mod, I, workspace, e-1"
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        "$mod CTRL, Page_Down, movetoworkspace, e+1"
        "$mod CTRL, Page_Up, movetoworkspace, e-1"
        "$mod CTRL, U, movetoworkspace, e+1"
        "$mod CTRL, I, movetoworkspace, e-1"

        "$mod SHIFT, S, exec, grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +'%%a %%b %%e %%Y @%%l:%%M %%p').png"
        "CTRL SHIFT, S, exec, grim ~/Pictures/Screenshots/$(date +'%%a %%b %%e %%Y @%%l:%%M %%p').png"

        "$mod SHIFT, P, dpms, off"
        ", XF86Sleep, dpms, off"
      ]
      ++ (builtins.concatLists (
        builtins.attrValues (
          builtins.mapAttrs
            (key: dir: [
              "$mod, ${key}, movefocus, ${dir}"
              "$mod CTRL, ${key}, movewindow, ${dir}"
            ])
            {
              left = "l";
              right = "r";
              up = "u";
              down = "d";
              H = "l";
              L = "r";
              K = "u";
              J = "d";
            }
        )
      ))
      ++ (builtins.concatLists (
        builtins.genList (
          x:
          let
            ws =
              let
                c = (x + 1) / 10;
              in
              builtins.toString (x + 1 - (c * 10));
          in
          [
            "$mod, ${ws}, workspace, ${ws}"
            "$mod CTRL, ${ws}, movetoworkspace, ${ws}"
          ]
        ) 9
      ));

      binde = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-"
        "SHIFT, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.01+"
        "SHIFT, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.01-"

        ", MouseForward, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+"
        ", MouseBack, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-"
        "SHIFT, MouseForward, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.01+"
        "SHIFT, MouseBack, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.01-"

        ", XF86MonBrightnessUp, exec, noctalia-shell ipc call brightness increase"
        ", XF86MonBrightnessDown, exec, noctalia-shell ipc call brightness decrease"
        "SHIFT, XF86MonBrightnessUp, exec, brightnessctl --class=backlight set +1%"
        "SHIFT, XF86MonBrightnessDown, exec, brightnessctl --class=backlight set 1%-"

        "$mod, equal, resizeactive, 40 0"
        "$mod, minus, resizeactive, -40 0"
        "$mod SHIFT, equal, resizeactive, 0 40"
        "$mod SHIFT, minus, resizeactive, 0 -40"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };
}
