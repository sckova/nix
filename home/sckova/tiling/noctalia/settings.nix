# home/sckova/tiling/noctalia/settings.nix
{ config, hostname, ... }: {
  programs.noctalia.settings = {
    bar.default = {
      background_opacity = 0.9;

      capsule_group = [
        {
          fill = "surface_variant";
          id = "g1";

          members = [
            "cpu"
            "ram"
            "storage"
          ];

          opacity = 1.0;
          padding = 10.0;
        }
        {
          fill = "surface_variant";
          id = "g2";
          members = [ "tray" ];
          opacity = 1.0;
          padding = 10.0;
        }
        {
          fill = "surface_variant";
          id = "g3";

          members = [
            "microphone"
            "speaker"
            "battery"
            "brightness"
            "network"
          ];

          opacity = 1.0;
          padding = 10.0;
        }
      ];

      capsule_thickness = 0.75;
      center = [ "weather" ];
      contact_shadow = false;

      end = [
        "media"
        "group:g2"
        "group:g3"
        "date"
      ];

      font_family = config.fonts.sans.name;
      layer = "top";
      margin_edge = 0;
      margin_ends = 0;
      position = "top";
      radius = 0;
      reserve_space = true;
      shadow = false;

      start = [
        "workspaces"
        "group:g1"
        "active_window"
      ];

      thickness = 47;
    };

    brightness.enable_ddcutil = false;
    desktop_widgets.enabled = false;
    location.address = "Atlanta, US";

    lockscreen_widgets = {
      enabled = false;

      grid = {
        cell_size = 16;
        major_interval = 4;
        visible = true;
      };

      schema_version = 2;

      widget."lockscreen-login-box@eDP-1" = {
        box_height = 70.0;
        box_width = 400.0;
        cx = 1008.0;
        cy = 1190.0;
        output = "eDP-1";
        rotation = 0.0;

        settings = {
          background_color = "surface_variant";
          background_opacity = 0.88;
          background_radius = 12.0;
          input_opacity = 1.0;
          input_radius = 6.0;
          show_login_button = true;
        };

        type = "login_box";
      };

      widget_order = [ "lockscreen-login-box@eDP-1" ];
    };

    nightlight = {
      enabled = true;
      temperature_day = 6500;
      temperature_night = 3000;
    };

    notification.position = "bottom_right";

    osd = {
      background_opacity = 0.90;
      kinds.brightness = false;
      position = "top_right";
      position_vertical = "top_right";
    };

    shell = {
      font_family = config.fonts.sans.name;
      launch_apps_as_systemd_services = true;
      telemetry_enabled = true;
    };

    theme = {
      builtin = "Catppuccin";
      community_palette = "Catppuccin Lavender";
      custom_palette = "nixos";
      source = "custom";
    };

    wallpaper = {
      default.path = "/home/sckova/.local/share/wallpaper/daily-colored.jpg";
      directory = "/home/sckova/.local/share/wallpaper";
      enabled = false;
      last.path = "/home/sckova/.local/share/wallpaper/daily-colored.jpg";
      monitors."eDP-1".path = "/home/sckova/.local/share/wallpaper/daily-colored.jpg";
    };

    weather.unit = "imperial";

    widget = {
      CustomLauncher = {
        actions.left = "exec vicinae toggle";
        capsule = true;
        capsule_padding = 10.0;
        glyph = "search";
        type = "custom_button";
      };

      active_window = {
        capsule = true;
        capsule_padding = 10.0;
        max_length = 600;
        show_empty_label = true;
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

      cpu = {
        capsule = true;
        show_value = false;
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
        max_length = 450;
        title_scroll = "always";
      };

      microphone = {
        device = "input";
        show_label = false;
        type = "volume";
      };

      network.show_label = false;

      ram = {
        capsule = true;
        show_value = false;
      };

      speaker = {
        show_label = false;
        type = "volume";
      };

      storage = {
        show_value = false;
        stat = "disk_used_pct";
        type = "sysmon";
      };

      volume.show_label = false;

      weather = {
        capsule = true;
        capsule_padding = 10;
      };

      workspaces = {
        capsule = true;
        capsule_padding = 10.0;
      };
    };
  };
}
