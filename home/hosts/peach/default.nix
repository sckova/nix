{
  pkgs,
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
}
