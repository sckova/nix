{
  pkgs,
  config,
  lib,
  ...
}:
{
  colors = {
    scheme = "catppuccin-mocha";
    accent = "base09";
  };

  home.packages = with pkgs; [
    asahi-nvram
    asahi-bless
    asahi-btsync
    asahi-wifisync

    moonlight-qt
  ];

  # https://github.com/YaLTeR/niri/issues/2330#issuecomment-3256864777
  programs.niri.settings.debug = {
    render-drm-device = "/dev/dri/card2";
  };

  programs.noctalia-shell.settings.bar = {
    position = "top";
    density = "spacious";
  };

  programs.plasma = lib.mkDefault {
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
}
