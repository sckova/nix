# home/sckova/tiling/default.nix
{
  pkgs,
  ...
}:
{
  imports = [
    ./kanshi.nix
    ./niri
    ./noctalia
    ./services.nix
    ./swaylock.nix
    ./vicinae.nix
    ./wallpaper.nix
  ];

  home.packages = with pkgs; [
    xdg-desktop-portal
    xwayland-satellite
  ];

  xsession = {
    enable = true;
    windowManager.command = "niri";
  };
}
