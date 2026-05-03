{ config, ... }:
{
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    systemd.enable = true;
    settings = {
      # https://ghostty.org/docs/linux/systemd
      quit-after-last-window-closed = false;

      # https://github.com/ghostty-org/ghostty/discussions/5948
      font-family = config.userOptions.fontMono.name;
      font-size = config.userOptions.fontMono.size;
      window-padding-x = 4;
      window-padding-y = 4;
      confirm-close-surface = false;
      mouse-hide-while-typing = false;
      mouse-scroll-multiplier = "precision:0.25,discrete:0.5";
      keybind = [
        "ctrl+k=clear_screen"
        "ctrl+enter=unbind"
      ];
      background-opacity = 0.9;
      theme = "nixos";
    };
    themes.nixos = with config.scheme.withHashtag; {
      background = base00;
      foreground = base05;
      cursor-color = base05;
      cursor-text = base00;
      palette = [
        "0=${base02}"
        "1=${base08}"
        "2=${base0B}"
        "3=${base0A}"
        "4=${base0D}"
        "5=${base17}"
        "6=${base0C}"
        "7=${base04}"
        "8=${base02}"
        "9=${base08}"
        "10=${base0B}"
        "11=${base0A}"
        "12=${base0D}"
        "13=${base17}"
        "14=${base0C}"
        "15=${base04}"
      ];
    };
  };
}
