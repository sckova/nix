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
    brightnessctl
    qt6Packages.qt6ct
    libsForQt5.qt5ct
    catppuccin-qt5ct
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
        include = /home/sckova/.config/fuzzel/colors.ini
        font = "NotoSansM Nerd Font Mono:size=10"
        terminal = "kitty"
        icons-enabled = yes
        layer = "overlay"
      '';
      force = true;
    };
  };

  gtk = {
    enable = true;

    # theme = {
    #   name = "adw-gtk3-dark";
    #   package = pkgs.adw-gtk3;
    # };

    iconTheme = {
      name = "Colloid-Dark";
      package = pkgs.colloid-icon-theme;
    };

    # cursor theme handled in home/hosts/host.nix

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  qt.enable = true;

  # Cursor / icon env vars for GTK and Qt apps
  xsession = {
    enable = true; # only needed for session variable injection
    windowManager.command = "niri"; # launches niri directly
  };

  home.sessionVariables = {
    XCURSOR_SIZE = "24";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_QPA_PLATFORMTHEME_5 = "qt5ct";
  };

}
