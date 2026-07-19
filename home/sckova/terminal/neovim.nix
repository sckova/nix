{
  pkgs,
  config,
  lib,
  isLinux,
  hostname,
  inputs,
  ...
}:
{
  imports = with inputs; [
    nixvim.homeModules.nixvim
    pedantix.homeModules.default
  ];

  home.sessionVariables.EDITOR = lib.mkForce "nvim";

  home.packages = with pkgs; [
    nixfmt
    prettier
    prettierd
    stylua
    black
    clang-tools
  ];

  programs.pedantix = {
    enable = true;
    settings = {
      formatter = "off"; # use nixfmt independently
      format-after-sort = false;
      format-before-sort = false;
      preset = "nixos-module";
      attrs = {
        blank-lines = 1; # number of blank lines between bindings
        merge = true; # merge into nested sets
      };
      lets = {
        sort = true; # reorder things
      };
    };
  };

  programs.nixvim = {
    enable = true;
    nixpkgs.useGlobalPackages = true;
    enablePrintInit = true;
    defaultEditor = true;
    waylandSupport = isLinux;
    viAlias = true;
    vimAlias = true;

    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = isLinux;
      providers.pbcopy.enable = pkgs.stdenv.isDarwin;
    };

    opts = {
      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      number = true;
      numberwidth = 4;
      statuscolumn = "%C %s%=%l ";
      autocomplete = true;
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
      foldmethod = "expr";
      foldexpr = "v:lua.vim.treesitter.foldexpr()";
    };

    highlight = {
      # enable transparency
      Normal = {
        bg = "NONE";
        ctermbg = "NONE";
      };
      NormalNC = {
        bg = "NONE";
        ctermbg = "NONE";
      };
      NormalFloat = {
        bg = "NONE";
        ctermbg = "NONE";
      };
      EndOfBuffer = {
        bg = "NONE";
        ctermbg = "NONE";
      };
      SignColumn = {
        bg = "NONE";
        ctermbg = "NONE";
      };
      LineNr = {
        bg = "NONE";
        ctermbg = "NONE";
      };
      CursorLineNr = {
        bg = "NONE";
        ctermbg = "NONE";
      };

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
          base08 = config.scheme.withHashtag.${config.colors.accent};
        }
        // (
          if (builtins.elem config.colors.accent (builtins.attrNames cleanScheme)) then
            { ${config.colors.accent} = cleanScheme.base08; }
          else
            { }
        );
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
      treesitter = {
        enable = true;
        highlight.enable = true;
        indent.enable = false;
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

      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            lua = [ "stylua" ];
            python = [ "black" ];
            nix = [
              "nixfmt"
              "pedantix"
              "injected"
            ];
            html = [ "prettier" ];
            javascript = [ "prettier" ];
            css = [ "prettier" ];
            json = [ "prettier" ];
            jsonc = [ "prettier" ];
            fish = [ "fish_indent" ];
            c = [ "clang-format" ];
            cpp = [ "clang-format" ];
          };
          default_format_opts.lsp_format = "fallback";
          format_on_save = {
            timeout_ms = 500;
            run_all_formatters = true;
          };
          formatters = {
            shfmt.append_args = [
              "-i"
              "2"
            ];
            pedantix = {
              command = lib.getExe pkgs.pedantix;
              args = [ "$FILENAME" ];
              stdin = false;
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
          nixd = {
            enable = true;
            settings = {
              nixpkgs.expr = "import <nixpkgs> { }";
              formatting.command = [ "nixfmt" ];
              options = {
                nixos.expr = "(builtins.getFlake \"/home/sckova/nix\").nixosConfigurations.${hostname}.options";
              };
            };
          };
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
