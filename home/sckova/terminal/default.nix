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
    ./neovim
    ./ssh.nix
    ./ytfp.nix
    # ./vscode.nix
  ];

  home = {
    file.".gnupg/gpg-agent.conf".text = ''
      pinentry-program ${
        if pkgs.stdenv.hostPlatform.isLinux then
          "${pkgs.pinentry-curses}/bin/pinentry-curses"
        else
          "${pkgs.pinentry_mac}/bin/pinentry-mac"
      }
    '';

    # cli utilities
    packages =
      with pkgs;
      [
        comma
        difftastic
        ffmpeg
        jq
        ncdu
        nixd
        pigz
        rclone
        rsync
        wget
      ]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        fh # build is currently broken in darwin
        waypipe
        wl-clipboard
      ]
      # most of these are to provide up-to-date versions of system utils
      ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
        coreutils
        curl
        findutils
        gawk
        gnugrep
        gnupg
        gnused
        gnutar
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
