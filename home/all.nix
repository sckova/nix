{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    vesktop
    fish
    gh
    adwsteamgtk
    prismlauncher
    tmux
    fastfetch
    btop
    neovim
    killall
    wget
    ripgrep
    kitty
    ncdu
    fzf
    wl-clipboard
    openmw
    nixfmt-rfc-style

    kde-rounded-corners
    kdePackages.partitionmanager

    colloid-icon-theme
    (catppuccin-kde.override {
      flavour = [
        "latte"
        "mocha"
      ];
      accents = [
        "peach"
        "blue"
      ];
    })
  ];

  catppuccin = {
    enable = true;
    cursors = {
      enable = true;
      accent = "dark";
    };
    firefox = {
      force = true;
    };
  };

  programs.plasma = {
    enable = true;
    overrideConfig = true;

    session = {
      sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
    };

    workspace = {
      iconTheme = "Colloid-Dark";
      windowDecorations = {
        library = "org.kde.breeze";
        theme = "Breeze";
      };
      cursor.size = 24;
    };

    configFile = {
      kwinrc.Desktops.Number = 3;
      # kdeglobals.KDE.AutomaticLookAndFeel = true;
      kwinrc.Round-Corners.ActiveOutlinePalette = 3;
      kwinrc.Round-Corners.ActiveOutlineUseCustom = false;
      kwinrc.Round-Corners.ActiveOutlineUsePalette = true;
      kwinrc.Round-Corners.ActiveSecondOutlinePalette = 3;
      kwinrc.Round-Corners.ActiveSecondOutlineUseCustom = false;
      kwinrc.Round-Corners.ActiveSecondOutlineUsePalette = true;
      kwinrc.Round-Corners.InactiveOutlinePalette = 2;
      kwinrc.Round-Corners.InactiveOutlineUseCustom = false;
      kwinrc.Round-Corners.InactiveOutlineUsePalette = true;
      kwinrc.Round-Corners.InactiveSecondOutlinePalette = 2;
      kwinrc.Round-Corners.InactiveSecondOutlineUseCustom = false;
      kwinrc.Round-Corners.InactiveSecondOutlineUsePalette = true;
    };

    panels = [
      # Windows-like panel at the bottom
      {
        location = "bottom";
        height = 40;
        hiding = "dodgewindows";
        lengthMode = "fit";
        floating = true;
        alignment = "left";
        widgets = [
          # Or you can configure the widgets by adding the widget-specific options for it.
          # See modules/widgets for supported widgets and options for these widgets.
          # For example:
          {
            kickoff = {
              sortAlphabetically = true;
              # icon = "nix-snowflake-white";
            };
          }
          # Adding configuration to the widgets can also for example be used to
          # pin apps to the task-manager, which this example illustrates by
          # pinning dolphin and konsole to the task-manager by default with widget-specific options.
          {
            iconTasks = {
              launchers = [
                "applications:firefox.desktop"
                "applications:org.kde.dolphin.desktop"
                "applications:org.kde.konsole.desktop"
              ];
            };
          }
          # If no configuration is needed, specifying only the name of the
          # widget will add them with the default configuration.
          "org.kde.plasma.activitypager"
          "org.kde.plasma.marginsseparator"
          # If you need configuration for your widget, instead of specifying the
          # the keys and values directly using the config attribute as shown
          # above, plasma-manager also provides some higher-level interfaces for
          # configuring the widgets. See modules/widgets for supported widgets
          # and options for these widgets. The widgets below shows two examples
          # of usage, one where we add a digital clock, setting 12h time and
          # first day of the week to Sunday and another adding a systray with
          # some modifications in which entries to show.
          {
            systemTray.items = {
              # We explicitly show bluetooth and battery
              shown = [
                "org.kde.plasma.battery"
                "org.kde.plasma.bluetooth"
              ];
              # And explicitly hide networkmanagement and volume
              hidden = [
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

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
