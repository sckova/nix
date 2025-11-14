{ config, pkgs, ... }:

let
  catppuccin-btop = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "btop";
    rev = "f437574b600f1c6d932627050b15ff5153b58fa3";
    sha256 = "sha256-mEGZwScVPWGu+Vbtddc/sJ+mNdD2kKienGZVUcTSl+c=";
  };

  mergedConfig = pkgs.runCommand "mergedConfig" { } ''
    mkdir -p $out/themes
    cp ${./btop.conf} $out/btop.conf
    cp ${catppuccin-btop}/themes/catppuccin_latte.theme     $out/themes/
    cp ${catppuccin-btop}/themes/catppuccin_frappe.theme    $out/themes/
    cp ${catppuccin-btop}/themes/catppuccin_macchiato.theme $out/themes/
    cp ${catppuccin-btop}/themes/catppuccin_mocha.theme     $out/themes/
  '';
in
{
  home.file.".config/btop" = {
    source = mergedConfig;
    recursive = true;
  };
}
