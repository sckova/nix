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
      noctalia.homeModules.default
      paneru.homeModules.paneru
      nix-index-database.homeModules.default
      spicetify-nix.homeManagerModules.spicetify
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

  networking.hostName = hostname;
  nix.linux-builder.enable = true; # allow aarch64-linux builds via lightweight VM

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = "aarch64-darwin";

    overlays = with inputs; [
      nur.overlays.default
      pedantix.overlays.default
      (import ../packages/overlay.nix inputs)
    ];
  };

  security.pam.services.sudo_local = {
    enable = true;
    reattach = true;
    touchIdAuth = true;
  };

  sops.age.keyFile = "/Users/sckova/.config/sops/age/keys.txt";
  system.stateVersion = 7;

  users.users = lib.genAttrs users (user: {
    home = "/Users/${user}";
  });
}
