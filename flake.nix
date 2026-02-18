{
  description = "My NixOS Configuration";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # edit this to switch between stable and unstable
    nixpkgs.follows = "apple-silicon/nixpkgs";

    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    base16 = {
      url = "github:SenchoPens/base16.nix";
    };

    tt-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };

    base16-discord = {
      url = "github:imbypass/base16-discord";
      flake = false;
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

    aerothemeplasma-nix = {
      url = "github:nyakase/aerothemeplasma-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
      # inputs.niri-stable.follows = "niri-blur";
      # inputs.niri-unstable.follows = "niri-blur";
    };

    # niri-blur = {
    #   url = "github:visualglitch91/niri/feat/blur";
    #   flake = false;
    # };

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
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    openmw = {
      url = "gitlab:OpenMW/openmw";
      flake = false;
    };

    catppuccin-discord = {
      url = "github:catppuccin/discord";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      nix-cachyos-kernel,
      base16,
      tt-schemes,
      base16-discord,
      home-manager,
      plasma-manager,
      aerothemeplasma-nix,
      niri,
      noctalia,
      spicetify-nix,
      nur,
      nixvim,
      apple-silicon,
      openmw,
      catppuccin-discord,
      ...
    }:
    let
      # All systems we want to support for the generic VM
      # to run the vm:
      # nixos-rebuild build-vm --flake ~/nix#$(nix eval --raw --impure --expr 'builtins.currentSystem')
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

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
                    catppuccin-discord-git = catppuccin-discord;
                    base16-discord-git = base16-discord;
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

                  # Increase file descriptor limit for builds
                  # sandbox = "relaxed";
                  # extra-sandbox-paths = [ ];
                  # build-users-group = "nixbld";
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
                ];
                hashedPassword = "$6$bvwRUFaJNMpH8rm3$FGDWFN6tBScJ/2DynAjnlZE8JRfyADN78d6c4GawxpAjyNLNE/AjQzMA09tLRqpKX7WnN5PIUZLAm2bT9/RbG0";
                openssh.authorizedKeys.keys = [
                  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCn/eXMq04vcXNqGVzlZOw2C2dQYBqzWsoigdFW09XqC2WPaGljbAIayzaD7Q1tIlPGGy10+nipAXAk1CHAnrQ2KSg4v/SwFphF48V3joeQmideC4vo0EIQEQibbMtj3oFezqRcRZINl/1hr4t0myZ3zkoTjh3HCkqJEMGUdArDMEVPA5mwcKSLsyshW9LMG/3C9YKKPU1/lVsoeDkj8AVZA0srhkApuRKF0IVu8KoPd6ldvSWgpQ1iuQ+MEMSeOUJytieBkzeY9zEVePaQ86oIMDUzqq8OTN37RyShiJKPskKyj12rJI2eFtI/viGaj8P6/yvKqMp3F4kAsPAuvMLLAIYCNa+139rDpkkIKB6lVtgq0jnJGRywaYXGIRyExNcVAr8I9wrNnNN2M4whVeYBxfLMzKZ+VvfK39AaGvnzPuFDLqUC87sN4c/1KZQo+TCtlaxcYvqowWylw5JHUt8uwFcO/dUebQxxAv8EdyPZGJ/54y19PsTbu9KyxSc2gIU= sckova"
                ];
              };
            }
            ./system
            ./system/searxng
            ./system/widevine
            ./system/shell/fish.nix
            ./system/tailscale
            ./system/hosts/${hostname}
            ./hardware/${hostname}
            aerothemeplasma-nix.nixosModules.aerothemeplasma-nix
            niri.nixosModules.niri
            home-manager.nixosModules.home-manager
            noctalia.nixosModules.default
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.sckova = {
                  imports = [
                    ./home
                    ./options.nix
                    ./home/apps
                    ./home/games
                    ./home/hosts/${hostname}
                    ./home/kde
                    ./home/services
                    ./home/terminal
                    ./home/tiling
                  ];
                };
                sharedModules = [
                  base16.nixosModule
                  (
                    { config, ... }:
                    {
                      scheme = "${tt-schemes}/base24/${config.colors.scheme}.yaml";
                    }
                  )
                  aerothemeplasma-nix.homeModules.aerothemeplasma-nix
                  plasma-manager.homeModules.plasma-manager
                  noctalia.homeModules.default
                  spicetify-nix.homeManagerModules.default
                  nixvim.homeModules.nixvim
                ];
                extraSpecialArgs = {
                  inherit spicetify-nix;
                  pkgs-unstable = import nixpkgs-unstable {
                    inherit system;
                    config = pkgConfig;
                  };
                };
              };
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
            config = pkgConfig;
          };
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config = pkgConfig;
          };
          home.username = user;
          home.homeDirectory = "/home/${user}";
          modules = [
            ./home
            ./home/hosts/${hostname}.nix
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

        alien =
          mkNixosSystem {
            hostname = "alien";
            system = "x86_64-linux";
            extraModules = [
              { nixpkgs.overlays = [ nix-cachyos-kernel.overlays.pinned ]; }
            ];
          }
          // nixpkgs.lib.genAttrs supportedSystems (
            system:
            mkNixosSystem {
              hostname = "vm-generic";
              inherit system;
            }
          );
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
      }
      // nixpkgs.lib.genAttrs supportedSystems (
        system:
        mkHomeConfig {
          user = "sckova";
          hostname = "vm-generic";
          inherit system;
        }
      );
    };
}
