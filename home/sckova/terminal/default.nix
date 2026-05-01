{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./btop.nix
    ./fish.nix
    ./ghostty.nix
    ./neovim.nix
    ./ytfp.nix
  ];

  home.packages = with pkgs; [
    # cli utilities
    tmux
    fastfetch
    btop
    wget
    ripgrep
    ncdu
    wl-clipboard
    rclone
    waypipe
    spotdl
    browsh
    mosh
    gh
    kdePackages.qttools
    eza
    pigz

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

    # formatters
    kdePackages.qtdeclarative
    prettier
    prettierd
    nixfmt
    stylua
    black
    clang-tools
  ];

  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = config.userOptions.name;
          email = config.userOptions.email;
        };
        core.pager = "${pkgs.bat}/bin/bat";
        commit.gpgsign = true;
        init.defaultBranch = "main";
      };
    };
    bat = {
      enable = true;
      config = {
        style = "numbers,changes";
        theme = "base16";
      };
    };
    lazygit = {
      enable = true;
      enableFishIntegration = true;
    };
    lazysql.enable = true;
    fzf = {
      enable = true;
      enableFishIntegration = true;
      defaultOptions = [
        "--height 40%"
        "--border"
      ];
      colors = with config.scheme.withHashtag; {
        bg = base00;
        "bg+" = base01;
        border = base03;
        fg = base05;
        "fg+" = base05;
        header = base08;
        hl = base08;
        "hl+" = base08;
        info = config.scheme.withHashtag.${config.colors.accent};
        label = base05;
        marker = base07;
        pointer = base06;
        prompt = config.scheme.withHashtag.${config.colors.accent};
        "selected-bg" = base02;
        spinner = base06;
      };
    };
  };
}
