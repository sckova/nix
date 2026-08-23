# home/sckova/terminal/neovim/plugins/lualine.nix
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  programs.nixvim.plugins.lualine = with config.scheme.withHashtag; {
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

            c.fg = base05;
          };

          insert.a = {
            bg = base0D;
            fg = base00;
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

            c.fg = base05;
          };

          replace.a = {
            bg = base08;
            fg = base00;
          };

          visual.a = {
            bg = base0C;
            fg = base00;
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
            separator.left = "  ";
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
            separator.right = "  ";
          }
        ];
      };

      tabline = { };
    };
  };
}
