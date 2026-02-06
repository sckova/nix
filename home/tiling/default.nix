{ pkgs, ... }:
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
