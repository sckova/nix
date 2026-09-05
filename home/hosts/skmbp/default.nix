# home/hosts/skmbp/default.nix
{
  lib,
  options,
  ...
}:
lib.mkMerge [
  (lib.optionalAttrs (options ? colors) {
    colors = {
      accent = "base0E";
      schemeName = "catppuccin-mocha";
    };
  })
  {

  }
]
