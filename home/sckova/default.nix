{
  lib,
  pkgs,
  isLinux,
  ...
}:
{
  imports = [
    ../../lib/sops.nix
    ./apps
    ./games
    ./terminal
    ./tiling/aerospace.nix
  ]
  ++ lib.optionals isLinux [
    ./services
    ./tiling
  ];

  # the user to activate
  name = "Sean Kovacs";
  username = "sckova";
  email = "kovacsmillio@gmail.com";

  sops.age.keyFile = "/home/sckova/.config/sops/age/keys.txt";
}
