{
  config,
  lib,
  pkgs,
  hostname,
  inputs,
  ...
}:
{
  imports = with inputs; [
    nixvim.homeModules.nixvim
    pedantix.homeModules.default
  ];

  home = {
    packages = with pkgs; [
      nixfmt
      prettier
      prettierd
      stylua
      black
      clang-tools
    ];

    sessionVariables.EDITOR = lib.mkForce "nvim";
  };

  programs = {
    nixvim = {
      enable = true;

      clipboard = {
        providers = {
          pbcopy.enable = pkgs.stdenv.isDarwin;
          wl-copy.enable = pkgs.stdenv.isLinux;
        };

        register = "unnamedplus";
      };

      colorschemes.base16 = {
        enable = true;

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

        setUpBar = false;
      };

      defaultEditor = true;
      enablePrintInit = true;

      highlight = {
        CursorLineNr = {
          bg = "NONE";
          ctermbg = "NONE";
        };

        EndOfBuffer = {
          bg = "NONE";
          ctermbg = "NONE";
        };

        FoldColumn = {
          bg = "NONE";
          # the color of the fold icons and backdrop
          fg = config.scheme.withHashtag.base04;
        };

        # the color of the actual folded text line
        Folded = {
          bg = "NONE";
          fg = config.scheme.withHashtag.base03;
        };

        LineNr = {
          bg = "NONE";
          ctermbg = "NONE";
        };

        # enable transparency
        Normal = {
          bg = "NONE";
          ctermbg = "NONE";
        };

        NormalFloat = {
          bg = "NONE";
          ctermbg = "NONE";
        };

        NormalNC = {
          bg = "NONE";
          ctermbg = "NONE";
        };

        SignColumn = {
          bg = "NONE";
          ctermbg = "NONE";
        };
      };

      keymaps = [
        # --- Normal mode mappings ---
        {
          options = {
            noremap = true;
            silent = true;
          };

          action = "\"+y";
          key = "<C-c>";
          mode = "n";
        }
        {
          options = {
            noremap = true;
            silent = true;
          };

          action = "\"+p";
          key = "<C-p>";
          mode = "n";
        }

        # --- Visual mode mappings ---
        {
          options = {
            noremap = true;
            silent = true;
          };

          action = "\"+y";
          key = "<C-c>";
          mode = "v";
        }
        {
          options = {
            noremap = true;
            silent = true;
          };

          action = "\"+p";
          key = "<C-p>";
          mode = "v";
        }

        # --- Folding mappings ---
        {
          options = {
            desc = "toggle fold under cursor";
            noremap = true;
            silent = true;
          };

          action = "za";
          key = "<C-Space>";
          mode = "n";
        }

        # --- Toggle Markdown for current file ---
        {
          options = {
            desc = "Toggle Markdown rendering";
            noremap = true;
            silent = true;
          };

          action = "<cmd>RenderMarkdown toggle<CR>";
          key = "<C-m>";

          mode = [
            "n"
            "v"
          ];
        }
      ];

      nixpkgs.useGlobalPackages = true;

      opts = {
        autocomplete = true;
        expandtab = true;

        fillchars = {
          eob = " ";
          fold = " ";
          foldclose = "";
          foldinner = " ";
          foldopen = "";
          foldsep = " ";
        };

        foldcolumn = "1";
        foldenable = true;
        foldexpr = "v:lua.vim.treesitter.foldexpr()";
        foldlevel = 99;
        foldlevelstart = 99;
        foldmethod = "expr";
        number = true;
        numberwidth = 4;
        shiftwidth = 2;
        softtabstop = 2;
        statuscolumn = "%C %s%=%l ";
        tabstop = 2;
      };

      plugins = {
        conform-nvim = {
          enable = true;

          settings = {
            default_format_opts.lsp_format = "fallback";

            format_on_save = {
              run_all_formatters = true;
              timeout_ms = 500;
            };

            formatters = {
              pedantix = {
                args = [ "$FILENAME" ];
                command = lib.getExe pkgs.pedantix;
                stdin = false;
              };

              shfmt.append_args = [
                "-i"
                "2"
              ];
            };

            formatters_by_ft = {
              c = [ "clang-format" ];
              cpp = [ "clang-format" ];
              css = [ "prettier" ];
              fish = [ "fish_indent" ];
              html = [ "prettier" ];
              javascript = [ "prettier" ];
              json = [ "prettier" ];
              jsonc = [ "prettier" ];
              lua = [ "stylua" ];

              nix = [
                "nixfmt"
                "pedantix"
                "injected"
              ];

              python = [ "black" ];
            };
          };
        };

        fzf-lua = {
          enable = true;
        };

        lsp = {
          enable = true;

          servers = {
            nixd = {
              enable = true;

              settings = {
                options = {
                  nixos.expr = "(builtins.getFlake \"/home/sckova/nix\").nixosConfigurations.${hostname}.options";
                };

                formatting.command = [ "nixfmt" ];
                nixpkgs.expr = "import <nixpkgs> { }";
              };
            };

            qmlls = {
              enable = true;

              cmd = [
                "qmlls"
                "-E"
              ];
            };
          };
        };

        lualine = with config.scheme.withHashtag; {
          enable = true;

          settings = {
            options = {
              component_separators = "";

              section_separators = {
                left = "";
                right = "";
              };

              theme = {
                inactive = {
                  a = {
                    bg = base00;
                    fg = base05;
                  };

                  b = {
                    bg = base00;
                    fg = base05;
                  };

                  c = {
                    fg = base05;
                  };
                };

                insert = {
                  a = {
                    bg = base0D;
                    fg = base00;
                  };
                };

                normal = {
                  a = {
                    bg = base0E;
                    fg = base00;
                  };

                  b = {
                    bg = base01;
                    fg = base05;
                  };

                  c = {
                    fg = base05;
                  };
                };

                replace = {
                  a = {
                    bg = base08;
                    fg = base00;
                  };
                };

                visual = {
                  a = {
                    bg = base0C;
                    fg = base00;
                  };
                };
              };
            };

            extensions = [ ];

            inactive_sections = {
              lualine_a = [ "filename" ];
              lualine_b = [ ];
              lualine_c = [ ];
              lualine_x = [ ];
              lualine_y = [ ];
              lualine_z = [ "location" ];
            };

            sections = {
              lualine_a = [
                {
                  __unkeyed-1 = "mode";
                  right_padding = 2;

                  separator = {
                    left = "  ";
                  };
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
                  left_padding = 2;

                  separator = {
                    right = "  ";
                  };
                }
              ];
            };

            tabline = { };
          };
        };

        nvim-autopairs.enable = true;
        render-markdown.enable = true;

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
      };

      viAlias = true;
      vimAlias = true;
      waylandSupport = pkgs.stdenv.isLinux;
    };

    pedantix = {
      enable = true;

      settings = {
        attrs = {
          blank-lines = 1; # number of blank lines between bindings
          merge = true; # merge into nested sets
        };

        format-after-sort = false;
        format-before-sort = false;
        formatter = "off"; # use nixfmt independently

        lets = {
          sort = true; # reorder things
        };

        preset = "nixos-module";
      };
    };
  };
}
