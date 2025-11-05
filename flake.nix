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

    apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, catppuccin, home-manager, apple-silicon, ... }:
    let
      mkNixosSystem = { name, system, hostModule, extraModules ? [] }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit catppuccin; };
          modules = [
            ./configuration.nix
            hostModule
            catppuccin.nixosModules.catppuccin
            home-manager.nixosModules.home-manager
          ] ++ extraModules;
        };

      mkHomeConfig = { user, system }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          modules = [
            ./home.nix
            catppuccin.homeModules.catppuccin
          ];
        };
    in
    {
      nixosConfigurations = {
        peach = mkNixosSystem {
          name = "peach";
          system = "aarch64-linux";
          hostModule = ./hosts/peach.nix;
          extraModules = [
            apple-silicon.nixosModules.default
            { nixpkgs.overlays = [ apple-silicon.overlays.apple-silicon-overlay ]; }
          ];
        };

        alien = mkNixosSystem {
          name = "alien";
          system = "x86_64-linux";
          hostModule = ./hosts/alien.nix;
        };
      };

      homeConfigurations = {
        peach = mkHomeConfig { user = "sckova"; system = "aarch64-linux"; };
        alien = mkHomeConfig { user = "sckova"; system = "x86_64-linux"; };
      };
    };
}

