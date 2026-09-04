# home/sckova/default.nix
{
  lib,
  isLinux,
  ...
}:
{
  imports = [
    ../../lib/sops.nix
    ./apps
    ./games
    ./services/spotify.nix
    ./terminal
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
