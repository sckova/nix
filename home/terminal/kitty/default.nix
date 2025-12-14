{ config, lib, ... }:

{
  programs.kitty = {
    enable = true;
    enableGitIntegration = true;
    themeFile = "Catppuccin-${config.catppuccinUpper.flavor}";
    font = {
      name = config.userOptions.fontMono.name;
      size = config.userOptions.fontMono.size;
    };
    shellIntegration = {
      enableFishIntegration = true;
    };
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;
      wheel_scroll_multiplier = 5.0;
      confirm_os_window_close = 0;
      tab_bar_min_tabs = 2;
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      mouse_hide_wait = "-1.0";
    };
  };
}
