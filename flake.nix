{
  description = "My NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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

    nixvim = {
      url = "github:nix-community/nixvim";
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
          specialArgs = { inherit catppuccin; };
          modules = [
            {
              nixpkgs.overlays = [
                (import ./packages/strawberry/overlay.nix)
              ];
            }
            ./hosts/all.nix
            ./hosts/${hostname}.nix
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
            ./home/${hostname}.nix
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
      };
    };
}
