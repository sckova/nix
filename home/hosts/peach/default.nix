{
  lib,
  pkgs,
  ...
}:
{
  colors = {
    accent = "base09";
    scheme = "tokyo-night-moon";
  };

  home.packages = with pkgs; [
    asahi-nvram
    asahi-bless
    asahi-btsync
    asahi-wifisync
  ];
}
