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
  ]
  ++ lib.optional isLinux [
    ./tiling
    ./services
  ];

  # the user to activate
  userOptions = {
    name = "Sean Kovacs";
    username = "sckova";
    email = "kovacsmillio@gmail.com";
  };

  sops.age.keyFile = "/home/sckova/.config/sops/age/keys.txt";
}
