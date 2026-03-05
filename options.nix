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
      email = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        default = "kovacsmillio@gmail.com";
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
              cursorSizes = "16 20 22 24 28 32 40 48 56 64 72 80 88 96";
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
          default = "${config.userOptions.cursor.package}/share/icons/${config.colors.scheme}";
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
