{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.fonts = {
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

  config.home.packages = [
    config.fonts.emoji.package
    config.fonts.mono.package
    config.fonts.sans.package
    config.fonts.serif.package
  ];
}
