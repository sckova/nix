{ pkgs, config, ... }:
{
  imports = [
    ./niri.nix
    ./noctalia.nix
    ./wallpaper.nix
  ];

  home.packages = with pkgs; [
    xdg-desktop-portal
    brightnessctl
    qt6Packages.qt6ct
    libsForQt5.qt5ct
    catppuccin-qt5ct
    xwayland-satellite
    playerctl
  ];

  programs.fuzzel = {
    enable = true;
    package = pkgs.fuzzel;
    settings = {
      main = {
        terminal = "${pkgs.kitty}/bin/kitty";
        layer = "overlay";
        font = with config.userOptions.fontMono; name + ":size=" + toString (size + 2);
        launch-prefix = "${pkgs.niri}/bin/niri msg action spawn --";
        icon-theme = config.gtk.iconTheme.name;
      };
      border = {
        width = 2;
        radius = 8;
      };
      colors = with config.scheme; {
        background = base00 + "E6";
        text = base05 + "E6";
        prompt = base04 + "E6";
        placeholder = base04 + "E6";
        input = base05 + "E6";
        match = config.scheme.withHashtag.${config.colors.accent} + "FF";
        selection = base04 + "E6";
        selection-text = base00 + "E6";
        counter = base04 + "E6";
        border = config.scheme.withHashtag.${config.colors.accent} + "FF";
      };
    };
  };

  programs.swaylock = with config.scheme; {
    enable = true;
    # package = pkgs.swaylock-effects;
    settings = {
      # this would sometimes load the previous day's wallpaper
      # when it is run before the bing retrieval script finishes
      # image = "~/.local/share/wallpaper/daily-colored.jpg";
      # effect-blur = "7x5";
      color = "000000"; # black
      font-size = 24;
      indicator-idle-visible = true;
      indicator-radius = 100;
      show-failed-attempts = true;

      bs-hl-color = base09 + "E6"; # peach
      caps-lock-bs-hl-color = base09 + "E6"; # peach
      caps-lock-key-hl-color = base0E + "E6"; # mauve
      inside-color = base00 + "E6"; # base
      inside-clear-color = base00 + "E6"; # base
      inside-caps-lock-color = base00 + "E6"; # base
      inside-ver-color = base00 + "E6"; # base
      inside-wrong-color = base00 + "E6"; # base
      key-hl-color = base0D + "E6"; # blue
      layout-bg-color = base00 + "E6"; # base
      layout-border-color = base00 + "E6"; # base
      layout-text-color = base05 + "E6"; # text
      line-color = base00 + "E6"; # base
      line-clear-color = base00 + "E6"; # base
      line-caps-lock-color = base00 + "E6"; # base
      line-ver-color = base00 + "E6"; # base
      line-wrong-color = base00 + "E6"; # base
      ring-color = base00 + "E6"; # base
      ring-clear-color = base09 + "E6"; # peach
      ring-caps-lock-color = base00 + "E6"; # base
      ring-ver-color = base0B + "E6"; # green
      ring-wrong-color = base00 + "E6"; # base
      separator-color = "00000000"; # transparent
      text-color = base05 + "E6"; # text
      text-clear-color = base09 + "E6"; # peach
      text-caps-lock-color = base0E + "E6"; # mauve
      text-ver-color = base05 + "E6"; # text
      text-wrong-color = base08 + "E6"; # red
    };
  };

  systemd.user.services.swaylock = {
    Unit = {
      After = [ "niri.service" ];
      PartOf = [ "niri.service" ];
      Description = "Screen locker";
      Documentation = "https://github.com/swaywm/swaylock";
    };

    Service = {
      ExecStart = "${config.programs.swaylock.package}/bin/swaylock";
      Restart = "on-failure";
    };

    Install.WantedBy = [ "niri.service" ];
  };

  xsession = {
    enable = true;
    windowManager.command = "niri";
  };
}
