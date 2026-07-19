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
      rclone_synology = { };
      searxng_secret = { };
    };
  };
}
