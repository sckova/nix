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
    killall
    wget
    ripgrep
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
      wallpaperPictureOfTheDay.provider = "bing";
      wallpaperFillMode = "preserveAspectCrop";
    };

    kscreenlocker = {
      appearance.wallpaperPictureOfTheDay.provider = "bing";
    };

    window-rules = [
      {
        description = "OpenMW";
        match = {
          window-class = {
            value = "openmw";
            type = "substring";
          };
          window-types = [ "normal" ];
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
        description = "Firefox Picture-in-Picture";
        match = {
          window-class = {
            value = "firefox";
            type = "exact";
          };
          title = {
            value = "Picture-in-Picture";
            type = "exact";
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
    ];

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
    };

    configFile = {
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
      kdeglobals.Sounds.Enable = false;
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
                "applications:org.kde.dolphin.desktop"
                "applications:vesktop.desktop"
                "applications:kitty.desktop"
              ];
            };
          }
          "org.kde.plasma.pager"
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
