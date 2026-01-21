{ pkgs, ... }:
{
  catppuccin = {
    accent = "peach";
    flavor = "mocha";
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

  programs.plasma = {
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

    panels = [
      # Application name, Global menu and Song information and playback controls at the top
      {
        location = "top";
        height = 42; # 37 for 200%, 42 for 175%
        floating = false;
        widgets = [
          {
            applicationTitleBar = {
              behavior = {
                activeTaskSource = "activeTask";
              };
              layout = {
                elements = [ "windowTitle" ];
                horizontalAlignment = "right";
                showDisabledElements = "deactivated";
                verticalAlignment = "center";
              };
              overrideForMaximized.enable = false;
              windowTitle = {
                font = {
                  bold = false;
                  fit = "fixedSize";
                  size = 10;
                };
                hideEmptyTitle = true;
                margins = {
                  bottom = 5;
                  left = 10;
                  right = 0;
                  top = 5;
                };
                source = "appName";
              };
            };
          }
          "org.kde.plasma.appmenu"
          "org.kde.plasma.panelspacer"
          {
            plasmusicToolbar = {
              panelIcon = {
                albumCover = {
                  useAsIcon = true;
                  radius = 2;
                };
              };
              playbackSource = "auto";
              musicControls.showPlaybackControls = false;
              songText = {
                displayInSeparateLines = true;
                maximumWidth = 250;
                scrolling = {
                  behavior = "alwaysScroll";
                  speed = 3;
                };
              };
            };
          }
          "org.kde.plasma.marginsseparator"
          {
            systemTray.items = {
              shown = [
                "org.kde.plasma.battery"
                "org.kde.plasma.bluetooth"
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.brightness"
                "org.kde.plasma.volume"
              ];
              hidden = [
                "org.kde.plasma.clipboard"
                "org.kde.plasma.manage-inputmethod"
                "org.kde.plasma.cameraindicator"
                "org.kde.plasma.keyboardlayout"
                "org.kde.plasma.devicenotifier"
                "org.kde.plasma.notifications"
                "org.kde.plasma.weather"
                "org.kde.plasma.printmanager"
                "org.kde.plasma.keyboardindicator"
                "org.kde.plasma.mediacontroller"
              ];
            };
          }
          {
            digitalClock = {
              calendar.firstDayOfWeek = "sunday";
              time.format = "12h";
            };
          }
        ];
      }
    ];
  };
}
