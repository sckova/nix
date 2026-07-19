{
  lib,
  pkgs,
  users,
  ...
}:
{
  imports = [
    ./obs.nix
  ];

  environment.systemPackages = with pkgs; [
    git
    firefoxpwa
  ];

  programs = {
    gamemode.enable = true;

    gamescope = {
      enable = true;

      args = [
        "--expose-wayland"
        "--fullscreen"
      ];

      capSysNice = false;
    };
  };

  services = {
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;

      extraRules = [
        {
          "name" = "gamescope";
          "nice" = -20;
        }
      ];

      rulesProvider = pkgs.ananicy-cpp;
    };
  };
}
