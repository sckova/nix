{
  description = "My NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel";

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin-palette = {
      url = "github:abhinandh-s/catppuccin-nix";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
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
    # to run the vm:
    # nixos-rebuild build-vm --flake ~/nix#$(nix eval --raw --impure --expr 'builtins.currentSystem')
    supportedSystems = ["x86_64-linux" "aarch64-linux"];

    # Shared config for all package sets
    pkgConfig = {
      allowUnfree = true;
    };

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
            pkgs-unstable = import nixpkgs-unstable {
              inherit system;
              config = pkgConfig;
            };
          }
          // extraSpecialArgs;
        modules =
          [
            {
              nixpkgs = {
                config = pkgConfig;
                overlays = [
                  catppuccin-palette.overlays.default
                  niri.overlays.niri
                  noctalia.overlays.default
                  nur.overlays.default
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
                  ];

                  trusted-public-keys = [
                    "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
                    "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
                  ];

                  trusted-users = [
                    "root"
                    "sckova"
                  ];

                  # Increase file descriptor limit for builds
                  sandbox = "relaxed";
                  extra-sandbox-paths = [];
                  build-users-group = "nixbld";
                };

                gc = {
                  automatic = true;
                  dates = "weekly";
                  options = "--delete-older-than 30d";
                };
              };

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
            ./system/widevine
            ./system/shell/fish.nix
            ./system/tailscale
            ./system/hosts/${hostname}
            ./hardware/${hostname}
            catppuccin.nixosModules.catppuccin
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
                    ./home/games/minecraft
                    ./home/games/morrowind
                    ./home/graphical/discord
                    ./home/graphical/firefox
                    ./home/graphical/mpv
                    ./home/tiling/niri
                    ./home/tiling/wallpaper
                    ./home/systemd
                    ./home/terminal/btop
                    ./home/terminal/fish
                    ./home/terminal/kitty
                    ./home/terminal/nvim
                    ./home/kde
                    ./home/theming
                    ./home/vscode
                    ./home/hosts/${hostname}
                  ];
                };
                sharedModules = [
                  catppuccin.homeModules.catppuccin
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

    mkHomeConfig = {
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
          catppuccin.homeModules.catppuccin
          home-manager.homeModules.home-manager
          plasma-manager.homeModules.plasma-manager
          niri.homeModules.default
          noctalia.homeModules.noctalia
          nixvim.homeModules.nixvim
        ];
      };
  in {
    nixosConfigurations = {
      peach = mkNixosSystem {
        hostname = "peach";
        system = "aarch64-linux";
        extraModules = [
          apple-silicon.nixosModules.default
          {nixpkgs.overlays = [apple-silicon.overlays.apple-silicon-overlay];}
        ];
      };

      alien =
        mkNixosSystem {
          hostname = "alien";
          system = "x86_64-linux";
          extraModules = [
            {nixpkgs.overlays = [nix-cachyos-kernel.overlays.default];}
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

    homeConfigurations =
      {
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
