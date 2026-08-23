# home/sckova/tiling/paneru.nix
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
        animation_speed = 15;
        focus_follows_mouse = true;
        mouse_follows_focus = false;

        preset_column_widths = [
          0.33
          0.5
          0.66
        ];
      };

      bindings =
        let
          mod = "alt";
        in
        {
          # Lifecycle
          quit = "${mod} + shift - e";
        }
        // {
          # Focus Navigation
          window_focus_east = "${mod} - rightarrow";
          window_focus_first = "${mod} - home";
          window_focus_last = "${mod} - end";
          window_focus_north = "${mod} - uparrow";
          window_focus_south = "${mod} - downarrow";
          window_focus_unmanaged = "${mod} + shift - v";
          window_focus_west = "${mod} - leftarrow";
        }
        // {
          # Window & Column Movement
          window_swap_east = "${mod} + ctrl - rightarrow";
          window_swap_first = "${mod} + ctrl - home";
          window_swap_last = "${mod} + ctrl - end";
          window_swap_north = "${mod} + ctrl - uparrow";
          window_swap_south = "${mod} + ctrl - downarrow";
          window_swap_west = "${mod} + ctrl - leftarrow";
        }
        // {
          # Layout & Sizing
          window_center = "${mod} - c";
          window_equalize = "${mod} + ctrl - r";
          window_fullwidth = "${mod} - f";
          window_resize = "${mod} - r";
          window_shrink = "${mod} + shift - r";
        }
        // {
          # Column Stacking
          window_stack = "${mod} - leftbracket";
          window_unstack = "${mod} - rightbracket";
        }
        // {
          # Floating & Management
          window_manage = "${mod} - v";
        };

      decorations.active.border = {
        color = config.scheme.withHashtag.${config.colors.accent};
        enabled = true;
        radius = 16.0;
        width = 2.0;
      };

      padding = {
        bottom = 8;
        left = 8;
        right = 8;
        top = 8;
      };

      swipe = {
        fingers_count = 3; # swipe module is enabled when this >=3
      };

      windows.all = {
        bundle_id = ".*";
        # the following doesn't work as expected (padding the inner areas)
        horizontal_padding = 8;
        title = ".*";
        vertical_padding = 0;
        width = 0.5;
      };
    };
  };
}
