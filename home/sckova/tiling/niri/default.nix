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
  home = {
    # ensure include.kdl exists
    activation.ensureNiriInclude = lib.hm.dag.entryAfter [ "writeBoundary" ] /* bash */ ''
      target="${config.xdg.configHome}/niri/include.kdl"
      run mkdir -p "$(dirname "$target")"
      [ -e "$target" ] || run touch "$target"
    '';

    file.".config/niri/config.kdl".text = lib.hm.generators.toKDL { } (
      settings
      // {
        inherit binds;
        _children = outputs ++ rules;
      }
    );
  };
}
