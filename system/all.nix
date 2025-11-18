# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings.trusted-users = [
    "root"
    "sckova"
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.sckova = {
    imports = [
      ../home/all.nix
      ../home/browsers/firefox/default.nix
      ../home/systemd/default.nix
      ../home/terminal/btop/default.nix
      ../home/terminal/nvim/default.nix
      ../home/terminal/kitty/default.nix
      ../home/kde/plasma.nix
      ../home/kde/other.nix
      ../home/vscode/default.nix
      ../home/hosts/${config.networking.hostName}.nix
    ];
  };

  boot = {

    plymouth = {
      enable = true;
    };

    loader = {
      timeout = 3;
      systemd-boot = {
        enable = true;
        configurationLimit = null;
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
      "apple_dcp.show_notch=1"
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

  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      enableHidpi = true;
    };
    libinput.enable = true;
    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
  };

  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
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
    packages = with pkgs; [ ];
    hashedPassword = "$6$bvwRUFaJNMpH8rm3$FGDWFN6tBScJ/2DynAjnlZE8JRfyADN78d6c4GawxpAjyNLNE/AjQzMA09tLRqpKX7WnN5PIUZLAm2bT9/RbG0";
  };

  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = with pkgs; [
      git
      inputs.kwin-effects-forceblur.packages.${pkgs.stdenv.hostPlatform.system}.default
      firefoxpwa
      distrobox
    ];
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
