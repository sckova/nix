# home/hosts/peach/default.nix
{
  lib,
  pkgs,
  ...
}:
{
  colors = {
    accent = "base09";
    schemeName = "catppuccin-mocha";
  };

  home.packages = with pkgs; [
    asahi-bless
    asahi-btsync
    asahi-nvram
    asahi-wifisync
  ];
}
