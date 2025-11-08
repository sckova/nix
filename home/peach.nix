{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    asahi-nvram
    asahi-bless
    asahi-btsync
    asahi-wifisync
  ];

  catppuccin = {
    accent = "peach";
    flavor = "mocha";
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

    workspace = {
      colorScheme = "CatppuccinMochaPeach";
      cursor.theme = "catppuccin-mocha-peach-cursors";
      splashScreen.theme = "Catpppuccin-Mocha-Peach";
    };

    configFile = {
      kdeglobals.KDE = {
        DefaultDarkLookAndFeel = "Catppuccin-Mocha-Peach";
        DefaultLightLookAndFeel = "Catppuccin-Latte-Peach";
      };
    };

    shortcuts = {
      # my volume down key broke as hell boy
      kmix.decrease_volume = "Volume Mute";
      kmix.decrease_volume_small = "Shift+Volume Mute";
      kmix.increase_volume = "Volume Up";
      kmix.increase_volume_small = "Shift+Volume Up";
      kmix.mute = "Sleep";
      org_kde_powerdevil.Sleep = [ ];
    };

    panels = [
      # Application name, Global menu and Song information and playback controls at the top
      {
        location = "top";
        height = 37;
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
                  useAsIcon = false;
                  radius = 8;
                };
                icon = "view-media-track";
              };
              playbackSource = "auto";
              musicControls.showPlaybackControls = true;
              songText = {
                displayInSeparateLines = true;
                maximumWidth = 300;
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
