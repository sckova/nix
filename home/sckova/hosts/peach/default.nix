{
  pkgs,
  lib,
  ...
}:
{
  colors = {
    scheme = "catppuccin-frappe";
    accent = "base09";
  };

  home.packages = with pkgs; [
    asahi-nvram
    asahi-bless
    asahi-btsync
    asahi-wifisync

    moonlight-qt
  ];

  programs = {
    noctalia-shell.settings.bar = {
      position = "top";
      density = "spacious";
    };

    niri.settings.outputs."eDP-1" = {
      scale = 1.5;
      mode = {
        width = 3024;
        height = 1964;
        refresh = 120.000;
      };
      position = {
        x = 272;
        y = 1440;
      };
    };
  };
}
