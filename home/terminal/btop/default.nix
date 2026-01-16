{
  config,
  pkgs,
  ...
}: let
  mergedConfig = pkgs.runCommand "mergedConfig" {} ''
    mkdir -p $out/themes
    ${pkgs.gnused}/bin/sed 's/blankFlavor/${config.catppuccin.flavor}/g' \
      ${./btop.conf} > $out/btop.conf
    cp ${pkgs.catppuccin-btop-git.src}/themes/catppuccin_latte.theme $out/themes/
    cp ${pkgs.catppuccin-btop-git.src}/themes/catppuccin_${config.catppuccin.flavor}.theme $out/themes/nixos.theme
  '';
in {
  home.file.".config/btop" = {
    source = mergedConfig;
    recursive = true;
  };
}
