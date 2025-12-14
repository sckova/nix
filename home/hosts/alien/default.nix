{ config, pkgs, ... }:

{
  catppuccin = {
    accent = "blue";
    flavor = "mocha";
  };

  home.packages = with pkgs; [

    # steam gtk theming
    adwsteamgtk

    daggerfall-unity
    shipwright
    _2ship2harkinian
  ];

  programs.noctalia-shell.settings.brightness = {
    brightnessStep = 5;
    enforceMinimum = false;
    enableDdcSupport = true;
  };

  programs.plasma = {
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
