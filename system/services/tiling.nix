# system/services/tiling.nix
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
    desktopManager.gnome.enable = false;

    displayManager = {
      autoLogin = {
        enable = true;
        user = "sckova";
      };

      defaultSession = "niri";
      gdm.enable = true;
    };

    gnome = {
      core-apps.enable = false;
      games.enable = false;
      gnome-keyring.enable = false;
      sushi.enable = false;
    };
  };
}
