{
  pkgs,
  config,
  ...
}:
{
  programs.noctalia-shell = {
    enable = true;
    colors = {
      mPrimary = pkgs.catppuccin.${config.catppuccin.flavor}.${config.catppuccin.accent};
      mOnPrimary = pkgs.catppuccin.${config.catppuccin.flavor}.crust;
      mSecondary = pkgs.catppuccin.${config.catppuccin.flavor}.subtext0;
      mOnSecondary = pkgs.catppuccin.${config.catppuccin.flavor}.crust;
      mTertiary = pkgs.catppuccin.${config.catppuccin.flavor}.teal;
      mOnTertiary = pkgs.catppuccin.${config.catppuccin.flavor}.crust;
      mError = pkgs.catppuccin.${config.catppuccin.flavor}.red;
      mOnError = pkgs.catppuccin.${config.catppuccin.flavor}.crust;
      mSurface = pkgs.catppuccin.${config.catppuccin.flavor}.mantle;
      mOnSurface = pkgs.catppuccin.${config.catppuccin.flavor}.text;
      mSurfaceVariant = pkgs.catppuccin.${config.catppuccin.flavor}.surface0;
      mOnSurfaceVariant = pkgs.catppuccin.${config.catppuccin.flavor}.lavender;
      mOutline = pkgs.catppuccin.${config.catppuccin.flavor}.surface2;
      mShadow = pkgs.catppuccin.${config.catppuccin.flavor}.crust;
      mHover = pkgs.catppuccin.${config.catppuccin.flavor}.subtext1;
      mOnHover = pkgs.catppuccin.${config.catppuccin.flavor}.crust;
    };
    settings = {
      settingsVersion = 0;
      brightness = {
        brightnessStep = 5;
        enforceMinimum = false;
        enableDdcSupport = true;
      };
      bar = {
        position = "top";
        backgroundOpacity = 1;
        monitors = [ ];
        density = "spacious";
        showCapsule = true;
        capsuleOpacity = 1;
        floating = false;
        marginVertical = 0.25;
        marginHorizontal = 0.25;
        outerCorners = false;
        exclusive = true;
        widgets = {
          left = [
            {
              icon = "rocket";
              id = "CustomButton";
              leftClickExec = "noctalia-shell ipc call launcher toggle";
            }
            {
              id = "Workspace";
            }
            {
              diskPath = "/";
              id = "SystemMonitor";
              showCpuTemp = false;
              showCpuUsage = true;
              showDiskUsage = true;
              showGpuTemp = false;
              showMemoryAsPercent = true;
              showMemoryUsage = true;
              showNetworkStats = false;
              usePrimaryColor = false;
            }
            {
              colorizeIcons = false;
              hideMode = "hidden";
              id = "ActiveWindow";
              maxWidth = 500;
              scrollingMode = "always";
              showIcon = true;
              useFixedWidth = false;
            }
          ];
          center = [
          ];
          right = [
            {
              hideMode = "hidden";
              hideWhenIdle = false;
              id = "MediaMini";
              maxWidth = 300;
              scrollingMode = "hover";
              showAlbumArt = false;
              showArtistFirst = false;
              showProgressRing = true;
              showVisualizer = false;
              useFixedWidth = false;
              visualizerType = "linear";
            }
            {
              id = "Tray";
            }
            {
              id = "NotificationHistory";
            }
            {
              id = "Battery";
            }
            {
              id = "Volume";
            }
            {
              id = "Brightness";
            }
            {
              id = "ControlCenter";
            }
            {
              formatHorizontal = "ddd MMM dd yyyy @ h:mm AP";
              formatVertical = "HH mm - dd MM";
              id = "Clock";
              useCustomFont = false;
              usePrimaryColor = false;
            }
          ];
        };
      };
      general = {
        avatarImage = "/home/${config.userOptions.username}/.face";
        dimmerOpacity = 0.6;
        showScreenCorners = false;
        forceBlackScreenCorners = false;
        scaleRatio = 1;
        radiusRatio = 1;
        iRadiusRatio = 1;
        boxRadiusRatio = 1;
        screenRadiusRatio = 1;
        animationSpeed = 1;
        animationDisabled = false;
        compactLockScreen = false;
        lockOnSuspend = true;
        showSessionButtonsOnLockScreen = true;
        showHibernateOnLockScreen = false;
        enableShadows = false;
        shadowDirection = "bottom_right";
        shadowOffsetX = 2;
        shadowOffsetY = 3;
        language = "";
        allowPanelsOnScreenWithoutBar = true;
      };
      ui = {
        fontDefault = config.userOptions.fontSans.name;
        fontFixed = config.userOptions.fontMono.name;
        fontDefaultScale = 1;
        fontFixedScale = 1;
        tooltipsEnabled = true;
        panelBackgroundOpacity = 1;
        panelsAttachedToBar = true;
        settingsPanelMode = "attached";
      };
      location = {
        name = "Atlanta, US";
        weatherEnabled = true;
        weatherShowEffects = true;
        useFahrenheit = true;
        use12hourFormat = true;
        showWeekNumberInCalendar = true;
        showCalendarEvents = true;
        showCalendarWeather = true;
        analogClockInCalendar = false;
        firstDayOfWeek = -1;
      };
      calendar = {
        cards = [
          {
            enabled = true;
            id = "calendar-header-card";
          }
          {
            enabled = true;
            id = "calendar-month-card";
          }
          {
            enabled = true;
            id = "weather-card";
          }
          {
            enabled = true;
            id = "timer-card";
          }
        ];
      };
      screenRecorder = {
        directory = "";
        frameRate = 60;
        audioCodec = "opus";
        videoCodec = "h264";
        quality = "very_high";
        colorRange = "limited";
        showCursor = true;
        audioSource = "default_output";
        videoSource = "portal";
      };
      wallpaper = {
        enabled = false;
        overviewEnabled = false;
        directory = "/home/sckova/.local/share/wallpaper";
        monitorDirectories = [ ];
        enableMultiMonitorDirectories = false;
        recursiveSearch = false;
        setWallpaperOnAllMonitors = true;
        fillColor = "${pkgs.catppuccin.${config.catppuccin.flavor}.base}";
        fillMode = "crop";
        hideWallpaperFilenames = true;
        panelPosition = "follow_bar";
        randomEnabled = false;
        randomIntervalSec = 300;
        transitionDuration = 1500;
        transitionEdgeSmoothness = 0.05;
        transitionType = "random";
        useWallhaven = false;
      };
      appLauncher = {
        enableClipboardHistory = true;
        enableClipPreview = true;
        position = "top_left";
        pinnedExecs = [ ];
        useApp2Unit = false;
        sortByMostUsed = true;
        terminalCommand = "kitty -e";
        customLaunchPrefixEnabled = false;
        customLaunchPrefix = "";
        viewMode = "list";
        showCategories = true;
      };
      controlCenter = {
        position = "close_to_bar_button";
        shortcuts = {
          left = [
            {
              id = "Network";
            }
            {
              id = "Bluetooth";
            }
            {
              id = "ScreenRecorder";
            }
            {
              id = "WallpaperSelector";
            }
          ];
          right = [
            {
              id = "Notifications";
            }
            {
              id = "PowerProfile";
            }
            {
              id = "KeepAwake";
            }
            {
              id = "NightLight";
            }
          ];
        };
        cards = [
          {
            enabled = true;
            id = "profile-card";
          }
          {
            enabled = true;
            id = "shortcuts-card";
          }
          {
            enabled = true;
            id = "audio-card";
          }
          {
            enabled = true;
            id = "media-sysmon-card";
          }
        ];
      };
      systemMonitor = {
        cpuWarningThreshold = 80;
        cpuCriticalThreshold = 90;
        tempWarningThreshold = 80;
        tempCriticalThreshold = 90;
        memWarningThreshold = 80;
        memCriticalThreshold = 90;
        diskWarningThreshold = 80;
        diskCriticalThreshold = 90;
        cpuPollingInterval = 3000;
        tempPollingInterval = 3000;
        memPollingInterval = 3000;
        diskPollingInterval = 3000;
        networkPollingInterval = 3000;
        useCustomColors = false;
        warningColor = "";
        criticalColor = "";
      };
      dock = {
        enabled = false;
        displayMode = "auto_hide";
        backgroundOpacity = 1;
        floatingRatio = 1;
        size = 1;
        onlySameOutput = true;
        monitors = [ ];
        pinnedApps = [ ];
        colorizeIcons = false;
        pinnedStatic = false;
        inactiveIndicators = false;
        deadOpacity = 0.6;
      };
      network = {
        wifiEnabled = true;
      };
      sessionMenu = {
        enableCountdown = true;
        countdownDuration = 5000;
        position = "center";
        showHeader = true;
        powerOptions = [
          {
            action = "lock";
            enabled = true;
          }
          {
            action = "suspend";
            enabled = true;
          }
          {
            action = "hibernate";
            enabled = true;
          }
          {
            action = "reboot";
            enabled = true;
          }
          {
            action = "logout";
            enabled = true;
          }
          {
            action = "shutdown";
            enabled = true;
          }
        ];
      };
      notifications = {
        enabled = true;
        monitors = [ ];
        location = "top_right";
        overlayLayer = true;
        backgroundOpacity = 1;
        respectExpireTimeout = false;
        lowUrgencyDuration = 3;
        normalUrgencyDuration = 8;
        criticalUrgencyDuration = 15;
        enableKeyboardLayoutToast = true;
        sounds = {
          enabled = true;
          volume = 0.5;
          separateSounds = false;
        };
      };
      osd = {
        enabled = true;
        location = "top_right";
        autoHideMs = 2000;
        overlayLayer = true;
        backgroundOpacity = 1;
        enabledTypes = [
          0
          1
          2
        ];
        monitors = [ ];
      };
      audio = {
        volumeStep = 5;
        volumeOverdrive = false;
        cavaFrameRate = 30;
        visualizerType = "linear";
        visualizerQuality = "high";
        mprisBlacklist = [ ];
        preferredPlayer = "";
        externalMixer = "pwvucontrol || pavucontrol";
      };
      colorSchemes = {
        useWallpaperColors = false;
        darkMode = true;
        schedulingMode = "off";
        manualSunrise = "06:30";
        manualSunset = "18:30";
        matugenSchemeType = "scheme-fruit-salad";
        generateTemplatesForPredefined = true;
      };
      templates = {
        gtk = false;
        qt = false;
        kcolorscheme = false;
        alacritty = false;
        kitty = false;
        ghostty = false;
        foot = false;
        wezterm = false;
        fuzzel = false;
        discord = false;
        pywalfox = false;
        vicinae = false;
        walker = false;
        code = false;
        spicetify = false;
        telegram = false;
        cava = false;
        yazi = false;
        emacs = false;
        niri = false;
        enableUserTemplates = false;
      };
      nightLight = {
        enabled = true;
        forced = true;
        autoSchedule = true;
        nightTemp = "4000";
        dayTemp = "6500";
        manualSunrise = "06:30";
        manualSunset = "18:30";
      };
      hooks = {
        enabled = false;
        wallpaperChange = "";
        darkModeChange = "";
      };
    };
  };

  systemd.user.services.noctalia-shell = {
    Unit = {
      After = [ "niri.service" ];
      PartOf = [ "niri.service" ];
      Description = "Noctalia Shell - Wayland desktop shell";
      Documentation = "https://docs.noctalia.dev/docs";
    };

    Service = {
      ExecStart = "${pkgs.noctalia-shell}/bin/noctalia-shell";
      Restart = "on-failure";
      Environment = [
        "LOCALE_ARCHIVE=${pkgs.glibcLocales}/lib/locale"
        "TZDIR=${pkgs.tzdata}/share/zoneinfo"
        "NOCTALIA_SETTINGS_FALLBACK=%h/.config/noctalia/gui-settings.json"
        "QT_QPA_PLATFORM=wayland"
        "QT_QPA_PLATFORMTHEME=qt6ct"
      ];
    };

    Install = {
      WantedBy = [ "niri.service" ];
    };
  };
}
