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

  home.file = lib.mkIf pkgs.stdenv.isDarwin {
    ".gnupkg/gpg-agent.conf".text = ''
      pinentry-program ${pkgs.pinentry_mac}/bin/pinentry-mac
    '';
  };
}
