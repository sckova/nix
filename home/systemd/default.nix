{ pkgs, lib, ... }:

{
  xdg.configFile."rclone/synology.conf".text = ''
    [synology]
    type = sftp
    user = sckova
    host = nas.taila30609.ts.net
    key_file = ~/.ssh/key
    shell_type = unix
    root = home
    md5sum_command = "${pkgs.coreutils}/bin/md5sum";
    sha1sum_command = "${pkgs.coreutils}/bin/sha1sum";
  '';

  systemd.user.services.synology-mount = {
    Unit = {
      Description = "Mount Synology NAS with Rclone and Home Manager.";
      After = [ "tailscaled.service" ];
    };

    Service = {
      Type = "notify";
      ExecStartPre = ''
        if mountpoint -q %h/Synology; then
          /run/wrappers/bin/fusermount -uz %h/Synology
        fi
        ${pkgs.coreutils}/bin/mkdir -p %h/Synology
      '';
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone \
         --config=%h/.config/rclone/synology.conf \
         --vfs-cache-mode full \
         --vfs-cache-max-size 10G \
         --vfs-cache-max-age 12h \
         --vfs-read-chunk-size 128M \
         --vfs-read-chunk-size-limit 2G \
         --buffer-size 64M \
         --dir-cache-time 72h \
         --ignore-checksum \
         --log-level INFO \
         mount "synology:" "%h/Synology"
      '';
      ExecStop = "/run/wrappers/bin/fusermount -uz %h/Synology/%i";
      StandardOutput = "journal";
      StandardError = "journal";
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
