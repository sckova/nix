{
  pkgs,
  ...
}:
{
  programs = {
    niri.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
  };

  systemd.user.services.gnome-keyring = {
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --foreground --components=pkcs11,secrets,ssh";
      Restart = "on-abort";
    };
  };

  services = {
    displayManager = {
      autoLogin.enable = true;
      autoLogin.user = "sckova";
      defaultSession = "niri";
      gdm.enable = true;
    };
    gnome.gnome-keyring.enable = true;
  };

  security.pam.services = {
    gdm.enableGnomeKeyring = true;
    niri.enableGnomeKeyring = true;
    swaylock = {
      name = "swaylock";
      enableGnomeKeyring = true;
      gnupg.enable = true;
      gnupg.noAutostart = false;
    };
  };
}
