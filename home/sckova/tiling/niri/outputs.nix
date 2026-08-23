# home/sckova/tiling/niri/outputs.nix
{
  lib,
  ...
}:
{
  home.file.".config/niri/outputs.kdl".text = lib.hm.generators.toKDL { } {
    _children = [
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
    ];
  };
}
