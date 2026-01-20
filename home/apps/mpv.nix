{
  config,
  pkgs,
  ...
}:
let
  mergedConfig = pkgs.runCommand "mergedConfig" { } ''
    mkdir -p $out
    ${pkgs.gnused}/bin/sed 's/${pkgs.catppuccin.${config.catppuccin.flavor}.base}/#000000/g' \
      ${pkgs.catppuccin-mpv-git}/themes/${config.catppuccin.flavor}/${config.catppuccin.accent}.conf \
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
