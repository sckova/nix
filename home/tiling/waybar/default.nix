{ config, pkgs, ... }:

let
  catppuccin-waybar = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "waybar";
    rev = "ee8ed32b4f63e9c417249c109818dcc05a2e25da";
    sha256 = "sha256-za0y6hcN2rvN6Xjf31xLRe4PP0YyHu2i454ZPjr+lWA=";
  };

  mergedConfig = pkgs.runCommand "mergedConfig" { } ''
    mkdir -p $out
    cp -rv ${./config}/* $out/
    cp -v ${catppuccin-waybar}/themes/${config.catppuccin.flavor}.css $out/colors.css
  '';
in
{
  programs.waybar = {
    enable = true;
  };

  home.file.".config/waybar" = {
    source = mergedConfig;
    recursive = true;
    force = true;
  };
}
