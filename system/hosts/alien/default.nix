{
  config,
  pkgs,
  ...
}:
{
  boot = {
    extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];

    kernelModules = [
      "i2c-dev"
      "ddcci_backlight"
    ];

    kernelPackages = pkgs.linuxPackages;
  };

  environment.systemPackages = with pkgs; [
    ddcutil
    mangohud
    openrgb
    p7zip
    protontricks
    zenity
    wineWow64Packages.stable
    wineWow64Packages.waylandFull
    archipelago
  ];

  hardware = {
    i2c.enable = true;

    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = false;
      open = false;
      powerManagement.enable = false;
    };
  };

  programs = {
    gamescope.args = [
      "--output-width 3840"
      "--nested-width 3840"
      "--output-height 2160"
      "--nested-height 2160"
    ];

    nix-ld = {
      enable = true;
      libraries = [ ];
    };

    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
      gamescopeSession.enable = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };

  services = {
    factorio = {
      enable = true;
      admins = [ config.username ];
      # bind = "[::]"; # support IPv6
      game-name = "kova's minecraft";
      game-password = "ThisIsASuperSecurePasswordThatNobodyWillGuess";
      lan = true;
      openFirewall = true;
      port = 25565;
      requireUserVerification = false;
    };

    # enable rgb support
    hardware.openrgb.enable = true;

    sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };

    udev.extraRules = ''
      KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
    '';

    xserver.videoDrivers = [
      "modesetting"
      "nvidia"
    ];
  };

  # i don't even remember what this does or why i added it
  systemd.tmpfiles.rules = [
    "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware"
    "d /mnt/storage 0775 ${config.username} users - -"
  ];

  # enable ddcutil
  users.users.${config.username}.extraGroups = [
    "i2c"
    "uinput"
  ];
}
