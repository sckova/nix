# lib/sops.nix
{
  inputs,
  isLinux,
  ...
}:
{
  # since this file is pulled both systemwide and into homem-manager,
  # we can't import sops-nix here
  imports = with inputs; [ ];

  sops = {
    age.keyFile =
      if isLinux then
        "/home/sckova/.config/sops/age/keys.txt"
      else
        "/Users/sckova/.config/sops/age/keys.txt";

    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    secrets = {
      rclone_synology = { };
      searxng_secret = { };
    };
  };
}
