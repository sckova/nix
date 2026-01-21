{
  config,
  pkgs,
  pkgs-unstable,
  spicetify-nix,
  ...
}:
{
  colors = {
    scheme = "catppuccin-mocha";
    accent = "base0D";
  };

  home.packages = [
    # steam gtk theming
    pkgs.adwsteamgtk

    pkgs-unstable.ckan
    pkgs.daggerfall-unity
  ];

  programs.spicetify =
    let
      spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      enable = true;

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle # shuffle+ (special characters are sanitized out of extension names)
      ];
      enabledCustomApps = with spicePkgs.apps; [
        newReleases
        ncsVisualizer
      ];
      enabledSnippets = with spicePkgs.snippets; [
        rotatingCoverart
        pointer
      ];

      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
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
