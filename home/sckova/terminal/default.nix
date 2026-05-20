{
  pkgs,
  ...
}:
{
  imports = [
    ./btop.nix
    ./fish.nix
    ./git.nix
    ./ghostty.nix
    ./neovim.nix
    ./ssh.nix
    ./ytfp.nix
  ];

  # cli utilities
  home.packages = with pkgs; [
    tmux
    fastfetch
    btop
    wget
    ripgrep
    ncdu
    wl-clipboard
    rclone
    gh
    eza
    pigz
  ];
}
