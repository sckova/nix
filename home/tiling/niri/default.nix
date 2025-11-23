{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    swaylock
    fuzzel
    xdg-desktop-portal
  ];

  home.file.".config/niri" = {
    source = ./config;
    recursive = true;
    force = true;
  };
}
