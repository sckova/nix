{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = with inputs; [
    nix-index-database.homeModules.default
    ./btop.nix
    ./fish.nix
    ./fastfetch.nix
    ./git.nix
    ./ghostty.nix
    ./neovim.nix
    ./ssh.nix
    ./ytfp.nix
    # ./vscode.nix
  ];

  home = {
    file.".gnupg/gpg-agent.conf".text = ''
      pinentry-program ${
        if pkgs.stdenv.isLinux then
          "${pkgs.pinentry-curses}/bin/pinentry-curses"
        else
          "${pkgs.pinentry_mac}/bin/pinentry-mac"
      }
    '';

    # cli utilities
    packages =
      with pkgs;
      [
        wget
        ncdu
        rclone
        pigz
        comma
        difftastic
        waypipe
        nixd
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        wl-clipboard
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
        gnupg
        pinentry_mac
      ];
  };

  programs = {
    eza = {
      enable = true;
      colors = "always";
      enableFishIntegration = true;
      git = true;
      icons = "auto";
    };

    fd.enable = true;
    ripgrep.enable = true;
    tmux.enable = true;
  };
}
