{
  config,
  lib,
  ...
}:
{
  home.sessionVariables.EDITOR = lib.mkForce "nvim";

  programs.nixvim = {
    enable = true;
    nixpkgs.useGlobalPackages = true;
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
      numberwidth = 4;
      statuscolumn = "%C %s%=%l ";

      # folding config
      foldcolumn = "1";
      fillchars = {
        eob = " ";
        fold = " ";
        foldopen = "";
        foldsep = " ";
        foldinner = " ";
        foldclose = "";
      };
      foldlevel = 99;
      foldlevelstart = 99;
      foldenable = true;
    };

    highlight = {
      FoldColumn = {
        # the color of the fold icons and backdrop
        fg = config.scheme.withHashtag.base04;
        bg = "NONE";
      };

      # the color of the actual folded text line
      Folded = {
        fg = config.scheme.withHashtag.base03;
        bg = "NONE";
      };
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
          base00 = config.scheme.withHashtag.base00;
        }
        // (if (builtins.elem config.colors.accent (builtins.attrNames cleanScheme)) then { } else { });
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

      # --- Folding mappings ---
      {
        mode = "n";
        key = "<C-Space>";
        action = "za";
        options = {
          noremap = true;
          silent = true;
          desc = "toggle fold under cursor";
        };
      }

      # --- Toggle Markdown for current file ---
      {
        mode = [
          "n"
          "v"
        ];
        key = "<C-m>";
        action = "<cmd>RenderMarkdown toggle<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "Toggle Markdown rendering";
        };
      }
    ];

    plugins = {
      # transparent background
      transparent = {
        enable = true;
        lazyLoad.enable = false;
        settings.groups = [
          "Normal"
          "NormalNC"
          "Comment"
          "Constant"
          "Special"
          "Identifier"
          "Statement"
          "PreProc"
          "Type"
          "Underlined"
          "Todo"
          "String"
          "Function"
          "Conditional"
          "Repeat"
          "Operator"
          "Structure"
          "LineNr"
          "NonText"
          "SignColumn"
          "CursorLine"
          "CursorLineNr"
          "StatusLine"
          "StatusLineNC"
          "EndOfBuffer"
        ];
      };
      treesitter = {
        enable = true;
        highlight.enable = true;
        indent.enable = true;
        folding.enable = true;
        settings = {
          ensure_installed = [
            "nix"
            "css"
            "markdown"
            "markdown_inline"
          ];
        };
      };
      nvim-autopairs.enable = true;
      render-markdown.enable = true;
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
            __raw = /* lua */ ''
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
