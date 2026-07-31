{
  pkgs,
  inputs,
  ...
}:
{
  colors = {
    accent = "base09";
    scheme = "catppuccin-mocha";
  };

  home.packages = with pkgs; [
    asahi-nvram
    asahi-bless
    asahi-btsync
    asahi-wifisync
  ];
}
