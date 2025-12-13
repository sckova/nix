{
  description = "My NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/8bb5646e0bed5dbd3ab08c7a7cc15b75ab4e1d0f";

    catppuccin = {
      url = "github:catppuccin/nix/a696fed6b9b6aa89ef495842cdca3fc2a7cef0de";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin-palette = {
      url = "github:abhinandh-s/catppuccin-nix/b482f6e3ee1ae61c83e52f50653e54bf72900b13";
    };

    home-manager = {
      url = "github:nix-community/home-manager/e1680d594a9281651cbf7d126941a8c8e2396183";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager/b24ed4b272256dfc1cc2291f89a9821d5f9e14b4";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    niri = {
      url = "github:sodiboo/niri-flake/46e723aa46565b67910187b4b7ad48b615d7f576";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/6b2661e1d4d0e223d631be87931029929431de6f";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR/156e6d0e026c1a7687a74c908ee0ccf0df796f72";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/64d9e2616f4ee2acee380d61ccf1f3d610e7e969";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon/73b7103c4e3996e3e20868d510b0e8797f279323";
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
                noctalia.overlays.default
                nur.overlays.default
                (import ./packages/overlay.nix)
              ];
            }
            ./system/all.nix
            ./system/shell/fish.nix
            ./system/tailscale/default.nix
            ./system/hosts/${hostname}/default.nix
            ./hardware/${hostname}.nix
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
