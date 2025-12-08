{ config, pkgs, ... }:

{
  catppuccin = {
    accent = "green";
    flavor = "mocha";
  };

  home.packages = with pkgs; [

    catppuccin-cursors.latteDark
    catppuccin-cursors.latteLight
    catppuccin-cursors.latteGreen
    catppuccin-cursors.mochaDark
    catppuccin-cursors.mochaLight
    catppuccin-cursors.mochaGreen

    (catppuccin-kde.override {
      flavour = [
        "latte"
        "mocha"
      ];
      accents = [
        "green"
      ];
    })

  ];

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
      colorScheme = "CatppuccinMochaGreen";
      cursor.theme = "catppuccin-mocha-green-cursors";
      splashScreen.theme = "Catpppuccin-Mocha-Green";
    };

    configFile = {
      kdeglobals.KDE = {
        DefaultDarkLookAndFeel = "Catppuccin-Mocha-Green";
        DefaultLightLookAndFeel = "Catppuccin-Latte-Green";
      };
    };

    shortcuts = {
      # # my volume down key broke as hell boy
      # kmix.decrease_volume = [
      #   "Volume Mute"
      #   "Volume Down"
      # ];
      # kmix.decrease_volume_small = [
      #   "Shift+Volume Mute"
      #   "Shift+Volume Down"
      # ];
      # kmix.increase_volume = "Volume Up";
      # kmix.increase_volume_small = "Shift+Volume Up";
      # kmix.mute = "Sleep";
      org_kde_powerdevil.Sleep = [ ];
    };

    panels = [
      # Application name, Global menu and Song information and playback controls at the top
      {
        location = "top";
        height = 37;
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
                  useAsIcon = false;
                  radius = 8;
                };
                icon = "";
              };
              playbackSource = "auto";
              musicControls.showPlaybackControls = false;
              songText = {
                displayInSeparateLines = true;
                maximumWidth = 320;
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
