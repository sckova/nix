# system/services/default.nix
{
  imports = [
    ./searxng.nix
    ./tiling.nix
    ./widevine.nix
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  security.sudo.wheelNeedsPassword = false;

  services = {
    gvfs.enable = true;
    openssh.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    power-profiles-daemon.enable = true;
    printing.enable = true;
    udisks2.enable = true;
    upower.enable = true;
  };

  time.timeZone = "America/New_York";
}
