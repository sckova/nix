# home/sckova/tiling/niri/settings.nix
{
  config,
  lib,
  hostname,
  ...
}:
{
  home.file.".config/niri/settings.kdl".text = lib.hm.generators.toKDL { } (
    {
      environment.DISPLAY = ":0";
      gestures.hot-corners.off = { };
      hotkey-overlay.skip-at-startup = { };

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
          on = { };
          urgent-color = withHashtag.base12;
          width = 2;
        };

        default-column-width.proportion = 0.499999;
        focus-ring.off = { };
        gaps = 6;
        insert-hint.color = config.scheme.withHashtag.${config.colors.accent} + "80";

        preset-column-widths._children = [
          { proportion._args = [ 0.333333 ]; }
          { proportion._args = [ 0.499999 ]; }
          { proportion._args = [ 0.666666 ]; }
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

      overview = {
        backdrop-color = "#000000";
        workspace-shadow.off = { };
        zoom = 0.75;
      };

      prefer-no-csd = { };
      screenshot-path = "~/Pictures/Screenshots/%a %b %e %Y @%l:%M %p.png";
    }
    // lib.optionalAttrs (hostname == "peach") {
      debug.render-drm-device._args = [ "/dev/dri/renderD128" ];
    }
  );
}
