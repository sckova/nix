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
      ./services
      ./tiling
    ]
    ++ lib.optionals (isLinux != true) [
      ./tiling/paneru.nix
    ];

  kovaterm = {
    email = "kovacsmillio@gmail.com";
    name = "Sean Kovacs";
  };
}
