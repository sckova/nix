{
  pkgs,
  config,
  ...
}:
{
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.packages = with pkgs; [
    kdePackages.qtdeclarative
    prettier
    prettierd
    nixfmt
    stylua
    black
    clang-tools
  ];

  programs.nixvim = {
    enable = true;
    enablePrintInit = true;
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
    colorschemes.palette = {
      enable = true;
      settings = {
        palettes = {
          main = "base16_custom";
          accent = "base16_custom";
          state = "base16_custom";
        };

        custom_palettes = with config.scheme.withHashtag; {
          main.base16_custom = {
            color0 = base00; # background
            color1 = base01; # lighter background
            color2 = base02; # selection background
            color3 = base03; # comments
            color4 = base04; # dark foreground
            color5 = base05; # default foreground
            color6 = base06; # light foreground
            color7 = base07; # lightest foreground
            color8 = base05; # variables/tags
          };

          accent.base16_custom = {
            accent0 = base09; # integers/constants
            accent1 = base0A; # classes/search
            accent2 = base0B; # strings/inherited
            accent3 = base0C; # support/regex
            accent4 = base0D; # functions/headings
            accent5 = base0E; # keywords/bold
            accent6 = base0F; # deprecated/embedded
          };

          state.base16_custom = {
            error = base08; # red
            warning = base0A; # yellow
            hint = base0C; # cyan
            ok = base0B; # green
            info = base0D; # blue
          };
        };
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
      };
      cmp = {
        enable = true;
        settings = {
          autoEnableSources = true;
          performance = {
            debounce = 60;
            fetchingTimeout = 200;
            maxViewEntries = 30;
          };
          snippet = {
            expand = "luasnip";
          };
          formatting = {
            fields = [
              "kind"
              "abbr"
              "menu"
            ];
          };
          sources = [
            { name = "git"; }
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
            { name = "fish"; }
            { name = "emoji"; }
            {
              name = "buffer"; # text within current buffer
              option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
              keywordLength = 3;
            }
            { name = "copilot"; }
            {
              name = "path"; # file system paths
              keywordLength = 3;
            }
            {
              name = "luasnip"; # snippets
              keywordLength = 3;
            }
          ];
        };
      };
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            lua = [ "stylua" ];
            python = [ "black" ];
            nix = [ "nixfmt" ];
            html = [ "prettier" ];
            javascript = [ "prettier" ];
            css = [ "prettier" ];
            json = [ "prettier" ];
            jsonc = [ "prettier" ];
            fish = [ "fish_indent" ];
            c = [ "clang-format" ];
            cpp = [ "clang-format" ];
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
      };
      kitty-scrollback = {
        enable = true;
      };
      lsp = {
        enable = true;
        servers = {
          qmlls = {
            enable = true;
            cmd = [
              "qmlls"
              "-E"
            ];
          };
          nixd.enable = true;
        };
      };
      lualine = with config.scheme.withHashtag; {
        enable = true;
        settings = {
          options = {
            theme = {
              normal = {
                a = {
                  fg = base00;
                  bg = base0E;
                };
                b = {
                  fg = base05;
                  bg = base01;
                };
                c = {
                  fg = base05;
                };
              };
              insert = {
                a = {
                  fg = base00;
                  bg = base0D;
                };
              };
              visual = {
                a = {
                  fg = base00;
                  bg = base0C;
                };
              };
              replace = {
                a = {
                  fg = base00;
                  bg = base08;
                };
              };
              inactive = {
                a = {
                  fg = base05;
                  bg = base00;
                };
                b = {
                  fg = base05;
                  bg = base00;
                };
                c = {
                  fg = base05;
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
      };
    };
  };
}
