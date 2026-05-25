{
  description = "My NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    apple-silicon.url = "github:nix-community/nixos-apple-silicon";
    seamless-asahi-plymouth.url = "github:luca-schlecker/seamless-asahi-plymouth";
    steam-asahi.url = "github:sm-idk/steam-asahi";
    base16.url = "github:SenchoPens/base16.nix";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    noctalia.url = "github:noctalia-dev/noctalia-shell/v4.7.7";
    noctalia.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    tt-schemes.url = "github:tinted-theming/schemes/b9f335ad6a0b7d85b9c2eb932c3215f7429f7d11";
    tt-schemes.flake = false;
    niri.url = "github:niri-wm/niri/v26.04";
    niri.flake = false;
    openmw.url = "gitlab:OpenMW/openmw/openmw-51-rc2";
    openmw.flake = false;
  };
  outputs =
    { nixpkgs, nix-darwin, ... }@inputs:
    {
      nixosConfigurations =
        builtins.mapAttrs
          (
            hostname:
            { system, users }:
            nixpkgs.lib.nixosSystem {
              inherit system;
              specialArgs = {
                inherit hostname users inputs;
                isLinux = true;
              };
              modules = [ ./system ];
            }
          )
          {
            peach = {
              system = "aarch64-linux";
              users = [ "sckova" ];
            };
            alien = {
              system = "x86_64-linux";
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
            { system, users }:
            nix-darwin.lib.darwinSystem {
              inherit system;
              specialArgs = {
                inherit hostname users inputs;
                isLinux = false;
              };
              modules = [ ./system/darwin.nix ];
            }
          )
          {
            skmbp = {
              system = "aarch64-darwin";
              users = [ "sckova" ];
            };
          };
    };
}
