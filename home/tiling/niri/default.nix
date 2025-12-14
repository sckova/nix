{ config, pkgs, ... }:

let
  catppuccin-fuzzel = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "fuzzel";
    rev = "0af0e26901b60ada4b20522df739f032797b07c3";
    sha256 = "sha256-XpItMGsYq4XvLT+7OJ9YRILfd/9RG1GMuO6J4hSGepg=";
  };
in
{
  home.packages = with pkgs; [
    xdg-desktop-portal
    brightnessctl
    qt6Packages.qt6ct
    libsForQt5.qt5ct
    catppuccin-qt5ct
    xwayland-satellite
  ];

  home.file = {
    ".config/niri/scripts" = {
      source = ./scripts;
      recursive = true;
      force = true;
    };
  };

  xsession = {
    enable = true;
    windowManager.command = "niri";
  };
}
