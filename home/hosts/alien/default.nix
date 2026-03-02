{
  config,
  pkgs,
  lib,
  pkgs-unstable,
  ...
}:
{
  colors = {
    scheme = "catppuccin-mocha";
    accent = "base0D";
  };

  home.packages = with pkgs; [
    pkgs-unstable.ckan

    spotify
    adwsteamgtk
    daggerfall-unity
    vintagestory
    gamemode
  ];

  programs.noctalia-shell.settings.brightness.enableDdcSupport = true;
  programs.noctalia-shell.settings.bar = {
    position = "top";
    density = "default";
  };
}
