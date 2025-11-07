{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    vesktop
    gh
    adwsteamgtk
    prismlauncher
    tmux
    fastfetch
    btop
    # neovim
    killall
    wget
    ripgrep
    ncdu
    fzf
    wl-clipboard
    openmw
    nixfmt-rfc-style
    rclone

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

  programs.kitty = {
    enable = true;
    enableGitIntegration = true;
    themeFile = "Catppuccin-Mocha";
    font = {
      name = "Noto Sans Mono";
      size = 10;
    };
    shellIntegration.enableFishIntegration = true;
    extraConfig = "\nwheel_scroll_multiplier 5.0";
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
  };

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    waylandSupport = true;
    viAlias = true;
    vimAlias = true;
    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };
    opts = {
      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      number = true;
    };
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
      };
    };
    keymaps = [
      # --- Normal mode mappings ---
      {
        mode = "n";
        key = "<C-c>";
        action = "\"+y";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<C-p>";
        action = "\"+p";
        options = {
          noremap = true;
          silent = true;
        };
      }

      # --- Visual mode mappings ---
      {
        mode = "v";
        key = "<C-c>";
        action = "\"+y";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "v";
        key = "<C-p>";
        action = "\"+p";
        options = {
          noremap = true;
          silent = true;
        };
      }
    ];
    plugins = {
      nvim-autopairs = {
        enable = true;
        # autoLoad = true;
      };
      cmp = {
        autoEnableSources = true;
        enable = true;
        # autoLoad = true;
      };
      copilot-lua = {
        enable = true;
        # autoLoad = true;
      };
      conform-nvim = {
        enable = true;
        # autoLoad = true;
        settings = {
          formatters_by_ft = {
            lua = [ "stylua" ];
            python = [
              "isort"
              "black"
            ];
            nix = [ "nixfmt" ];
            javascript = [
              "deno fmt"
              "prettier"
            ];
            css = [
              "deno fmt"
              "prettier"
            ];
            json = [
              "deno fmt"
              "prettier"
            ];
            jsonc = [
              "deno fmt"
              "prettier"
            ];
          };

          # Default formatting options
          default_format_opts = {
            lsp_format = "fallback";
          };

          # Format-on-save behavior
          format_on_save = {
            timeout_ms = 500;
          };

          # Custom formatter settings
          formatters = {
            shfmt = {
              append_args = [
                "-i"
                "2"
              ];
            };
          };
        };
      };
      fzf-lua = {
        enable = true;
        # autoLoad = true;
      };
      kitty-scrollback = {
        enable = true;
        # autoLoad = true;
      };
      lsp = {
        enable = true;
        # autoLoad = true;
      };
      lualine = {
        enable = true;
        # autoLoad = true;
      };
    };
  };

  programs.kate = {
    enable = true;
    editor = {
      font = {
        family = "Noto Sans Mono";
        pointSize = 10;
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
      iconTheme = "Colloid-Dark";
      windowDecorations = {
        library = "org.kde.breeze";
        theme = "Breeze";
      };
      cursor.size = 24;
    };

    kwin = {
      titlebarButtons = {
        left = [
          "application-menu"
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
                "applications:vesktop.desktop"
                "applications:kitty.desktop"
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
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.volume"
              ];
              # And explicitly hide networkmanagement and volume
              # hidden = [
              #   "org.kde.plasma.networkmanagement"
              #   "org.kde.plasma.volume"
              # ];
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
