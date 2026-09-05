# home/sckova/apps/discord/default.nix
{
  pkgs,
  ...
}:
{
  imports = [
    ./settings.nix
  ];

  home.packages = with pkgs; [
    vesktop
  ];
}
