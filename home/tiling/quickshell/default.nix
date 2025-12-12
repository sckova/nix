{ config, pkgs, ... }:

{
  home = {
    # packages = with pkgs; [ quickshell ];
    file.".config/quickshell" = {
      source = ./config;
      recursive = true;
    };
  };
  programs.quickshell = {
    enable = true;
  };
}
