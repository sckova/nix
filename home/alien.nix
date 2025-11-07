{ config, pkgs, ... }:

{
  catppuccin = {
    accent = "mocha";
    flavor = "blue";
  };

  programs.plasma = {
    workspace = {
      colorScheme = "CatppuccinMochaBlue";
      cursor.theme = "catppuccin-mocha-blue-cursors";
      splashScreen.theme = "Catpppuccin-Mocha-Blue";
    };

  configFile = {
    kdeglobals.KDE = {
      DefaultDarkLookAndFeel = "Catppuccin-Mocha-Blue";
      DefaultLightLookAndFeel = "Catppuccin-Latte-Blue";
    };
  };
}
