{
  pkgs,
  config,
  hostname,
  ...
}:
{
  systemd.user.services.noctalia = {
    Unit = {
      Description = "Noctalia Shell - Wayland desktop shell";
      Documentation = "https://docs.noctalia.dev";
      After = [ "niri.service" ];
      X-Restart-Triggers = [
        "${config.xdg.configFile."noctalia/config.toml".source}"
        "${config.xdg.configFile."noctalia/palettes/nixos.json".source}"
      ];
    };

    Service = {
      ExecStart = "${pkgs.noctalia}/bin/noctalia";
      Restart = "on-failure";
    };

    Install.WantedBy = [ "niri.service" ];
  };

  programs.noctalia = {
    enable = true;
    customPalettes.nixos =
      with config.scheme.withHashtag;
      let
        scheme = {
          mPrimary = config.scheme.withHashtag.${config.colors.accent};
          mOnPrimary = base00;
          mSecondary = base13;
          mOnSecondary = base00;
          mTertiary = base04;
          mOnTertiary = base00;
          mError = base12;
          mOnError = base00;
          mSurface = base10;
          mOnSurface = base05;
          mSurfaceVariant = base01;
          mOnSurfaceVariant = base05;
          mOutline = base02;
          mShadow = base00;
          mHover = base04;
          mOnHover = base00;
          terminal = {
            background = base00;
            foreground = base05;
            cursor = base05;
            cursorText = base00;
            selectionBg = base02;
            selectionFg = base05;
            normal = {
              black = base02;
              red = base08;
              green = base0B;
              yellow = base0A;
              blue = base0D;
              magenta = base17;
              cyan = base0C;
              white = base04;
            };
            bright = {
              black = base02;
              red = base08;
              green = base0B;
              yellow = base0A;
              blue = base0D;
              magenta = base17;
              cyan = base0C;
              white = base04;
            };
          };
        };
      in
      {
        light = scheme;
        dark = scheme;
      };
    settings = {
      bar.default = {
        start = [
          "CustomLauncher"
          "workspaces"
          "group:g2"
          "active_window"
        ];
        center = [ ];
        end = [
          "media"
          "group:g1"
          "date"
        ];
        font_family = config.fonts.sans.name;
        background_opacity = 0.9;
        contact_shadow = true;
        layer = "top";
        margin_edge = if hostname == "peach" then 0 else 8;
        margin_ends = if hostname == "peach" then 0 else 180;
        position = if hostname == "peach" then "top" else "right";
        reserve_space = true;
        radius = if hostname == "peach" then 0 else 16;
        thickness = 47;
        capsule_group = [
          {
            fill = "surface_variant";
            id = "g2";
            members = [
              "cpu"
              "ram"
              "sysmon"
            ];
            opacity = 1.0;
            padding = 10.0;
          }
          {
            fill = "surface_variant";
            id = "g1";
            members = [
              "battery"
              "brightness"
              "control-center"
            ];
            opacity = 1.0;
            padding = 10.0;
          }
        ];
      };

      brightness.enable_ddcutil = if hostname == "peach" then false else true;

      desktop_widgets.enabled = false;

      lockscreen_widgets = {
        enabled = false;
        schema_version = 2;
        widget_order = [ "lockscreen-login-box@eDP-1" ];
        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };
        widget."lockscreen-login-box@eDP-1" = {
          box_height = 70.0;
          box_width = 400.0;
          cx = 1008.0;
          cy = 1190.0;
          output = "eDP-1";
          rotation = 0.0;
          type = "login_box";
          settings = {
            background_color = "surface_variant";
            background_opacity = 0.88;
            background_radius = 12.0;
            input_opacity = 1.0;
            input_radius = 6.0;
            show_login_button = true;
          };
        };
      };

      notification.position = "bottom_right";

      osd = {
        position = "bottom_right";
        position_vertical = "bottom_right";
      };

      shell = {
        font_family = config.fonts.sans.name;
        telemetry_enabled = true;
        launch_apps_as_systemd_services = true;
      };

      theme = {
        builtin = "Catppuccin";
        community_palette = "Catppuccin Lavender";
        custom_palette = "nixos";
        source = "custom";
      };

      wallpaper = {
        directory = "/home/sckova/.local/share/wallpaper";
        enabled = false;
        default.path = "/home/sckova/.local/share/wallpaper/daily-colored.jpg";
        last.path = "/home/sckova/.local/share/wallpaper/daily-colored.jpg";
        monitors."eDP-1".path = "/home/sckova/.local/share/wallpaper/daily-colored.jpg";
      };

      widget = {
        CustomLauncher = {
          capsule = true;
          capsule_padding = 10.0;
          command = "vicinae toggle";
          glyph = "search";
          type = "custom_button";
        };
        active_window = {
          capsule = true;
          capsule_padding = 10.0;
          max_length = 600;
          show_empty_label = if hostname == "peach" then true else false;
          title_scroll = "on_hover";
        };
        battery = {
          capsule = true;
          show_label = false;
        };
        brightness = {
          capsule = true;
          show_label = false;
        };
        "control-center".capsule = true;
        cpu = {
          capsule = true;
          show_label = false;
        };
        date = {
          capsule = true;
          capsule_padding = 10.0;
          format = "{:%a %b %d %Y @ %I:%M%P}";
          vertical_format = "%H\\n%M\\n-\\n%m\\n%d\\n%y";
        };
        media = {
          capsule = true;
          capsule_padding = 10.0;
        };
        ram = {
          capsule = true;
          show_label = false;
        };
        sysmon = {
          capsule = true;
          show_label = false;
          stat = "disk_pct";
        };
        temp = {
          capsule = true;
          show_label = false;
        };
        workspaces = {
          capsule = true;
          capsule_padding = 10.0;
        };
      };
    };
  };
}
