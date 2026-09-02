# system/services/default.nix
{
  imports = [
    ./widevine.nix
    ./searxng.nix
    ./tiling.nix
  ];

  documentation.man.enable = true;
  # zsh completion for system packages
  environment.pathsToLink = [ "/share/zsh" ];

  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
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
  };

  security = {
    polkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  services = {
    gvfs.enable = true;
    libinput.enable = true;
    openssh.enable = true;

    pipewire = {
      enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };

      pulse.enable = true;
      systemWide = true;
      wireplumber.enable = true;
    };

    power-profiles-daemon.enable = true;
    printing.enable = true;
    udisks2.enable = true;
    upower.enable = true;
  };

  time.timeZone = "America/New_York";
}
