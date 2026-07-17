{
  pkgs,
  inputs,
  ...
}:
{
  colors = {
    scheme = "chalk";
    accent = "base09";
  };

  home.packages = with pkgs; [
    asahi-nvram
    asahi-bless
    asahi-btsync
    asahi-wifisync
  ];

  systemd.user.services.wluma = {
    Unit = {
      Description = "Automatic brightness adjustment based on screen contents and ALS";
      After = [ "niri.service" ];
    };
    Service.ExecStart = "${inputs.wluma.defaultPackage.${pkgs.system}}/bin/wluma";
    Install.WantedBy = [ "niri.service" ];
  };

  xdg.configFile."wluma/config.toml".source = (pkgs.formats.toml { }).generate "wluma-config" {
    als.iio = {
      path = "/sys/bus/iio/devices";
      thresholds = {
        "0" = "night";
        "20" = "dark";
        "80" = "dim";
        "250" = "normal";
        "500" = "bright";
        "800" = "outdoors";
      };
    };
    output.backlight = [
      {
        name = "eDP-1";
        path = "/sys/class/backlight/apple-panel-bl";
        capturer = "wayland";
      }
    ];
  };
}
