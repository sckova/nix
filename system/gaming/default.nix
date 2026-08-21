{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    mangohud
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

  services.ananicy = {
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
}
