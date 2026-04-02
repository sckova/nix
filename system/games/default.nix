{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs = {
    gamescope = {
      enable = true;
      capSysNice = false;
      args = [
        "--output-width 3840"
        "--nested-width 3840"
        "--output-height 2160"
        "--nested-height 2160"
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
}
