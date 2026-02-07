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
      };
      border = {
        width = 2;
        radius = 8;
      };
      colors = with config.scheme; {
        background = base00 + "ff";
        text = base05 + "ff";
        prompt = base04 + "ff";
        placeholder = base04 + "ff";
        input = base05 + "ff";
        match = base09 + "ff";
        selection = base04 + "ff";
        selection-text = base05 + "ff";
        counter = base04 + "ff";
        border = base09 + "ff";
      };
    };
  };

  xsession = {
    enable = true;
    windowManager.command = "niri";
  };

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "x-scheme-handler/http" = [ "librewolf.desktop" ];
      "x-scheme-handler/https" = [ "librewolf.desktop" ];
      "x-scheme-handler/discord" = [ "vesktop.desktop" ];
    };
    defaultApplications = {
      "x-scheme-handler/http" = [ "librewolf.desktop" ];
      "x-scheme-handler/https" = [ "librewolf.desktop" ];
      "x-scheme-handler/discord" = [ "vesktop.desktop" ];
    };
  };
}
