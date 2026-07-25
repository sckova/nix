{
  pkgs,
  inputs,
  ...
}:
{
  colors = {
    accent = "base09";
    scheme = "eldritch";
  };

  home.packages = with pkgs; [
    asahi-nvram
    asahi-bless
    asahi-btsync
    asahi-wifisync
  ];
}
