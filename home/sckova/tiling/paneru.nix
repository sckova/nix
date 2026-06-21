{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf pkgs.stdenv.isDarwin {
  services.paneru = {
    enable = true;
    settings = {
      options = {
        focus_follows_mouse = true;
        mouse_follows_focus = false;
        preset_column_widths = [
          0.33
          0.5
          0.66
        ];
        animation_speed = 14;
      };
      padding = {
        top = 16;
        bottom = 16;
        left = 16;
        right = 16;
      };
      decorations = {
        active.border = {
          enabled = true;
          color = config.scheme.withHashtag.${config.colors.accent};
          width = 2.0;
          radius = 8.0;
        };
      };
      windows.all = {
        title = ".*";
        bundle_id = ".*";
        # the following doesn't work as expected (padding the inner areas)
        # horizontal_padding = 8;
        width = 0.5;
      };
      bindings = {
        window_focus_west = "cmd - leftarrow";
        window_focus_east = "cmd - rightarrow";
        window_resize = "cmd - r";
        window_center = "alt - c";
        quit = "ctrl + alt - q";
      };
    };
  };
}
