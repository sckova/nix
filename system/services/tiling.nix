{
  pkgs,
  ...
}:
{
  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
    };

    niri.enable = true;
  };

  security.pam.services = {
    gdm.enableGnomeKeyring = true;
    niri.enableGnomeKeyring = true;

    swaylock = {
      enableGnomeKeyring = true;

      gnupg = {
        enable = true;
        noAutostart = false;
      };

      name = "swaylock";
    };
  };

  services = {
    desktopManager.gnome.enable = true;

    displayManager = {
      autoLogin = {
        enable = true;
        user = "sckova";
      };

      defaultSession = "niri";
      gdm.enable = true;
    };

    gnome = {
      core-apps.enable = true;
      games.enable = true;
      gnome-keyring.enable = true;
      sushi.enable = true;
    };
  };
}
