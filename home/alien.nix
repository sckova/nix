{ config, pkgs, ... }:

{
  catppuccin = {
    accent = "blue";
    flavor = "mocha";
  };

  programs.plasma = {
    workspace = {
      colorScheme = "CatppuccinMochaBlue";
      cursor.theme = "catppuccin-mocha-blue-cursors";
      splashScreen.theme = "Catpppuccin-Mocha-Blue";
    };

    configFile = {
      kdeglobals.KDE = {
        DefaultDarkLookAndFeel = "Catppuccin-Mocha-Blue";
        DefaultLightLookAndFeel = "Catppuccin-Latte-Blue";
      };
    };
    panels = [
      # Alternative global menu to fit the modified taskbar
      {
        location = "bottom";
        height = 40;
        hiding = "dodgewindows";
        lengthMode = "fit";
        floating = true;
        alignment = "right";
        widgets = [
          "org.kde.plasma.appmenu"
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
                maximumWidth = 640;
                scrolling = {
                  behavior = "alwaysScroll";
                  speed = 3;
                };
              };
            };
          }
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.activitypager"
          "org.kde.plasma.marginsseparator"
          {
            systemTray.items = {
              shown = [
                "org.kde.plasma.battery"
                "org.kde.plasma.bluetooth"
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.volume"
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
