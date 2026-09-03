# system/gaming/default.nix
{
  lib,
  hostname,
  ...
}:
{
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

      capSysNice = false;
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
