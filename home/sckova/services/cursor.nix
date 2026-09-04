# home/sckova/services/cursor.nix
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.cursor = {
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

  config.home = {
    file.".icons/default/index.theme" = {
      force = true;

      text = /* ini */ ''
        [Icon Theme]
        Name=Default
        Comment=Default Cursor Theme
        Inherits=${config.cursor.name}
      '';
    };

    pointerCursor = {
      enable = true;
      package = config.cursor.package;
      gtk.enable = true;
      name = config.cursor.name;
      size = config.cursor.size;
    };

    sessionVariables = {
      XCURSOR_SIZE = toString config.cursor.size;
      XCURSOR_THEME = config.cursor.name;
    };
  };
}
