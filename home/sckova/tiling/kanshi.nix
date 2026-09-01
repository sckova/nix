# home/sckova/tiling/kanshi.nix
{
  lib,
  hostname,
  ...
}:
{
  services.kanshi = {
    enable = true;

    settings =
      lib.optionals (hostname == "peach") [
        # just the laptop screen
        {
          profile.outputs = [
            {
              criteria = "eDP-1";
              mode = "3024x1964@120.000";
              scale = 1.5;
              status = "enable";
            }
          ];
        }
        # disable laptop screen when hdmi connected
        {
          profile.outputs = [
            {
              criteria = "HDMI-A-1";
              mode = "3840x2160@144.000";
              scale = 1.5;
              status = "enable";
            }
            {
              criteria = "eDP-1";
              status = "disable";
            }
          ];
        }
      ]
      ++ lib.optionals (hostname == "alien") [
        # just the displayport screen
        {
          profile.outputs = [
            {
              criteria = "DP-1";
              mode = "3840x2160@143.999";
              scale = 1.5;
              status = "enable";
            }
          ];
        }
      ];
  };
}
