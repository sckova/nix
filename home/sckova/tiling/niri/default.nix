# home/sckova/tiling/niri/default.nix
# since https://github.com/sodiboo/niri-flake doesn't currently
# have many of the latest options, we write this directly
# https://github.com/niri-wm/niri/wiki/
{
  config,
  lib,
  ...
}:
{
  imports = [
    ./binds.nix
    ./outputs.nix
    ./rules.nix
    ./settings.nix
  ];

  home = {
    # ensure include.kdl exists
    activation.ensureNiriInclude = lib.hm.dag.entryAfter [ "writeBoundary" ] /* bash */ ''
      target="${config.xdg.configHome}/niri/include.kdl"
      run mkdir -p "$(dirname "$target")"
      [ -e "$target" ] || run touch "$target"
    '';

    file = {
      ".config/niri/binds.kdl".enable = false;
      ".config/niri/outputs.kdl".enable = false;
      ".config/niri/rules.kdl".enable = false;
      ".config/niri/settings.kdl".enable = false;
    }
    // {
      ".config/niri/config.kdl".text = lib.concatLines (
        map (f: ''include "${f}"'') [
          config.home.file.".config/niri/binds.kdl".source
          config.home.file.".config/niri/outputs.kdl".source
          config.home.file.".config/niri/rules.kdl".source
          config.home.file.".config/niri/settings.kdl".source
          "include.kdl"
        ]
      );
    };
  };
}
