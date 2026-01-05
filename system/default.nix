# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings.trusted-users = [
    "root"
    "sckova"
  ];

  nix.settings = {
    # Increase file descriptor limit for builds
    sandbox = "relaxed";
    extra-sandbox-paths = [];
    build-users-group = "nixbld";
  };

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "65536";
    }
    {
      domain = "*";
      type = "hard";
      item = "nofile";
      value = "65536";
    }
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.sckova = {
    imports = [
      ../home
      ../home/games/minecraft
      ../home/games/morrowind
      ../home/graphical/discord
      ../home/graphical/firefox
      ../home/graphical/mpv
      ../home/tiling/niri
      ../home/tiling/wallpaper
      ../home/systemd
      ../home/terminal/btop
      ../home/terminal/fish
      ../home/terminal/kitty
      ../home/terminal/nvim
      ../home/kde
      ../home/vscode
      ../home/hosts/${config.networking.hostName}
    ];
  };

  environment.sessionVariables = rec {
    NIXOS_OZONE_WL = "1";
    EDITOR = "nvim";
    TERMINAL = "kitty";
  };

  boot = {
    plymouth = {
      enable = true;
    };

    loader = {
      timeout = 3;
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi = {
        canTouchEfiVariables = false;
      };
    };
    kernelParams = [
      "quiet"
      "splash"
      "vga=current"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "boot.shell_on_fail"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";
    cache.enable = true;
  };

  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable.overrideAttrs (old: {
      doCheck = false;
    });
  };
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.niri.enableGnomeKeyring = true;
  programs.dconf.enable = true;

  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      enableHidpi = true;
    };
    libinput.enable = true;
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    udisks2.enable = true;
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
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
    packages = with pkgs; [];
    hashedPassword = "$6$bvwRUFaJNMpH8rm3$FGDWFN6tBScJ/2DynAjnlZE8JRfyADN78d6c4GawxpAjyNLNE/AjQzMA09tLRqpKX7WnN5PIUZLAm2bT9/RbG0";
  };

  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = with pkgs; [
      git
      firefoxpwa
      distrobox
    ];

    plasma6.excludePackages = with pkgs.kdePackages; [
      elisa
      konsole
      khelpcenter
    ];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  networking.firewall.enable = false;

  documentation.man = {
    enable = true;
    generateCaches = false;
  };

  services.openssh.enable = true;
  users.users."sckova".openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCn/eXMq04vcXNqGVzlZOw2C2dQYBqzWsoigdFW09XqC2WPaGljbAIayzaD7Q1tIlPGGy10+nipAXAk1CHAnrQ2KSg4v/SwFphF48V3joeQmideC4vo0EIQEQibbMtj3oFezqRcRZINl/1hr4t0myZ3zkoTjh3HCkqJEMGUdArDMEVPA5mwcKSLsyshW9LMG/3C9YKKPU1/lVsoeDkj8AVZA0srhkApuRKF0IVu8KoPd6ldvSWgpQ1iuQ+MEMSeOUJytieBkzeY9zEVePaQ86oIMDUzqq8OTN37RyShiJKPskKyj12rJI2eFtI/viGaj8P6/yvKqMp3F4kAsPAuvMLLAIYCNa+139rDpkkIKB6lVtgq0jnJGRywaYXGIRyExNcVAr8I9wrNnNN2M4whVeYBxfLMzKZ+VvfK39AaGvnzPuFDLqUC87sN4c/1KZQo+TCtlaxcYvqowWylw5JHUt8uwFcO/dUebQxxAv8EdyPZGJ/54y19PsTbu9KyxSc2gIU= sckova"
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
