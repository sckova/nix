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
    extraConfig = "\nwheel_scroll_multiplier 5.0";
  };
}
