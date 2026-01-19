{
  config,
  pkgs,
  ...
}: let
  colors = pkgs.catppuccin.hex.${config.catppuccin.flavor};
  accent = colors.${config.catppuccin.accent};

  # Map Catppuccin colors to Kitty theme structure
  kitty-colors = ''
    # vim:ft=kitty
    ## name:     Kova's Nixified Kitty
    ## author:   Catppuccin Org & sckova
    ## license:  MIT
    ## upstream: https://github.com/catppuccin/kitty
    ## blurb:    The theme generated from the NixOS configuration!

    # The basic colors
    foreground              ${colors.text}
    background              ${colors.base}
    selection_foreground    ${colors.base}
    selection_background    ${colors.rosewater}

    # Cursor colors
    cursor                  ${colors.rosewater}
    cursor_text_color       ${colors.base}

    # URL underline color when hovering with mouse
    url_color               ${colors.rosewater}

    # Kitty window border colors
    active_border_color     ${accent}
    inactive_border_color   ${colors.overlay0}
    bell_border_color       ${colors.yellow}

    # Tab bar colors
    active_tab_foreground   ${colors.crust}
    active_tab_background   ${accent}
    inactive_tab_foreground ${colors.text}
    inactive_tab_background ${colors.mantle}
    tab_bar_background      ${colors.crust}

    # Colors for marks (marked text in the terminal)
    mark1_foreground ${colors.base}
    mark1_background ${accent}
    mark2_foreground ${colors.base}
    mark2_background ${colors.blue}
    mark3_foreground ${colors.base}
    mark3_background ${colors.sky}

    # The 16 terminal colors
    # black
    color0 ${colors.surface1}
    color8 ${colors.surface2}

    # red
    color1 ${colors.red}
    color9 ${colors.red}

    # green
    color2  ${colors.green}
    color10 ${colors.green}

    # yellow
    color3  ${colors.yellow}
    color11 ${colors.yellow}

    # blue
    color4  ${colors.blue}
    color12 ${colors.blue}

    # magenta
    color5  ${colors.pink}
    color13 ${colors.pink}

    # cyan
    color6  ${colors.teal}
    color14 ${colors.teal}

    # white
    color7  ${colors.subtext1}
    color15 ${colors.subtext0}
  '';

  kitty-colors-file = pkgs.writeTextFile {
    name = "kitty-colors";
    text = kitty-colors;
    destination = "/kitty-colors.conf";
  };
in {
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
        "ctrl+k" = ''combine : clear_terminal scroll active : clear_terminal scrollback active'';
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
      config.theme = "Catppuccin ${config.catppuccinUpper.flavor}";
    };
  };
}
