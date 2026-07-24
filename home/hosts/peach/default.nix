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
}
