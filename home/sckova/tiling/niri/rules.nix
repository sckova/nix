# home/sckova/tiling/niri/rules.nix
{
  lib,
  ...
}:
{
  home.file.".config/niri/rules.kdl".text =
    let
      blurConfig = {
        blur = true;
        noise = 0.03;
        saturation = 1.0;
        xray = true;
      };
      cornerRadius = 8.0;
    in
    lib.hm.generators.toKDL { } {
      _children = [
        {
          window-rule = {
            background-effect = blurConfig;
            clip-to-geometry = true;
            draw-border-with-background = false;

            geometry-corner-radius._args = [
              cornerRadius
              cornerRadius
              (cornerRadius / 2)
              (cornerRadius / 2)
            ];

            opacity = 1.0;

            popups = {
              background-effect = blurConfig;

              geometry-corner-radius._args = [
                cornerRadius
                cornerRadius
                cornerRadius
                cornerRadius
              ];
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
        # games: full opacity, windowed fullscreen
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

            opacity = 1.00;
            open-focused = true;
            open-maximized = true;
          };
        }
        # Ghostty fastfetch window
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
        # apps that handle their own background opacity
        {
          window-rule = {
            _children = [
              { match._props.app-id = "^firefox$"; }
              { match._props.app-id = "^vicinae$"; }
              { match._props.app-id = "^com.mitchellh.ghostty$"; }
              { match._props.app-id = "^org.gnome.Calendar$"; }
              { match._props.app-id = "^org.gnome.FileRoller$"; }
              { match._props.app-id = "^org.gnome.Fractal$"; }
              { match._props.app-id = "^org.gnome.Maps$"; }
              { match._props.app-id = "^org.gnome.Nautilus$"; }
              { match._props.app-id = "^org.gnome.font-viewer$"; }
              { match._props.app-id = "^org.gnome.Papers$"; }
              { match._props.app-id = "^org.gnome.Snapshot$"; }
              { match._props.app-id = "^org.gnome.Decibels$"; }
              { match._props.app-id = "^com.github.neithern.g4music$"; }
              {
                match._props = {
                  app-id = "^mpv$";
                  title = ".* - mpv \\\\(nix\\\\)$";
                };
              }
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
              {
                match._props = {
                  app-id = "^helium$";
                  title = ".* - Helium$";
                };
              }
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
