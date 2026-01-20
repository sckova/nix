{
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    ddcutil
    mangohud
    (bottles.override { removeWarningPopup = true; })
  ];

  # enable ddcutil
  users.users.sckova.extraGroups = [ "i2c" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];
  boot.kernelModules = [
    "i2c-dev"
    "ddcci_backlight"
  ];
  services.udev.extraRules = ''
    KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
  '';
  hardware.i2c.enable = true;

  catppuccin = {
    accent = "blue";
    flavor = "mocha";
  };

  boot.loader.systemd-boot.consoleMode = "max";
  boot.kernelPackages = pkgs.linuxPackages;

  # let's use the CachyOS kernel instead!
  # boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-lts;
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

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
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  # virtualization settings

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
    };
  };

  # enable hyper-v for guests
  virtualisation.hypervGuest.enable = true;
  boot.blacklistedKernelModules = [ "hyperv_fb" ];

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "riscv64-linux"
  ];

  # i don't even remember what this does or why i added it
  systemd.tmpfiles.rules = [ "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware" ];
}
