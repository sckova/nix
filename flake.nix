{
  description = "My NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin-palette = {
      url = "github:abhinandh-s/catppuccin-nix";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon/linux-6-17-11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      catppuccin,
      catppuccin-palette,
      home-manager,
      plasma-manager,
      niri,
      noctalia,
      nur,
      nixvim,
      apple-silicon,
      ...
    }:
    let
      mkNixosSystem =
        {
          hostname,
          system,
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit catppuccin;
          };
          modules = [
            {
              nixpkgs.overlays = [
                catppuccin-palette.overlays.default
                niri.overlays.niri
                noctalia.overlays.default
                nur.overlays.default
                (import ./packages/overlay.nix)
              ];
            }
            ./system/all.nix
            ./system/widevine
            ./system/shell/fish.nix
            ./system/tailscale
            ./system/hosts/${hostname}
            ./hardware/${hostname}
            catppuccin.nixosModules.catppuccin
            home-manager.nixosModules.home-manager
            noctalia.nixosModules.default
            {
              home-manager.sharedModules = [
                plasma-manager.homeModules.plasma-manager
                niri.homeModules.niri
                noctalia.homeModules.default
                nixvim.homeModules.nixvim
              ];
            }
          ]
          ++ extraModules;
        };

      mkHomeConfig =
        {
          user,
          hostname,
          system,
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
          };
          home.username = user;
          home.homeDirectory = "/home/${user}";
          modules = [
            ./home/all.nix
            ./home/hosts/${hostname}.nix
            catppuccin.homeModules.catppuccin
            home-manager.homeModules.home-manager
            plasma-manager.homeModules.plasma-manager
            niri.homeModules.default
            noctalia.homeModules.noctalia
            nixvim.homeModules.nixvim
          ];
        };
    in
    {
      nixosConfigurations = {
        peach = mkNixosSystem {
          hostname = "peach";
          system = "aarch64-linux";
          extraModules = [
            apple-silicon.nixosModules.default
            { nixpkgs.overlays = [ apple-silicon.overlays.apple-silicon-overlay ]; }
          ];
        };

        alien = mkNixosSystem {
          hostname = "alien";
          system = "x86_64-linux";
        };

        vm-aarch64 = mkNixosSystem {
          hostname = "vm-aarch64";
          system = "aarch64-linux";
        };
      };

      homeConfigurations = {
        peach = mkHomeConfig {
          user = "sckova";
          hostname = "peach";
          system = "aarch64-linux";
        };
        alien = mkHomeConfig {
          user = "sckova";
          hostname = "alien";
          system = "x86_64-linux";
        };
        vm-aarch64 = mkHomeConfig {
          user = "sckova";
          hostname = "vm-aarch64";
          system = "aarch64-linux";
        };
      };
    };
}
