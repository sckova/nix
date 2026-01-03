{
  config,
  pkgs,
  lib,
  inputs,
  catppuccin,
  nix-cachyos-kernel,
  ...
}: {
  networking.hostName = "alien";

  environment.systemPackages = with pkgs; [
    pkgs.ddcutil
    pkgs.mangohud
  ];

  # enable ddcutil
  users.users.sckova.extraGroups = ["i2c"];
  boot.extraModulePackages = [config.boot.kernelPackages.ddcci-driver];
  boot.kernelModules = [
    "i2c-dev"
    "ddcci_backlight"
  ];
  services.udev.extraRules = ''
    KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
  '';
  hardware.i2c.enable = true;

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "riscv64-linux"
  ];

  catppuccin.accent = "blue";

  home-manager.users.sckova = {
    imports = [catppuccin.homeModules.catppuccin];
  };

  boot.loader.systemd-boot.consoleMode = "max";
  # boot.kernelPackages = pkgs.linuxPackages;

  # let's use the CachyOS kernel instead!
  nixpkgs.overlays = [nix-cachyos-kernel.overlays.default];
  nix.settings.substituters = [
    "https://attic.xuyh0120.win/lantian"
    "https://cache.garnix.io"
  ];
  nix.settings.trusted-public-keys = [
    "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
  ];
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-lts;

  # enable hyper-v for guests
  virtualisation.hypervGuest.enable = true;
  boot.blacklistedKernelModules = ["hyperv_fb"];

  programs = {
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };

  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];

  services.displayManager = {
    autoLogin = {
      enable = false;
      user = "sckova";
    };
    defaultSession = "niri";
  };

  environment = {
    loginShellInit = ''
      [[ "$(tty)" = "/dev/tty1" ]] && ./gs.sh
    '';
  };

  security.sudo.wheelNeedsPassword = false;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    nvidiaSettings = false;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };
}
