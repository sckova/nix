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
    strawberry
    spotify-player
    input-leap
    libreoffice-qt-fresh
    spotdl
    rclone
    helium-browser
    deno
    prettier
    prettierd
    musescore
    mpv
    gimp

    jdk21_headless

    kde-rounded-corners
    kdePackages.partitionmanager

    colloid-icon-theme
  ];

  services = {
    spotifyd = {
      enable = true;
      settings = {
        global = {
          device_type = "computer";
          dbus_type = "session";
          disable_discovery = true;
          use_mpris = true;
          bitrate = 320;
          initial_volume = 100;
          volume_normalisation = true;
          normalisation_pregain = -10;
        };
      };
    };
  };

  catppuccin = {
    enable = true;
    cursors.enable = false;
    cache.enable = true;
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
