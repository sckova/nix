{
  pkgs,
  inputs,
  ...
}:
{
  colors = {
    accent = "base09";
    scheme = "chalk";
  };

  home.packages = with pkgs; [
    asahi-nvram
    asahi-bless
    asahi-btsync
    asahi-wifisync
  ];

  systemd.user.services.wluma = {
    Install.WantedBy = [ "niri.service" ];
    Service.ExecStart = "${inputs.wluma.defaultPackage.${pkgs.system}}/bin/wluma";

    Unit = {
      After = [ "niri.service" ];
      Description = "Automatic brightness adjustment based on screen contents and ALS";
    };
  };

  xdg.configFile."wluma/config.toml".source = (pkgs.formats.toml { }).generate "wluma-config" {
    als.iio = {
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

    output.backlight = [
      {
        capturer = "wayland";
        name = "eDP-1";
        path = "/sys/class/backlight/apple-panel-bl";
      }
    ];
  };
}
