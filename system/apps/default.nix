{
  pkgs,
  lib,
  users,
  ...
}:
{
  imports = [
    ./obs.nix
  ];

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
    niri.enable = true;
    niri.package = pkgs.niri-unstable;

    fish.enable = lib.mkIf (builtins.elem "sckova" users) true;
    zsh.enable = lib.mkIf (builtins.elem "ckovacs" users) true;

    gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "--expose-wayland"
        "--fullscreen"
      ];
    };
    gamemode.enable = true;
  };

  services = {
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-cpp;
      extraRules = [
        {
          "name" = "gamescope";
          "nice" = -20;
        }
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    git
    firefoxpwa
  ];
}
