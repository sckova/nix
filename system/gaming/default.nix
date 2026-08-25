# system/gaming/default.nix
{
  lib,
  pkgs,
  hostname,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    mangohud
  ];

  programs = {
    gamemode = {
      enable = true;
    }
    // lib.optionalAttrs (hostname == "alien") {
      settings.gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        nv_powermizer_mode = 1;
      };
    };

    gamescope = {
      enable = true;

      args = [
        "--expose-wayland"
        "--fullscreen"
      ];

      capSysNice = true;
    };
  };

  # services.ananicy = {
  #   enable = true;
  #   package = pkgs.ananicy-cpp;

  #   extraRules = [
  #     {
  #       "name" = "gamescope";
  #       "nice" = -20;
  #     }
  #   ];

  #   rulesProvider = pkgs.ananicy-cpp;
  # };
}
