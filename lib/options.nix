# lib/options.nix
{
  lib,
  ...
}:
{
  options.colors = {
    accent = lib.mkOption {
      default = "base09";
      type = lib.types.str;
    };

    scheme = lib.mkOption {
      default = "catppuccin-mocha";
      type = lib.types.str;
    };
  };
}
