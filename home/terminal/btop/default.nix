{
  config,
  pkgs,
  ...
}: let
  catppuccin-btop = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "btop";
    rev = "f437574b600f1c6d932627050b15ff5153b58fa3";
    sha256 = "sha256-mEGZwScVPWGu+Vbtddc/sJ+mNdD2kKienGZVUcTSl+c=";
  };

  mergedConfig = pkgs.runCommand "mergedConfig" {} ''
    mkdir -p $out/themes
    ${pkgs.gnused}/bin/sed 's/blankFlavor/${config.catppuccin.flavor}/g' \
      ${./btop.conf} > $out/btop.conf
    cp ${catppuccin-btop}/themes/catppuccin_latte.theme $out/themes/
    cp ${catppuccin-btop}/themes/catppuccin_${config.catppuccin.flavor}.theme $out/themes/
  '';
in {
  home.file.".config/btop" = {
    source = mergedConfig;
    recursive = true;
  };
}
