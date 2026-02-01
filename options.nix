{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    colors = {
      scheme = lib.mkOption {
        type = lib.types.str;
        default = "catppuccin-mocha";
      };
      accent = lib.mkOption {
        type = lib.types.str;
        default = "base09";
      };
    };
    # catppuccinUpper = {
    #   accent = lib.mkOption {
    #     type = lib.types.str;
    #     readOnly = true;
    #     default =
    #       builtins.substring 0 1 (lib.toUpper config.catppuccin.accent)
    #       + builtins.substring 1 (-1) config.catppuccin.accent;
    #   };
    #   flavor = lib.mkOption {
    #     type = lib.types.str;
    #     readOnly = true;
    #     default =
    #       builtins.substring 0 1 (lib.toUpper config.catppuccin.flavor)
    #       + builtins.substring 1 (-1) config.catppuccin.flavor;
    #   };
    # };
    userOptions = {
      name = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        default = "Sean Kovacs";
      };
      username = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        default = "sckova";
      };
      hostname = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        default = config.system.name;
      };
      fontSans = {
        name = lib.mkOption {
          type = lib.types.str;
          readOnly = true;
          default = "Noto Sans";
        };
        size = lib.mkOption {
          type = lib.types.int;
          readOnly = true;
          default = 11;
        };
        package = lib.mkOption {
          type = lib.types.package;
          readOnly = true;
          default = pkgs.noto-fonts;
        };
      };
      fontSerif = {
        name = lib.mkOption {
          type = lib.types.str;
          readOnly = true;
          default = "Noto Serif";
        };
        size = lib.mkOption {
          type = lib.types.int;
          readOnly = true;
          default = 11;
        };
        package = lib.mkOption {
          type = lib.types.package;
          readOnly = true;
          default = pkgs.noto-fonts;
        };
      };
      fontMono = {
        name = lib.mkOption {
          type = lib.types.str;
          readOnly = true;
          default = "FiraMono Nerd Font Mono";
        };
        size = lib.mkOption {
          type = lib.types.int;
          readOnly = true;
          default = 10;
        };
        package = lib.mkOption {
          type = lib.types.package;
          readOnly = true;
          default = pkgs.nerd-fonts.fira-mono;
        };
      };
      fontEmoji = {
        name = lib.mkOption {
          type = lib.types.str;
          readOnly = true;
          default = "Noto Emoji";
        };
        size = lib.mkOption {
          type = lib.types.int;
          readOnly = true;
          default = 10;
        };
        package = lib.mkOption {
          type = lib.types.package;
          readOnly = true;
          default = pkgs.noto-fonts-color-emoji;
        };
      };
      cursor =
        let
          attrName = "mocha" + "Peach";
        in
        {
          name = lib.mkOption {
            type = lib.types.str;
            readOnly = true;
            default = "catppuccin-mocha-peach-cursors";
          };
          package = lib.mkOption {
            type = lib.types.package;
            readOnly = true;
            default = pkgs.catppuccin-cursors.${attrName};
          };
          size = lib.mkOption {
            type = lib.types.int;
            readOnly = true;
            default = 24;
          };
          path = lib.mkOption {
            type = lib.types.str;
            readOnly = true;
            default = "${pkgs.catppuccin-cursors.${attrName}}/share/icons";
          };
        };
      # isDark = lib.mkOption {
      #   type = lib.types.bool;
      #   readOnly = true;
      #   default = config.catppuccin.flavor != "latte";
      # };
    };
  };
}
