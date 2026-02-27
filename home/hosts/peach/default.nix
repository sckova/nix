{
  pkgs,
  lib,
  ...
}:
{
  colors = {
    scheme = "banana-blueberry";
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
        refresh = 60.000;
      };
      position = {
        x = 272;
        y = 1440;
      };
    };

    plasma = lib.mkDefault {
      input.touchpads = [
        {
          name = "Apple MTP multi-touch";
          vendorId = "05ac";
          productId = "0352";
          disableWhileTyping = false;
          enable = true;
          tapToClick = false;
          naturalScroll = true;
          accelerationProfile = "default";
        }
      ];

      shortcuts = {
        # this is really annoying on apple laptops
        org_kde_powerdevil.Sleep = [ ];
      };
    };
  };
}
