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
    ./services
    ./tiling
    ./persistence.nix
  ]
  ++ lib.optionals (isLinux != true) [
    ./tiling/paneru.nix
  ];
}
