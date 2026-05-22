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
      tmux
      fastfetch
      wget
      ripgrep
      ncdu
      rclone
      gh
      eza
      pigz
    ]
    ++ lib.optionals isLinux [
      wl-clipboard
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      gnupg
      pinentry_mac
    ];

  home.file.".gnupg/gpg-agent.conf".text = lib.mkIf pkgs.stdenv.isDarwin ''
    pinentry-program ${pkgs.pinentry_mac}/bin/pinentry-mac
  '';
}
