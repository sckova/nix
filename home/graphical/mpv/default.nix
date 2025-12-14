{ config, pkgs, ... }:

let
  catppuccin-mpv = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "mpv";
    rev = "08e90daf511eee2c10c98f0031b51bb9de240d60";
    sha256 = "sha256-oUheJNWk2R6gNEmkK8H6PWX0iofx2KMGDoFWtnr420A=";
  };

  mergedConfig = pkgs.runCommand "mergedConfig" { } ''
    mkdir -p $out
    ${pkgs.gnused}/bin/sed 's/#1e1e2e/#000000/g' \
      ${catppuccin-mpv}/themes/${config.catppuccin.flavor}/${config.catppuccin.accent}.conf \
      > $out/mpv.conf
  '';
in
{
  home.packages = with pkgs; [
    (mpv.override {
      scripts = with mpvScripts; [
        uosc
        sponsorblock
        mpris
      ];
    })
  ];
  home.file.".config/mpv" = {
    source = mergedConfig;
    recursive = true;
    force = true;
  };
}
