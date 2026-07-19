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

  email = "kovacsmillio@gmail.com";
  # the user to activate
  name = "Sean Kovacs";
  sops.age.keyFile = "/home/sckova/.config/sops/age/keys.txt";
  username = "sckova";
}
