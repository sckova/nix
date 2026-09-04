# flake.nix
{
  description = "unified nixos/nix-darwin/home-manager configuration for three systems";

  inputs = {
    apple-silicon.url = "github:nix-community/nixos-apple-silicon";
    base16.url = "github:SenchoPens/base16.nix";

    fh = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "https://flakehub.com/f/DeterminateSystems/fh/*";
    };

    firefox-gnome-theme = {
      flake = false;
      url = "github:rafaelmardojai/firefox-gnome-theme";
    };

    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };

    impermanence.url = "https://flakehub.com/f/nix-community/impermanence/*";
    # kernel-asahi = {
    #   flake = false;
    #   url = "github:AsahiLinux/linux/fairydust";
    # };
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    nix-darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:LnL7/nix-darwin";
    };

    nixpkgs.url = "https://flakehub.com/f/DeterminateSystems/nixpkgs-weekly/*";

    noctalia = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:noctalia-dev/noctalia/v5.0.1";
    };

    nur = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/NUR";
    };

    openmw = {
      flake = false;
      url = "gitlab:OpenMW/openmw";
    };

    paneru = {
      inputs = {
        nix-darwin.follows = "nix-darwin";
        nixpkgs.follows = "nixpkgs";
      };

      url = "github:karinushka/paneru/v0.4.4";
    };

    seamless-asahi-plymouth = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:luca-schlecker/seamless-asahi-plymouth";
    };

    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "https://flakehub.com/f/Mic92/sops-nix/*";
    };

    term = {
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };

      url = "github:sckova/term";
    };

    tt-schemes = {
      flake = false;
      url = "github:tinted-theming/schemes/b9f335ad6a0b7d85b9c2eb932c3215f7429f7d11";
    };
  };

  outputs =
    { nix-darwin, nixpkgs, ... }@inputs:
    {
      darwinConfigurations =
        builtins.mapAttrs
          (
            hostname:
            { users }:
            nix-darwin.lib.darwinSystem {
              modules = [ ./system/darwin.nix ];

              specialArgs = {
                inherit hostname users inputs;
                isLinux = false;
              };
            }
          )
          {
            skmbp.users = [ "sckova" ];
          };

      nixosConfigurations =
        builtins.mapAttrs
          (
            hostname:
            { users }:
            nixpkgs.lib.nixosSystem {
              modules = [ ./system ];

              specialArgs = {
                inherit hostname users inputs;
                isLinux = true;
              };
            }
          )
          {
            alien.users = [
              "sckova"
              "ckovacs"
            ];

            peach.users = [ "sckova" ];
          };
    };
}
