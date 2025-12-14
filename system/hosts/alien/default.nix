{
  config,
  pkgs,
  lib,
  inputs,
  catppuccin,
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

  boot.kernelPackages = pkgs.linuxPackages;
  boot.loader.systemd-boot.consoleMode = "max";

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
  security.sudo.wheelNeedsPassword = true;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    nvidiaSettings = false;
    open = false;
    package = pkgs.linuxPackages.nvidiaPackages.stable;
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };
}
