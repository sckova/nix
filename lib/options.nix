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
    name = lib.mkOption {
      type = lib.types.str;
      readOnly = false;
      default = "Sean Kovacs";
    };
    username = lib.mkOption {
      type = lib.types.str;
      readOnly = false;
      default = "sckova";
    };
    email = lib.mkOption {
      type = lib.types.str;
      readOnly = false;
      default = "kovacsmillio@gmail.com";
    };
    fonts = {
      sans = {
        name = lib.mkOption {
          type = lib.types.str;
          readOnly = false;
          default = "Noto Sans";
        };
        size = lib.mkOption {
          type = lib.types.int;
          readOnly = false;
          default = 11;
        };
        package = lib.mkOption {
          type = lib.types.package;
          readOnly = false;
          default = pkgs.noto-fonts;
        };
      };

      serif = {
        name = lib.mkOption {
          type = lib.types.str;
          readOnly = false;
          default = "Noto Serif";
        };
        size = lib.mkOption {
          type = lib.types.int;
          readOnly = false;
          default = 11;
        };
        package = lib.mkOption {
          type = lib.types.package;
          readOnly = false;
          default = pkgs.noto-fonts;
        };
      };

      mono = {
        name = lib.mkOption {
          type = lib.types.str;
          readOnly = false;
          default = "JetBrainsMono Nerd Font";
        };
        size = lib.mkOption {
          type = lib.types.int;
          readOnly = false;
          default = 10;
        };
        package = lib.mkOption {
          type = lib.types.package;
          readOnly = false;
          default = pkgs.nerd-fonts.jetbrains-mono;
        };
      };

      emoji = {
        name = lib.mkOption {
          type = lib.types.str;
          readOnly = false;
          default = "Noto Emoji";
        };
        size = lib.mkOption {
          type = lib.types.int;
          readOnly = false;
          default = 10;
        };
        package = lib.mkOption {
          type = lib.types.package;
          readOnly = false;
          default = pkgs.noto-fonts-color-emoji;
        };
      };
    };

    # read only modules
    hostname = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      default = config.system.name;
    };
    cursor = {
      name = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        default = config.colors.scheme;
      };
      package = lib.mkOption {
        type = lib.types.package;
        readOnly = true;
        default =
          with config.scheme;
          (pkgs.bibata-cursor.override {
            themeName = config.colors.scheme;
            baseColor = withHashtag.${config.colors.accent};
            outlineColor = withHashtag.base00;
            watchBackgroundColor = withHashtag.base11;
            cursorSizes = "24";
          });
      };
      size = lib.mkOption {
        type = lib.types.int;
        readOnly = true;
        default = 24;
      };
      path = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        default = "${config.cursor.package}/share/icons/${config.colors.scheme}";
      };
    };
  };
}
