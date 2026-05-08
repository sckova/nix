{
  description = "My NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    apple-silicon.url = "github:nix-community/nixos-apple-silicon";
    seamless-asahi-plymouth.url = "github:luca-schlecker/seamless-asahi-plymouth";
    steam-asahi.url = "github:sm-idk/steam-asahi";
    base16.url = "github:SenchoPens/base16.nix";

    tt-schemes = {
      url = "github:tinted-theming/schemes/b9f335ad6a0b7d85b9c2eb932c3215f7429f7d11";
      flake = false;
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:niri-wm/niri/v26.04";
      flake = false;
    };

    niri-flake = {
      url = "github:sckova/niri-flake/feat/blur";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.niri-unstable.follows = "niri";
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

    openmw = {
      url = "gitlab:OpenMW/openmw/openmw-51-rc2";
      flake = false;
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nix-cachyos-kernel,
      apple-silicon,
      seamless-asahi-plymouth,
      steam-asahi,
      ...
    }:
    let
      mkNixosSystem =
        {
          hostname,
          system,
          users ? [ ],
          extraModules ? [ ],
          extraSpecialArgs ? { },
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit hostname users inputs;
          }
          // extraSpecialArgs;
          modules = [
            ./system
            ./system/hosts/${hostname}
            ./hardware/${hostname}
            inputs.niri-flake.nixosModules.niri
            inputs.sops-nix.nixosModules.sops
            inputs.home-manager.nixosModules.home-manager
            inputs.noctalia.nixosModules.default
          ]
          ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        peach = mkNixosSystem {
          hostname = "peach";
          system = "aarch64-linux";
          users = [ "sckova" ];
          extraSpecialArgs = { inherit seamless-asahi-plymouth; };
          extraModules = [
            apple-silicon.nixosModules.default
            { nixpkgs.overlays = [ apple-silicon.overlays.apple-silicon-overlay ]; }
            steam-asahi.nixosModules.default
            {
              programs.steam-asahi.enable = true;
            }
          ];
        };
        alien = mkNixosSystem {
          hostname = "alien";
          system = "x86_64-linux";
          users = [
            "sckova"
            "ckovacs"
          ];
          extraModules = [
            {
              nixpkgs.overlays = [ nix-cachyos-kernel.overlays.pinned ];
            }
          ];
        };
      };
    };
}
