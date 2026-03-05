{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./btop.nix
    ./fish.nix
    ./kitty.nix
    ./neovim.nix
  ];

  home.packages = with pkgs; [
    # cli utilities
    tmux
    fastfetch
    btop
    wget
    ripgrep
    ncdu
    fzf
    wl-clipboard
    rclone
    waypipe
    spotdl
    browsh
    mosh
    gh

    # development & tooling
    jdk21_headless
    quickemu
    nerd-fonts.noto
    noto-fonts
    noto-fonts-color-emoji
    nix-prefetch
    prowlarr
    radarr
    sonarr
    flaresolverr
    nerd-fonts.fira-mono
    ffmpeg-full
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = config.userOptions.name;
        email = config.userOptions.email;
      };
      core.pager = "${pkgs.bat}/bin/bat";
      commit.gpgsign = true;
    };
  };
}
