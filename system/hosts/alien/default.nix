# system/hosts/alien/default.nix
{
  pkgs,
  ...
}:
{
  imports = [
    ./kernel.nix
  ];

  hardware.nvidia = {
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

    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
      gamescopeSession.enable = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };

  services = {
    sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };

    xserver.videoDrivers = [ "nvidia" ];
  };

  systemd.tmpfiles.rules = [
    "d /mnt/storage 2775 root users - -"
  ];
}
