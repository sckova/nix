{
  config,
  pkgs,
  ...
}:
{
  programs.swaylock = with config.scheme; {
    enable = true;
    package = pkgs.swaylock-effects;

    settings = {
      bs-hl-color = base09 + "E6"; # peach
      caps-lock-bs-hl-color = base09 + "E6"; # peach
      caps-lock-key-hl-color = base0E + "E6"; # mauve
      color = "000000"; # black
      effect-blur = "7x5";
      font-size = 24;
      image = "${config.home.homeDirectory}/.local/share/wallpaper/daily-colored.jpg";
      indicator-idle-visible = true;
      indicator-radius = 100;
      inside-caps-lock-color = base00 + "E6"; # base
      inside-clear-color = base00 + "E6"; # base
      inside-color = base00 + "E6"; # base
      inside-ver-color = base00 + "E6"; # base
      inside-wrong-color = base00 + "E6"; # base
      key-hl-color = base0D + "E6"; # blue
      layout-bg-color = base00 + "E6"; # base
      layout-border-color = base00 + "E6"; # base
      layout-text-color = base05 + "E6"; # text
      line-caps-lock-color = base00 + "E6"; # base
      line-clear-color = base00 + "E6"; # base
      line-color = base00 + "E6"; # base
      line-ver-color = base00 + "E6"; # base
      line-wrong-color = base00 + "E6"; # base
      ring-caps-lock-color = base00 + "E6"; # base
      ring-clear-color = base09 + "E6"; # peach
      ring-color = base00 + "E6"; # base
      ring-ver-color = base0B + "E6"; # green
      ring-wrong-color = base00 + "E6"; # base
      separator-color = "00000000"; # transparent
      show-failed-attempts = true;
      text-caps-lock-color = base0E + "E6"; # mauve
      text-clear-color = base09 + "E6"; # peach
      text-color = base05 + "E6"; # text
      text-ver-color = base05 + "E6"; # text
      text-wrong-color = base08 + "E6"; # red
    };
  };

}
