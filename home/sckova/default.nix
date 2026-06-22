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
  ]
  ++ lib.optionals (isLinux != true) [
    ./tiling/paneru.nix
  ];

  # the user to activate
  name = "Sean Kovacs";
  username = "sckova";
  email = "kovacsmillio@gmail.com";

  sops.age.keyFile = "/home/sckova/.config/sops/age/keys.txt";
}
