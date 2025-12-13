{ config, pkgs, ... }:

{
  catppuccin = {
    accent = "blue";
    flavor = "mocha";
  };

  home.packages = with pkgs; [

    # catppuccin-cursors.latteDark
    # catppuccin-cursors.latteLight
    # catppuccin-cursors.latteBlue
    # catppuccin-cursors.mochaDark
    # catppuccin-cursors.mochaLight
    catppuccin-cursors.mochaBlue

    (catppuccin-kde.override {
      flavour = [
        "latte"
        "mocha"
      ];
      accents = [
        "blue"
      ];
    })

    # steam gtk theming
    adwsteamgtk

    daggerfall-unity
    shipwright
    _2ship2harkinian
  ];

  home.sessionVariables = {
    XCURSOR_THEME = "catppuccin-mocha-blue-cursors";
  };

  gtk.cursorTheme = {
    name = "catppuccin-mocha-blue-cursors";
    package = pkgs.catppuccin-cursors.mochaBlue;
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
