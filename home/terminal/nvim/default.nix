{ pkgs, ... }:

{
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.packages = with pkgs; [ kdePackages.qtdeclarative ];

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
        autoLoad = true;
      };
      cmp = {
        autoEnableSources = true;
        enable = true;
        autoLoad = true;
      };
      conform-nvim = {
        enable = true;
        autoLoad = true;
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
        autoLoad = true;
      };
      kitty-scrollback = {
        enable = true;
        autoLoad = true;
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
        };
        autoLoad = true;
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
        autoLoad = true;
      };
    };
  };
}
