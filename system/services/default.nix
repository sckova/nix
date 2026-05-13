{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./widevine.nix
    ./searxng.nix
  ];

  services = {
    displayManager = {
      autoLogin.enable = false;
      autoLogin.user = "sckova";
      defaultSession = "niri";
      gdm.enable = true;
    };
    gnome.gnome-keyring.enable = true;
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
    glances.enable = true;
    glances.package = pkgs.glances.overrideAttrs (oldAttrs: {
      disabledTests = (oldAttrs.disabledTests or [ ]) ++ [
        "test_phys_core_returns_int"
      ];
    });
  };

  security = {
    pam.services = {
      gdm.enableGnomeKeyring = true;
      niri.enableGnomeKeyring = config.services.gnome.gnome-keyring.enable;
      swaylock = {
        name = "swaylock";
        enableGnomeKeyring = config.services.gnome.gnome-keyring.enable;
        gnupg.enable = true;
        gnupg.noAutostart = true;
      };
    };
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
