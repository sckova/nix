# home/sckova/default.nix
{
  lib,
  inputs,
  isLinux,
  ...
}:
{
  imports =
    with inputs;
    [
      ../../lib/sops.nix
      ./apps
      ./games
      ./services/spotify.nix
      term.homeModules.default
    ]
    ++ lib.optionals isLinux [
      ./persistence.nix
      ./services
      ./tiling
    ]
    ++ lib.optionals (isLinux != true) [
      ./tiling/paneru.nix
    ];
}
