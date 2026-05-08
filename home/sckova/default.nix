{
  imports = [
    ../../lib/sops.nix
    ./apps
    ./games
    ./services
    ./terminal
    ./tiling
  ];

  # the user to activate
  userOptions = {
    name = "Sean Kovacs";
    username = "sckova";
    email = "kovacsmillio@gmail.com";
  };

  sops.age.keyFile = "/home/sckova/.config/sops/age/keys.txt";
}
