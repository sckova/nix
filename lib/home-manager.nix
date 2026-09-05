# lib/home-manager.nix
{
  lib,
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
    };

    sharedModules = with inputs; [
      sops-nix.homeManagerModules.sops
      base16.homeManagerModule
      (
        { config, ... }:
        {
          scheme = "${tt-schemes}/base24/${config.colors.schemeName}.yaml";
        }
      )
      {
        nix.settings.experimental-features = [
          "nix-command"
          "flakes"
        ];
      }
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
