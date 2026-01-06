{
  description = "My NixOS Configuration";

  inputs = {
    # https://github.com/NixOS/nixpkgs/issues/476669
    nixpkgs.url = "github:NixOS/nixpkgs/pull/476347/head";

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel";

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

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
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
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nix-cachyos-kernel,
    catppuccin,
    catppuccin-palette,
    home-manager,
    plasma-manager,
    niri,
    noctalia,
    spicetify-nix,
    nur,
    nixvim,
    apple-silicon,
    ...
  }: let
    # All systems we want to support for the generic VM
    supportedSystems = ["x86_64-linux" "aarch64-linux"];
    # to run the vm:
    # nixos-rebuild build-vm --flake ~/nix#$(nix eval --raw --impure --expr 'builtins.currentSystem')
    mkNixosSystem = {
      hostname,
      system,
      extraModules ? [],
      extraSpecialArgs ? {},
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs =
          {
            inherit catppuccin system;
          }
          // extraSpecialArgs;
        modules =
          [
            {
              nixpkgs.overlays = [
                catppuccin-palette.overlays.default
                niri.overlays.niri
                noctalia.overlays.default
                nur.overlays.default
                (import ./packages/overlay.nix)
              ];
            }
            ./system
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
                spicetify-nix.homeManagerModules.default
                nixvim.homeModules.nixvim
              ];
              home-manager.extraSpecialArgs = {
                inherit spicetify-nix;
              };
            }
          ]
          ++ extraModules;
      };

    mkHomeConfig = {
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
          ./home
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
      nixosConfigurations =
        {
          peach = mkNixosSystem {
            hostname = "peach";
            system = "aarch64-linux";
            extraModules = [
              apple-silicon.nixosModules.default
              {nixpkgs.overlays = [apple-silicon.overlays.apple-silicon-overlay];}
            ];
          };

          alien = mkNixosSystem {
            hostname = "alien";
            system = "x86_64-linux";
            extraSpecialArgs = {
              inherit nix-cachyos-kernel;
            };
          };
        }
        // nixpkgs.lib.genAttrs supportedSystems (
          system:
            mkNixosSystem {
              hostname = "vm-generic";
              inherit system;
            }
        );

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
    }
    // nixpkgs.lib.genAttrs supportedSystems (
      system:
        mkHomeConfig {
          user = "sckova";
          hostname = "vm-generic";
          inherit system;
        }
    );
}
