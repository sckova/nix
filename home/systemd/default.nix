{ pkgs, ... }:

{
  xdg.configFile."rclone/synology.conf".text = ''
    [synology]
    type = sftp
    user = sckova
    host = nas.taila30609.ts.net
    key_file = ~/.ssh/key
  '';

  systemd.user.services.synology-mount = {
    Unit = {
      Description = "Mount Synology NAS with Rclone and Home Manager.";
      After = [ "network-online.target" ];
    };

    Service = {
      Type = "notify";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/Synology";
      ExecStart = "${pkgs.rclone}/bin/rclone --config=%h/.config/rclone/synology.conf --vfs-cache-mode full --ignore-checksum mount \"synology:\" \"%h/Synology\"";
      ExecStop = "/run/wrappers/bin/fusermount -u %h/Synology/%i";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  systemd.user.services.input-leap = {
    Unit = {
      Description = "Autostart Input Leap";
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      PassEnvironment = "DISPLAY";
      ExecStart = "${pkgs.writeShellScript "input-leap-start" ''
        sleep 5
        ${pkgs.input-leap}/bin/input-leap
      ''}";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
