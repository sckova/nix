{
  pkgs,
  lib,
  isLinux,
  ...
}:
{
  imports = [
    ./btop.nix
    ./fish.nix
    ./fastfetch.nix
    ./git.nix
    ./ghostty.nix
    ./neovim.nix
    ./ssh.nix
    ./ytfp.nix
  ];

  # cli utilities
  home.packages =
    with pkgs;
    [
      wget
      ncdu
      rclone
      pigz
    ]
    ++ lib.optionals isLinux [
      wl-clipboard
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      gnupg
      pinentry_mac
    ];

  programs = {
    tmux.enable = true;
    ripgrep.enable = true;
    eza = {
      enable = true;
      enableFishIntegration = true;
      colors = "always";
      git = true;
      icons = "auto";
    };
  };

  home.file = lib.mkIf pkgs.stdenv.isDarwin {
    ".gnupkg/gpg-agent.conf".text = ''
      pinentry-program ${pkgs.pinentry_mac}/bin/pinentry-mac
    '';
  };
}
