{
  pkgs,
  config,
  ...
}: {
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.packages = with pkgs; [
    kdePackages.qtdeclarative
    prettier
    prettierd
    alejandra
    stylua
    black
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
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = config.catppuccin.flavor;
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
            {name = "git";}
            {name = "nvim_lsp";}
            {name = "path";}
            {name = "buffer";}
            {name = "fish";}
            {name = "emoji";}
            {
              name = "buffer"; # text within current buffer
              option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
              keywordLength = 3;
            }
            {name = "copilot";}
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
        window = {
          completion = {
            border = "solid";
          };
          documentation = {
            border = "solid";
          };
        };

        mapping = {
          "<C-Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<C-j>" = "cmp.mapping.select_next_item()";
          "<C-k>" = "cmp.mapping.select_prev_item()";
          "<C-e>" = "cmp.mapping.abort()";
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-CR>" = "cmp.mapping.confirm({ select = true })";
          "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
        };
      };
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            lua = ["stylua"];
            python = ["black"];
            nix = ["alejandra"];
            javascript = ["prettier"];
            css = ["prettier"];
            json = ["prettier"];
            jsonc = ["prettier"];
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
      lualine = let
        palette = pkgs.catppuccin.${config.catppuccin.flavor};
      in {
        enable = true;
        settings = {
          options = {
            theme = {
              normal = {
                a = {
                  fg = palette.base;
                  bg = palette.mauve;
                };
                b = {
                  fg = palette.text;
                  bg = palette.surface0;
                };
                c = {
                  fg = palette.text;
                };
              };
              insert = {
                a = {
                  fg = palette.base;
                  bg = palette.blue;
                };
              };
              visual = {
                a = {
                  fg = palette.base;
                  bg = palette.teal;
                };
              };
              replace = {
                a = {
                  fg = palette.base;
                  bg = palette.red;
                };
              };
              inactive = {
                a = {
                  fg = palette.text;
                  bg = palette.base;
                };
                b = {
                  fg = palette.text;
                  bg = palette.base;
                };
                c = {
                  fg = palette.text;
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
            lualine_c = ["%="];
            lualine_x = [];
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
            lualine_a = ["filename"];
            lualine_b = [];
            lualine_c = [];
            lualine_x = [];
            lualine_y = [];
            lualine_z = ["location"];
          };
          tabline = {};
          extensions = [];
        };
      };
    };
  };
}
