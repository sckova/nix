{
  lib,
  pkgs,
  ...
}:
{
  colors = {
    accent = "base09";
    scheme = "catppuccin-mocha";
  };

  home.packages = with pkgs; [
    asahi-bless
    asahi-btsync
    asahi-nvram
    asahi-wifisync
  ];
}
