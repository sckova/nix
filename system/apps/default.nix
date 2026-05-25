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

    niri = {
      enable = true;
      package = pkgs.niri.overrideAttrs (oldAttrs: rec {
        version = "26.04";

        src = pkgs.fetchFromGitHub {
          owner = "YaLTeR";
          repo = "niri";
          tag = "v${version}";
          hash = "sha256-ehSMsSpE+0k8r+2Vseu8kangsYxToZv3vinynsDp9zs=";
        };

        cargoHash = "sha256-gfnalA3qI3a9h3PvsxgQLCrzapfjLLkxhTMJpwRh+ro=";
      });
    };

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
