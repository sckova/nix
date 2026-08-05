{ lib, hostname }:

lib.optionals (hostname == "peach") [
  { debug.render-drm-device._args = [ "/dev/dri/renderD128" ]; }
]
++ [
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
]
