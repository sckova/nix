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
