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

  home.file.".gnupg/gpg-agent.conf".text = ''
    pinentry-program ${
      if isLinux then
        "${pkgs.pinentry-curses}/bin/pinentry-curses"
      else
        "${pkgs.pinentry_mac}/bin/pinentry-mac"
    }
  '';
}
