# since https://github.com/sodiboo/niri-flake doesn't currently
# have many of the latest options, we write this directly
# https://github.com/niri-wm/niri/wiki/
{
  config,
  lib,
  pkgs,
  hostname,
  ...
}:
let
  binds = import ./binds.nix { inherit config lib pkgs; };
  outputs = import ./outputs.nix { inherit lib hostname; };
  rules = import ./rules.nix;
  settings = import ./settings.nix { inherit config lib; };
in
{
  home.file.".config/niri/config.kdl".text = lib.hm.generators.toKDL { } (
    settings
    // {
      inherit binds;
      _children = outputs ++ rules;
    }
  );
}
