{
  config,
  lib,
  ...
}:
{
  home.sessionVariables.EDITOR = lib.mkForce "nvim";

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

    colorschemes.base16 = {
      enable = true;
      setUpBar = false;
      colorscheme =
        let
          cleanScheme = {
            inherit (config.scheme.withHashtag)
              base00
              base01
              base02
              base03
              base04
              base05
              base06
              base07
              base08
              base09
              base0A
              base0B
              base0C
              base0D
              base0E
              base0F
              ;
          };
        in
        cleanScheme
        // {
          base08 = cleanScheme.${config.colors.accent};
          ${config.colors.accent} = cleanScheme.base08;
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
          mapping = {
            __raw = ''
              cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<C-Enter>'] = cmp.mapping.confirm({ select = true }),
              })
            '';
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
            {
              name = "buffer"; # text within current buffer
              option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
              keywordLength = 3;
            }
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
