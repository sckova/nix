# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  lib,
  pkgs,
  hostname,
  inputs,
  users,
  ...
}:
{
  imports = with inputs; [
    sops-nix.nixosModules.sops
    ../lib
    ./apps
    ./services
    ./networking
    ./hosts/${hostname}
    ../hardware
  ];

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}
