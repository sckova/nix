{
  description = "My NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
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

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kwin-effects-forceblur = {
      url = "github:taj-ny/kwin-effects-forceblur";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    compose2nix = {
      url = "github:aksiksi/compose2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      catppuccin,
      home-manager,
      plasma-manager,
      nur,
      nixvim,
      kwin-effects-forceblur,
      compose2nix,
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
            inputs = { inherit kwin-effects-forceblur compose2nix; };
          };
          modules = [
            {
              nixpkgs.overlays = [
                nur.overlays.default
                (import ./packages/overlay.nix)
              ];
            }
            ./system/all.nix
            ./system/browsers/firefox.nix
            ./system/shell/fish.nix
            ./system/tailscale/default.nix
            ./system/hosts/${hostname}/default.nix
            ./hardware/${hostname}.nix
            catppuccin.nixosModules.catppuccin
            home-manager.nixosModules.home-manager
            {
              home-manager.sharedModules = [
                plasma-manager.homeModules.plasma-manager
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
