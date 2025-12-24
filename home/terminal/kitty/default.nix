{
  config,
  lib,
  pkgs,
  ...
}: let
  catppuccin-kitty = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "kitty";
    rev = "b14e8385c827f2d41660b71c7fec1e92bdcf2676";
    sha256 = "sha256-59ON7CzVgfZUo7F81qQZQ1r6kpcjR3OPvTl99gzDP8E=";
  };

  mergedConfig = pkgs.runCommand "mergedConfig" {} ''
    mkdir -p $out
    ${pkgs.gnused}/bin/sed 's/#cba6f7/${
      pkgs.catppuccin.${config.catppuccin.flavor}.${config.catppuccin.accent}
    }/g' ${catppuccin-kitty}/themes/${config.catppuccin.flavor}.conf > \
    $out/${config.catppuccinUpper.flavor}${config.catppuccinUpper.accent}.conf
  '';
in {
  home.file.".config/kitty/themes" = {
    source = mergedConfig;
    recursive = true;
  };

  programs.kitty = {
    enable = true;
    enableGitIntegration = true;
    font = {
      name = config.userOptions.fontMono.name;
      size = config.userOptions.fontMono.size;
    };
    shellIntegration.enableFishIntegration = true;
    settings = {
      include = "/home/${config.userOptions.username}/.config/kitty/themes/${config.catppuccinUpper.flavor}${config.catppuccinUpper.accent}.conf";
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
