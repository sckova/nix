{
  description = "My NixOS Configuration";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # edit this to switch between stable and unstable
    nixpkgs.follows = "nixpkgs-unstable";

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    apple-silicon.url = "github:nix-community/nixos-apple-silicon";
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
      url = "github:sckova/niri-flake/feat/blur";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
      inputs.niri-unstable.follows = "niri-blur";
    };

    niri-blur = {
      url = "github:niri-wm/niri/wip/branch";
      flake = false;
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
      url = "gitlab:OpenMW/openmw/01bcd6";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      nix-cachyos-kernel,
      apple-silicon,
      base16,
      tt-schemes,
      sops-nix,
      home-manager,
      niri,
      noctalia,
      nur,
      nixvim,
      openmw,
      ...
    }:
    let
      # Shared config for all package sets
      pkgConfig = {
        allowUnfree = true;
      };

      mkNixosSystem =
        {
          hostname,
          system,
          extraModules ? [ ],
          extraSpecialArgs ? { },
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit system;
            pkgs-unstable = import nixpkgs-unstable {
              inherit system;
              config = pkgConfig;
            };
          }
          // extraSpecialArgs;
          modules = [
            {
              nixpkgs = {
                config = pkgConfig;
                overlays = [
                  niri.overlays.niri
                  noctalia.overlays.default
                  nur.overlays.default
                  (final: prev: {
                    openmw-git = openmw;
                  })
                  (import ./packages/overlay.nix)
                ];
              };
              nix = {
                settings = {
                  experimental-features = [
                    "nix-command"
                    "flakes"
                  ];

                  substituters = [
                    "https://attic.xuyh0120.win/lantian"
                    "https://cache.garnix.io"
                    "https://nixos-apple-silicon.cachix.org"
                  ];

                  trusted-public-keys = [
                    "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
                    "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
                    "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
                  ];

                  trusted-users = [
                    "root"
                    "sckova"
                  ];
                };

                gc = {
                  automatic = true;
                  dates = "weekly";
                  options = "--delete-older-than 30d";
                };
              };

              networking.hostName = hostname;

              users.users.sckova = {
                isNormalUser = true;
                description = "Sean Kovacs";
                extraGroups = [
                  "wheel"
                  "networkmanager"
                  "podman"
                  "pipewire"
                ];
                openssh.authorizedKeys.keys = [
                  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCn/eXMq04vcXNqGVzlZOw2C2dQYBqzWsoigdFW09XqC2WPaGljbAIayzaD7Q1tIlPGGy10+nipAXAk1CHAnrQ2KSg4v/SwFphF48V3joeQmideC4vo0EIQEQibbMtj3oFezqRcRZINl/1hr4t0myZ3zkoTjh3HCkqJEMGUdArDMEVPA5mwcKSLsyshW9LMG/3C9YKKPU1/lVsoeDkj8AVZA0srhkApuRKF0IVu8KoPd6ldvSWgpQ1iuQ+MEMSeOUJytieBkzeY9zEVePaQ86oIMDUzqq8OTN37RyShiJKPskKyj12rJI2eFtI/viGaj8P6/yvKqMp3F4kAsPAuvMLLAIYCNa+139rDpkkIKB6lVtgq0jnJGRywaYXGIRyExNcVAr8I9wrNnNN2M4whVeYBxfLMzKZ+VvfK39AaGvnzPuFDLqUC87sN4c/1KZQo+TCtlaxcYvqowWylw5JHUt8uwFcO/dUebQxxAv8EdyPZGJ/54y19PsTbu9KyxSc2gIU= sckova"
                ];
              };
            }
            ./options.nix
            ./sops.nix
            ./system
            ./system/searxng
            ./system/games
            ./system/widevine
            ./system/shell/fish.nix
            ./system/tailscale
            ./system/hosts/${hostname}
            ./hardware/${hostname}
            niri.nixosModules.niri
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.sckova = {
                  imports = [
                    ./home
                    ./options.nix
                    ./sops.nix
                    ./home/sckova
                    ./home/sckova/apps
                    ./home/sckova/games
                    ./home/sckova/hosts/${hostname}
                    ./home/sckova/services
                    ./home/sckova/terminal
                    ./home/sckova/tiling
                  ];
                };
                sharedModules = [
                  sops-nix.homeManagerModules.sops
                  base16.nixosModule
                  (
                    { config, ... }:
                    {
                      scheme = "${tt-schemes}/base24/${config.colors.scheme}.yaml";
                    }
                  )
                  noctalia.homeModules.default
                  nixvim.homeModules.nixvim
                ];
                extraSpecialArgs = {
                  pkgs-unstable = import nixpkgs-unstable {
                    inherit system;
                    config = pkgConfig;
                  };
                };
              };
            }
            noctalia.nixosModules.default
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
            config = pkgConfig;
          };
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config = pkgConfig;
          };
          home.username = user;
          home.homeDirectory = "/home/${user}";
          modules = [
            ./home/${user}
            ./home/${user}/hosts/${hostname}.nix
            home-manager.homeModules.home-manager
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
          extraModules = [
            {
              nixpkgs.overlays = [ nix-cachyos-kernel.overlays.pinned ];
            }
          ];
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
