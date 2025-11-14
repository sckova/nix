{
  programs.kitty = {
    enable = true;
    enableGitIntegration = true;
    themeFile = "Catppuccin-Mocha";
    font = {
      name = "Noto Sans Mono";
      size = 10;
    };
    shellIntegration = {
      enableFishIntegration = true;
    };
    # extraConfig = "\nwheel_scroll_multiplier 5.0\nconfirm_os_window_close 0";
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;
      wheel_scroll_multiplier = 5.0;
      confirm_os_window_close = 0;
    };
  };
}
