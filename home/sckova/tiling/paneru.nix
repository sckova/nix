{
  config,
  inputs,
  ...
}:
{
  imports = with inputs; [
    paneru.homeModules.paneru
  ];

  services.paneru = {
    enable = true;

    settings = {
      options = {
        animation_speed = 14;
        focus_follows_mouse = true;
        mouse_follows_focus = false;

        preset_column_widths = [
          0.33
          0.5
          0.66
        ];
      };

      bindings = {
        quit = "ctrl + alt - q";
        window_center = "alt - c";
        window_focus_east = "cmd - rightarrow";
        window_focus_west = "cmd - leftarrow";
        window_resize = "cmd - r";
      };

      decorations = {
        active.border = {
          color = config.scheme.withHashtag.${config.colors.accent};
          enabled = true;
          radius = 8.0;
          width = 2.0;
        };
      };

      padding = {
        bottom = 16;
        left = 16;
        right = 16;
        top = 16;
      };

      windows.all = {
        bundle_id = ".*";
        title = ".*";
        # the following doesn't work as expected (padding the inner areas)
        # horizontal_padding = 8;
        width = 0.5;
      };
    };
  };
}
