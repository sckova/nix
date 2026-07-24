{
  config,
  lib,
  pkgs,
  inputs,
  osConfig,
  ...
}:
{

  systemd.user.services.wluma = {
    Install.WantedBy = [ "niri.service" ];
    Service.ExecStart = "${inputs.wluma.defaultPackage.${pkgs.system}}/bin/wluma";

    Unit = {
      After = [ "niri.service" ];
      Description = "Automatic brightness adjustment based on screen contents and ALS";

      X-Restart-Triggers = [
        config.xdg.configFile."wluma/config.toml".source
      ];
    };
  };

  xdg.configFile."wluma/config.toml".source =
    let
      alien = osConfig.networking.hostName == "alien";
      peach = osConfig.networking.hostName == "peach";
    in
    (pkgs.formats.toml { }).generate "wluma-config" {
      als =
        if peach then
          {
            iio = {
              path = "/sys/bus/iio/devices";

              thresholds = {
                "0" = "night";
                "20" = "dark";
                "250" = "normal";
                "500" = "bright";
                "80" = "dim";
                "800" = "outdoors";
              };
            };
          }
        else
          {
            time.thresholds = {
              "0" = "night";
              "11" = "normal";
              "13" = "bright";
              "16" = "normal";
              "18" = "dark";
              "20" = "night";
              "7" = "dark";
              "9" = "dim";
            };
          };

      output =
        lib.optionalAttrs peach {
          backlight = [
            {
              capturer = "wayland";
              name = "eDP-1";
              path = "/sys/class/backlight/apple-panel-bl";
            }
          ];
        }
        // lib.optionalAttrs alien {
          ddcutil = [
            {
              capturer = "none";
              name = "M32UC";
            }
          ];
        };
    };
}
