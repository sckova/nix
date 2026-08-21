{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./kernel.nix
  ];

  environment.systemPackages = with pkgs; [
    p7zip
    zenity
    wineWow64Packages.stable
    wineWow64Packages.waylandFull
  ];

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = false;
    open = true;
    powerManagement.enable = false;
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

    sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };

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
}
