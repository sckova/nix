# lib/home-manager.nix
{
  lib,
  pkgs,
  hostname,
  inputs,
  isLinux,
  users,
  ...
}:
{
  imports =
    with inputs.home-manager;
    if isLinux then [ nixosModules.home-manager ] else [ darwinModules.home-manager ];

  home-manager = {
    extraSpecialArgs = {
      inherit hostname inputs isLinux;

      pkgs-unstable = import inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        system = pkgs.stdenv.hostPlatform.system;
      };
    };

    sharedModules = with inputs; [
      sops-nix.homeManagerModules.sops
      base16.homeManagerModule
      (
        { config, ... }:
        {
          scheme = "${tt-schemes}/base24/${config.colors.scheme}.yaml";
        }
      )
    ];

    useGlobalPkgs = true;
    useUserPackages = true;

    users = lib.genAttrs users (user: {
      imports = [
        ../home
        ../home/${user}
        ../home/hosts/${hostname}
      ];
    });
  };
}
