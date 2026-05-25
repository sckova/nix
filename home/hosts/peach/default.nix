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
}
