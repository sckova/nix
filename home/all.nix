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
    (chromium.override {
      enableWideVine = true;
    })
    strawberry-master
    spotify-player
    input-leap
    libreoffice-qt-fresh
    spotdl

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

  programs.konsole.enable = false;

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
        settings = {
          options = {
            theme = {
              normal = {
                a = {
                  fg = "#1e1e2e";
                  bg = "#cba6f7";
                };
                b = {
                  fg = "#cdd6f4";
                  bg = "#313244";
                };
                c = {
                  fg = "#cdd6f4";
                };
              };
              insert = {
                a = {
                  fg = "#1e1e2e";
                  bg = "#89b4fa";
                };
              };
              visual = {
                a = {
                  fg = "#1e1e2e";
                  bg = "#94e2d5";
                };
              };
              replace = {
                a = {
                  fg = "#1e1e2e";
                  bg = "#f38ba8";
                };
              };
              inactive = {
                a = {
                  fg = "#cdd6f4";
                  bg = "#1e1e2e";
                };
                b = {
                  fg = "#cdd6f4";
                  bg = "#1e1e2e";
                };
                c = {
                  fg = "#cdd6f4";
                };
              };
            };
            component_separators = "";
            section_separators = {
              left = "";
              right = "";
            };
          };

          sections = {
            lualine_a = [
              {
                __unkeyed-1 = "mode";
                separator = {
                  left = "  ";
                };
                right_padding = 2;
              }
            ];
            lualine_b = [
              "filename"
              "branch"
            ];
            lualine_c = [ "%=" ];
            lualine_x = [ ];
            lualine_y = [
              "filetype"
              "progress"
            ];
            lualine_z = [
              {
                __unkeyed-1 = "location";
                separator = {
                  right = "  ";
                };
                left_padding = 2;
              }
            ];
          };

          inactive_sections = {
            lualine_a = [ "filename" ];
            lualine_b = [ ];
            lualine_c = [ ];
            lualine_x = [ ];
            lualine_y = [ ];
            lualine_z = [ "location" ];
          };
          tabline = { };
          extensions = [ ];
        };
        # autoLoad = true;
      };
    };
  };

  programs.ghostwriter = {
    enable = true;
    font = {
      family = "Noto Sans";
      pointSize = 12;
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
        description = "Global Changes";
        match = {
          window-class = {
            value = "";
            type = "substring";
          };
          window-types = [ "normal" ];
        };
        apply = {
          opacityactive = {
            value = 100;
            apply = "force";
          };
          opacityinactive = {
            value = 95;
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
            value = "";
            type = "substring";
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
          enable = false;
          noiseStrength = 8;
          strength = 5;
        };
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
      kwinrc.Plugins.forceblurEnabled = true;
      kwinrc.Effect-blurplus.BlurDecorations = true;
      kwinrc.Effect-blurplus.BlurMatching = false;
      kwinrc.Effect-blurplus.BlurMenus = true;
      kwinrc.Effect-blurplus.BlurNonMatching = true;
      kwinrc.Effect-blurplus.TopCornerRadius = 10;
      kwinrc.Effect-blurplus.BottomCornerRadius = 10;
      kwinrc.Effect-blurplus.NoiseStrength = 6;
      kwinrc.Effect-blurplus.RefractionStrength = 10;
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
