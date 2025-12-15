{
  config,
  pkgs,
  lib,
  inputs,
  catppuccin,
  nix-cachyos-kernel,
  ...
}:
{
  networking.hostName = "alien";

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "riscv64-linux"
  ];

  catppuccin.accent = "blue";

  home-manager.users.sckova = {
    imports = [ catppuccin.homeModules.catppuccin ];
  };

  boot.loader.systemd-boot.consoleMode = "max";
  # boot.kernelPackages = pkgs.linuxPackages;

  # let's use the CachyOS kernel instead!
  nixpkgs.overlays = [ nix-cachyos-kernel.overlays.default ];
  nix.settings.substituters = [
    "https://attic.xuyh0120.win/lantian"
    "https://cache.garnix.io"
  ];
  nix.settings.trusted-public-keys = [
    "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
  ];
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

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
      enable = true;
      user = "sckova";
    };
    defaultSession = "niri";
  };

  environment = {
    systemPackages = [ pkgs.mangohud ];
    loginShellInit = ''
      [[ "$(tty)" = "/dev/tty1" ]] && ./gs.sh
    '';
  };

  security.sudo.wheelNeedsPassword = true;

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
