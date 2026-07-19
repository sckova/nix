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
    displayManager = {
      autoLogin = {
        enable = true;
        user = "sckova";
      };

      defaultSession = "niri";
      gdm.enable = true;
    };

    gnome.gnome-keyring.enable = true;
  };

  systemd.user.services.gnome-keyring = {
    serviceConfig = {
      ExecStart = "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --foreground --components=pkcs11,secrets,ssh";
      Restart = "on-abort";
    };

    wantedBy = [ "default.target" ];
  };
}
