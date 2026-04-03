{
  config,
  lib,
  pkgs,
  ...
}:
{
  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    secrets = {
      searxng_secret = { };
      rclone_synology = { };
    };
  };
}
