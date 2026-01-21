{
  config,
  pkgs,
  ...
}:
let
  # Map Catppuccin colors to Kitty theme structure
  kitty-colors = with config.scheme.withHashtag; ''
    # vim:ft=kitty
    ## name:     Kova's Nixified Kitty
    ## author:   Catppuccin Org & sckova
    ## license:  MIT
    ## upstream: https://github.com/catppuccin/kitty
    ## blurb:    The theme generated from the NixOS configuration!

    # The basic colors
    foreground              ${base05}
    background              ${base00}
    selection_foreground    ${base00}
    selection_background    ${base06}

    # Cursor colors
    cursor                  ${base06}
    cursor_text_color       ${base00}

    # URL underline color when hovering with mouse
    url_color               ${base06}

    # Kitty window border colors
    active_border_color     ${base09}
    inactive_border_color   ${base03}
    bell_border_color       ${base0A}

    # Tab bar colors
    active_tab_foreground   ${base11}
    active_tab_background   ${base09}
    inactive_tab_foreground ${base05}
    inactive_tab_background ${base10}
    tab_bar_background      ${base11}

    # Colors for marks (marked text in the terminal)
    mark1_foreground ${base00}
    mark1_background ${base09}
    mark2_foreground ${base00}
    mark2_background ${base0D}
    mark3_foreground ${base00}
    mark3_background ${base15}

    # The 16 terminal colors
    # black
    color0 ${base02}
    color8 ${base02}

    # red
    color1 ${base08}
    color9 ${base08}

    # green
    color2  ${base0B}
    color10 ${base0B}

    # yellow
    color3  ${base0A}
    color11 ${base0A}

    # blue
    color4  ${base0D}
    color12 ${base0D}

    # magenta
    color5  ${base17}
    color13 ${base17}

    # cyan
    color6  ${base0C}
    color14 ${base0C}

    # white
    color7  ${base04}
    color15 ${base04}
  '';

  kitty-colors-file = pkgs.writeTextFile {
    name = "kitty-colors";
    text = kitty-colors;
    destination = "/kitty-colors.conf";
  };
in
{
  home.file.".config/kitty/themes" = {
    source = kitty-colors-file;
    recursive = true;
  };

  home.file.".config/kitty/ssh.conf" = {
    text = ''
      shell_integration inherited
    '';
  };

  programs = {
    kitty = {
      enable = true;
      enableGitIntegration = true;
      font = {
        name = config.userOptions.fontMono.name;
        size = config.userOptions.fontMono.size;
      };
      shellIntegration.enableFishIntegration = true;
      keybindings = {
        "ctrl+k" = "combine : clear_terminal scroll active : clear_terminal scrollback active";
      };
      settings = {
        include = "/home/${config.userOptions.username}/.config/kitty/themes/kitty-colors.conf";
        scrollback_lines = 10000;
        enable_audio_bell = false;
        update_check_interval = 0;
        wheel_scroll_multiplier = 5.0;
        confirm_os_window_close = 0;
        window_padding_width = 4;
        tab_bar_min_tabs = 2;
        tab_bar_edge = "top";
        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
        mouse_hide_wait = "-1.0";
        wayland_titlebar_color = "system";
        macos_titlebar_color = "system";
      };
    };
    bat = {
      enable = true;
      # config.theme = "Catppuccin ${config.catppuccinUpper.flavor}";
    };
  };
}
