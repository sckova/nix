{
  config,
  pkgs,
  ...
}: {
  programs.ghostwriter = {
    enable = true;
    font = {
      family = config.userOptions.fontSans.name;
      pointSize = config.userOptions.fontSans.size;
    };
  };

  programs.kate = {
    enable = true;
    editor = {
      font = {
        family = config.userOptions.fontMono.name;
        pointSize = config.userOptions.fontMono.size;
      };
    };
  };

  programs.plasma = {
    enable = true;
    overrideConfig = true;

    session = {
      sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
    };

    workspace = {
      iconTheme = config.gtk.iconTheme.name;
      windowDecorations = {
        library = "org.kde.breeze";
        theme = "Breeze";
      };
      cursor.size = 24;
      wallpaperPictureOfTheDay.provider = "bing";
      wallpaperFillMode = "preserveAspectCrop";
    };

    kscreenlocker = {
      appearance.wallpaperPictureOfTheDay.provider = "bing";
    };

    window-rules = [
      {
        description = "Global Changes";
        match = {
          window-class = {
            value = "";
            type = "substring";
          };
          window-types = ["normal"];
        };
        apply = {
          opacityactive = {
            value = 100;
            apply = "force";
          };
          opacityinactive = {
            value = 100;
            apply = "force";
          };
        };
      }
      {
        description = "OpenMW";
        match = {
          window-class = {
            value = "openmw";
            type = "substring";
          };
          window-types = ["normal"];
        };
        apply = {
          noborder = {
            value = true;
            apply = "force";
          };
          maximizehoriz = {
            value = true;
            apply = "force";
          };
          maximizevert = {
            value = true;
            apply = "force";
          };
          desktops = {
            value = "Desktop_4";
            apply = "force";
          };
        };
      }
      {
        description = "Minecraft";
        match = {
          window-class = {
            value = "Minecraft*";
            type = "substring";
          };
          window-types = ["normal"];
        };
        apply = {
          noborder = {
            value = true;
            apply = "initially";
          };
          maximizehoriz = {
            value = true;
            apply = "initially";
          };
          maximizevert = {
            value = true;
            apply = "initially";
          };
          desktops = {
            value = "Desktop_4";
            apply = "initially";
          };
        };
      }
      {
        description = "Picture-in-Picture";
        match = {
          window-class = {
            value = "";
            type = "substring";
          };
          title = {
            value = "(?i)picture[- ]in[- ]picture";
            type = "regex";
          };
        };
        apply = {
          above = {
            value = true;
            apply = "force";
          };
          desktops = {
            value = "\\0";
            apply = "force";
          };
        };
      }
      {
        description = "Steam (Distrobox)";
        match = {
          window-class = {
            value = "steamwebhelper";
            type = "substring";
          };
          window-types = ["normal"];
        };
        apply = {
          desktopfile = {
            value = "distrobox-steam";
            apply = "force";
          };
        };
      }
    ];

    kwin = {
      titlebarButtons = {
        left = [
          "on-all-desktops"
          "keep-below-windows"
          "keep-above-windows"
        ];
        right = [
          "minimize"
          "maximize"
          "close"
        ];
      };

      nightLight = {
        enable = true;
        mode = "location";
        # Atlanta
        location.latitude = "33.7501";
        location.longitude = "-84.3885";
        temperature.day = 6000;
        temperature.night = 3500;
        transitionTime = 60;
      };
      virtualDesktops = {
        names = [
          "1"
          "2"
          "3"
          "4"
        ];
        rows = 1;
      };
      effects = {
        desktopSwitching = {
          animation = "slide";
          navigationWrapping = true;
        };
        dimAdminMode.enable = true;
        # dimInactive.enable = true;
        minimization = {
          animation = "magiclamp";
          duration = 500;
        };
        shakeCursor.enable = true;
        snapHelper.enable = true;
        # translucency.enable = true;
        # windowOpenClose.animation = "fade";
        blur = {
          enable = true;
          noiseStrength = 8;
          strength = 5;
        };
      };
    };

    configFile = {
      # KDE has an automatic light-dark that CURRENTLY
      # isn't supported by plasma-manager.
      # kdeglobals.KDE.AutomaticLookAndFeel = true;
      # DefaultDarkLookAndFeel =  "Catppuccin-Flavor-Accent";
      # DefaultLightLookAndFeel = "Catppuccin-Flavor-Accent";
      kwinrc.Round-Corners.ActiveOutlinePalette = 2;
      kwinrc.Round-Corners.ActiveOutlineUseCustom = false;
      kwinrc.Round-Corners.ActiveOutlineUsePalette = true;
      kwinrc.Round-Corners.ActiveSecondOutlinePalette = 2;
      kwinrc.Round-Corners.ActiveSecondOutlineUseCustom = false;
      kwinrc.Round-Corners.ActiveSecondOutlineUsePalette = true;
      kwinrc.Round-Corners.InactiveOutlinePalette = 3;
      kwinrc.Round-Corners.InactiveOutlineUseCustom = false;
      kwinrc.Round-Corners.InactiveOutlineUsePalette = true;
      kwinrc.Round-Corners.InactiveSecondOutlinePalette = 3;
      kwinrc.Round-Corners.InactiveSecondOutlineUseCustom = false;
      kwinrc.Round-Corners.InactiveSecondOutlineUsePalette = true;
      plasmaparc.General.AudioFeedback = false;
      kdeglobals.Sounds.Enable = false;
      kwinrc.Plugins.forceblurEnabled = false;
      kwinrc.Effect-blurplus.BlurDecorations = true;
      kwinrc.Effect-blurplus.BlurMatching = false;
      kwinrc.Effect-blurplus.BlurMenus = true;
      kwinrc.Effect-blurplus.BlurNonMatching = true;
      kwinrc.Effect-blurplus.TopCornerRadius = 10;
      kwinrc.Effect-blurplus.BottomCornerRadius = 10;
      kwinrc.Effect-blurplus.NoiseStrength = 6;
      kwinrc.Effect-blurplus.RefractionStrength = 10;
      ksplashrc.KSplash.Engine = "KSplashQML";
    };

    panels = [
      # Small dock at the bottom right
      {
        location = "bottom";
        height = 40;
        hiding = "dodgewindows";
        lengthMode = "fit";
        floating = true;
        alignment = "left";
        widgets = [
          {
            kickoff = {
              sortAlphabetically = true;
              # icon = "nix-snowflake-white";
            };
          }
          {
            iconTasks = {
              launchers = [
                "applications:firefox.desktop"
                # "applications:helium.desktop"
                "applications:org.kde.dolphin.desktop"
                "applications:vesktop.desktop"
                "applications:kitty.desktop"
                "applications:org.strawberrymusicplayer.strawberry.desktop"
                "applications:writer.desktop"
              ];
            };
          }
          "org.kde.plasma.pager"
        ];
      }
    ];
  };
}
