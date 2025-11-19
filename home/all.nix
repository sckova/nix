{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    vesktop
    gh
    adwsteamgtk
    prismlauncher
    tmux
    fastfetch
    btop
    killall
    wget
    ripgrep
    ncdu
    fzf
    wl-clipboard
    openmw
    nixfmt-rfc-style
    (chromium.override {
      enableWideVine = true;
    })
    strawberry-master
    spotify-player
    input-leap
    libreoffice-qt-fresh
    spotdl
    rclone
    helium-browser
    deno
    prettier
    prettierd

    kde-rounded-corners
    kdePackages.partitionmanager

    colloid-icon-theme
    (catppuccin-kde.override {
      flavour = [
        "latte"
        "mocha"
      ];
      accents = [
        "peach"
        "blue"
      ];
    })
  ];

  catppuccin = {
    enable = true;
    cursors.enable = true;
    cache.enable = true;
  };

  home.sessionVariables = {
    EDITOR = "code";
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
