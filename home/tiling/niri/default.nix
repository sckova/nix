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
    swaylock
    fuzzel
    xdg-desktop-portal
  ];

  home.file = {
    ".config/niri" = {
      source = ./config;
      recursive = true;
      force = true;
    };
    ".config/fuzzel/colors.ini" = {
      text = builtins.readFile (
        "${catppuccin-fuzzel}/themes/catppuccin-${config.catppuccin.flavor}/${config.catppuccin.accent}.ini"
      );
      force = true;
    };
    ".config/fuzzel/fuzzel.ini" = {
      text = ''
        include = ./colors.ini
        font = "NotoSansM Nerd Font Mono:size=10"
        terminal = "kitty"
        icons-enabled = yes
        layer = "overlay"
      '';
      force = true;
    };
  };
}
