{
  description = "unified nixos/nix-darwin/home-manager configuration for three systems";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-26.05";
    };

    apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
    };
    seamless-asahi-plymouth = {
      url = "github:luca-schlecker/seamless-asahi-plymouth";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia/main";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    aerothemeplasma = {
      url = "github:nyakase/aerothemeplasma-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
    };

    base16 = {
      url = "github:SenchoPens/base16.nix";
    };
    tt-schemes = {
      url = "github:tinted-theming/schemes/b9f335ad6a0b7d85b9c2eb932c3215f7429f7d11";
      flake = false;
    };

    openmw = {
      url = "gitlab:OpenMW/openmw/openmw-51-rc2";
      flake = false;
    };
  };
  outputs =
    { nixpkgs, nix-darwin, ... }@inputs:
    {
      nixosConfigurations =
        builtins.mapAttrs
          (
            hostname:
            { users }:
            nixpkgs.lib.nixosSystem {
              specialArgs = {
                inherit hostname users inputs;
                isLinux = true;
              };
              modules = [ ./system ];
            }
          )
          {
            peach = {
              users = [ "sckova" ];
            };
            alien = {
              users = [
                "sckova"
                "ckovacs"
              ];
            };
          };
      darwinConfigurations =
        builtins.mapAttrs
          (
            hostname:
            { users }:
            nix-darwin.lib.darwinSystem {
              specialArgs = {
                inherit hostname users inputs;
                isLinux = false;
              };
              modules = [ ./system/darwin.nix ];
            }
          )
          {
            skmbp = {
              users = [ "sckova" ];
            };
          };
    };
}
