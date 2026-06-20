# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  lib,
  pkgs,
  hostname,
  users,
  inputs,
  ...
}:
{
  imports = with inputs; [
    sops-nix.nixosModules.sops
    home-manager.nixosModules.home-manager
    noctalia.nixosModules.default
    ../lib/nix-settings.nix
    ../lib/users.nix
    ../lib/options.nix
    ../lib/sops.nix
    ./apps
    ./services
    ./networking
    ./hosts/${hostname}
    ../hardware
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = with inputs; [
    noctalia.overlays.default
    nur.overlays.default
    (import ../packages/overlay.nix inputs)
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit hostname inputs;
      isLinux = pkgs.stdenv.hostPlatform.isLinux;
    };

    users = lib.genAttrs users (user: {
      imports = [
        ../home
        ../home/${user}
        ../home/hosts/${hostname}
      ];
    });

    sharedModules = with inputs; [
      sops-nix.homeManagerModules.sops
      base16.homeManagerModule
      (
        { config, ... }:
        {
          scheme = "${tt-schemes}/base24/${config.colors.scheme}.yaml";
        }
      )
      noctalia.homeModules.default
      nixvim.homeModules.nixvim
      nix-index-database.homeModules.default
      spicetify-nix.homeManagerModules.spicetify
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}
