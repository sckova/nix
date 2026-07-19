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
    with inputs;
    if isLinux then
      [
        home-manager.nixosModules.home-manager
      ]
    else
      [
        home-manager.darwinModules.home-manager
      ];

  home-manager = {
    extraSpecialArgs = {
      inherit hostname inputs;
      isLinux = pkgs.stdenv.hostPlatform.isLinux;
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
