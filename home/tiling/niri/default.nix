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
        font = "Noto Sans:size=12"
        terminal = "kitty"
        icons-enabled = yes
        icon-theme = "${config.gtk.iconTheme.name}"
        layer = "overlay"
      '';
      force = true;
    };
    ".config/qt5ct" = {
      source = ./qt/qt5ct;
      recursive = true;
      force = true;
    };
    ".config/qt6ct" = {
      source = ./qt/qt6ct;
      recursive = true;
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

    # cursor theme handled in home/hosts/host.nix and in config.kdl

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  qt = {
    enable = true;
    # the following will be possible in NixOS 26.05
    # https://github.com/nix-community/home-manager/commit/f9d45d664ed06a11861d0ba29e34f390c07bf62e
    # until this flake is updated, it will use the configs as implemented above
    # qt5ctSettings = {
    #   Appearance = {
    #     style = "Breeze";
    #     icon_theme = config.gtk.iconTheme.name;
    #     standar_dialogs = "kde";
    #   };
    #   Fonts = {
    #     fixed = "\"NotoSansM Nerd Font Mono,12\"";
    #     general = "\"Noto Sans,12\"";
    #   };
    # };
    # qt6ctSettings = {
    #   Appearance = {
    #     style = "Breeze";
    #     icon_theme = config.gtk.iconTheme.name;
    #     standar_dialogs = "kde";
    #   };
    #   Fonts = {
    #     fixed = "\"NotoSansM Nerd Font Mono,12\"";
    #     general = "\"Noto Sans,12\"";
    #   };
    # };
  };

  # Cursor / icon env vars for GTK and Qt apps
  xsession = {
    enable = true; # only needed for session variable injection
    windowManager.command = "niri"; # launches niri directly
  };

}
