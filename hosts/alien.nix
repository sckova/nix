{ config, pkgs, lib, catppuccin, ... }: {
  networking.hostName = "alien";

  catppuccin = {
    accent = "lavender";
  };

  home-manager.users.sckova = {
    imports = [ catppuccin.homeModules.catppuccin ];
  };

  boot.kernelPackages = pkgs.linuxPackages;

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

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    nvidiaSettings = true;
    package = pkgs.linuxPackages.nvidiaPackages.stable;
  };
}

