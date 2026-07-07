{
  pkgs,
  ...
}:
{
  imports = [
    ./widevine.nix
    ./searxng.nix
    # ./kde.nix
    ./tiling.nix
  ];

  services = {
    libinput.enable = true;
    printing.enable = true;
    pipewire = {
      enable = true;
      systemWide = true;
      wireplumber.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    udisks2.enable = true;
    gvfs.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    openssh.enable = true;
  };

  security = {
    sudo.wheelNeedsPassword = false;
    polkit.enable = true;
  };

  documentation.man.enable = true;
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
}
