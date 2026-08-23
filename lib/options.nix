# lib/options.nix
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    colors = {
      accent = lib.mkOption {
        default = "base09";
        type = lib.types.str;
      };

      scheme = lib.mkOption {
        default = "catppuccin-mocha";
        type = lib.types.str;
      };
    };

    cursor = {
      package = lib.mkOption {
        default =
          with config.scheme;
          let
            baseColors = lib.filterAttrs (
              n: v: builtins.isString v && builtins.match "^base[0-9A-Fa-f]{2}$" n != null
            ) config.scheme.withHashtag;
          in
          (pkgs.bibata-cursor.override (
            baseColors
            // {
              baseColor = withHashtag.${config.colors.accent};
              cursorSizes = "16,20,22,24,28,32,40,48,56,64,72,80,88,96";
              outlineColor = withHashtag.base00;
              strokeWidth = "12";
              themeName = config.colors.scheme;
            }
          ));

        readOnly = true;
        type = lib.types.package;
      };

      name = lib.mkOption {
        default = config.colors.scheme;
        readOnly = true;
        type = lib.types.str;
      };

      path = lib.mkOption {
        default = "${config.cursor.package}/share/icons/${config.colors.scheme}";
        readOnly = true;
        type = lib.types.str;
      };

      size = lib.mkOption {
        default = 24;
        readOnly = true;
        type = lib.types.int;
      };
    };

    email = lib.mkOption {
      default = "kovacsmillio@gmail.com";
      readOnly = false;
      type = lib.types.str;
    };

    fonts = {
      emoji = {
        package = lib.mkOption {
          default = pkgs.noto-fonts-color-emoji;
          readOnly = false;
          type = lib.types.package;
        };

        name = lib.mkOption {
          default = "Noto Emoji";
          readOnly = false;
          type = lib.types.str;
        };

        size = lib.mkOption {
          default = 10;
          readOnly = false;
          type = lib.types.int;
        };
      };

      mono = {
        package = lib.mkOption {
          default = pkgs.nerd-fonts.jetbrains-mono;
          readOnly = false;
          type = lib.types.package;
        };

        name = lib.mkOption {
          default = "JetBrainsMono Nerd Font";
          readOnly = false;
          type = lib.types.str;
        };

        size = lib.mkOption {
          default = 10;
          readOnly = false;
          type = lib.types.int;
        };
      };

      sans = {
        package = lib.mkOption {
          default = pkgs.noto-fonts;
          readOnly = false;
          type = lib.types.package;
        };

        name = lib.mkOption {
          default = "Noto Sans";
          readOnly = false;
          type = lib.types.str;
        };

        size = lib.mkOption {
          default = 11;
          readOnly = false;
          type = lib.types.int;
        };
      };

      serif = {
        package = lib.mkOption {
          default = pkgs.noto-fonts;
          readOnly = false;
          type = lib.types.package;
        };

        name = lib.mkOption {
          default = "Noto Serif";
          readOnly = false;
          type = lib.types.str;
        };

        size = lib.mkOption {
          default = 11;
          readOnly = false;
          type = lib.types.int;
        };
      };
    };

    # read only modules
    hostname = lib.mkOption {
      default = config.system.name;
      readOnly = true;
      type = lib.types.str;
    };

    name = lib.mkOption {
      default = "Sean Kovacs";
      readOnly = false;
      type = lib.types.str;
    };

    username = lib.mkOption {
      default = "sckova";
      readOnly = false;
      type = lib.types.str;
    };
  };
}
