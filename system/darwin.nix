{
  pkgs,
  lib,
  inputs,
  users,
  hostname,
  ...
}:
{
  imports = with inputs; [
    sops-nix.darwinModules.sops
    home-manager.darwinModules.home-manager
    ../lib/nix-settings.nix
    ../lib/users.nix
    ../lib/options.nix
    ../lib/sops.nix
    # ./apps (has nothing relevant)
    # ./services (has nothing relevant, TODO: figure out searxng for user-level?)
    # ./networking (see https://github.com/nix-darwin/nix-darwin/issues/1035)
  ];

  users.users = lib.genAttrs users (user: {
    home = "/Users/${user}";
  });

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
    overlays = with inputs; [
      nur.overlays.default
      (import ../packages/overlay.nix inputs)
    ];
  };

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
    ];
  };

  security.pam.services.sudo_local = {
    enable = true;
    reattach = true;
    touchIdAuth = true;
  };
  networking.hostName = hostname;

  sops.age.keyFile = "/Users/sckova/.config/sops/age/keys.txt";
  system.stateVersion = 7;
}
