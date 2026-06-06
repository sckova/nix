{
  config,
  pkgs,
  ...
}:
{
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

  # enable ddcutil
  users.users.${config.username}.extraGroups = [
    "i2c"
    "uinput"
  ];
  services.udev.extraRules = ''
    KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
  '';
  hardware.i2c.enable = true;

  boot = {
    extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];
    kernelModules = [
      "i2c-dev"
      "ddcci_backlight"
    ];
    kernelPackages = pkgs.linuxPackages;
  };

  # enable rgb support
  services.hardware.openrgb.enable = true;

  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };

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
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    nvidiaSettings = false;
    open = false;
  };

  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];

  # i don't even remember what this does or why i added it
  systemd.tmpfiles.rules = [
    "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware"
    "d /mnt/storage 0775 ${config.username} users - -"
  ];

  services.factorio = {
    enable = true;
    openFirewall = true;
    requireUserVerification = false;
    lan = true;
    port = 25565;
    # bind = "[::]"; # support IPv6
    game-name = "kova's minecraft";
    game-password = "ThisIsASuperSecurePasswordThatNobodyWillGuess";
    admins = [ config.username ];
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };
}
