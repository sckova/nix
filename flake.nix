{
  description = "unified nixos/nix-darwin/home-manager configuration for three systems";

  inputs = {
    # aerothemeplasma = {
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   url = "github:nyakase/aerothemeplasma-nix";
    # };
    apple-silicon = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nixos-apple-silicon/release-2026-07-30";
    };

    arnis = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:louis-e/arnis";
    };

    base16.url = "github:SenchoPens/base16.nix";

    firefox-gnome-theme = {
      flake = false;
      url = "github:rafaelmardojai/firefox-gnome-theme";
    };

    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-26.05";
    };

    impermanence.url = "github:nix-community/impermanence";

    kernel-asahi = {
      flake = false;
      url = "github:AsahiLinux/linux/fairydust";
    };

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    nix-darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:LnL7/nix-darwin/nix-darwin-26.05";
    };

    nix-index-database = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nix-index-database";
    };

    nixpkgs.url = "https://flakehub.com/f/DeterminateSystems/nixpkgs-26.05-chilled/*";
    nixpkgs-unstable.url = "https://flakehub.com/f/DeterminateSystems/nixpkgs-weekly/*";

    nixvim = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nixvim/nixos-26.05";
    };

    noctalia = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:noctalia-dev/noctalia/v5.0.0-beta.8";
    };

    nox = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:madsbv/nix-options-search";
    };

    nur = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/NUR";
    };

    openmw = {
      flake = false;
      url = "gitlab:OpenMW/openmw/stable";
    };

    paneru = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:karinushka/paneru";
    };

    pedantix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:swarsel/pedantix";
    };

    seamless-asahi-plymouth = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:luca-schlecker/seamless-asahi-plymouth";
    };

    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Mic92/sops-nix";
    };

    spicetify-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Gerg-L/spicetify-nix";
    };

    steam-asahi.url = "github:sm-idk/steam-asahi";

    thunderbird-gnome-theme = {
      flake = false;
      url = "github:rafaelmardojai/thunderbird-gnome-theme";
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
