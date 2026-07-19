{
  config,
  pkgs,
  ...
}:
{
  sops.templates."synology.conf".content = ''
    [synology]
    type = smb
    host = nas.taila30609.ts.net
    pass = ${config.sops.placeholder.rclone_synology}
  '';

  systemd.user.services = {
    synology-mount-home = {
      Install.WantedBy = [ "default.target" ];

      Service = {
        ExecStart = "${pkgs.writeShellScript "synology-mount-home" /* bash */ ''
          #!/usr/bin/env bash
          set -euo pipefail

          # Ensure mount point exists
          ${pkgs.coreutils}/bin/mkdir -p $HOME/Synology || true

          # Unmount stale mount if present
          ${pkgs.utillinux}/bin/umount $HOME/Synology || true

          # Mount rclone in foreground
          ${pkgs.rclone}/bin/rclone \
            --config=${config.sops.templates."synology.conf".path} \
            --ignore-checksum \
            --log-level INFO \
            mount "synology:home" "$HOME/Synology"
        ''}";

        ExecStop = /* bash */ "${pkgs.fuse}/bin/fusermount -uz %h/Synology";
        Restart = "on-failure";
        RestartSec = "1m";
        StandardError = "journal";
        StandardOutput = "journal";
        Type = "simple";
      };

      Unit = {
        After = [ "tailscaled.service" ];
        Description = "Mount Synology NAS home with rclone";
        StartLimitBurst = 5;
        StartLimitIntervalSec = "1m";
        Wants = [ "tailscaled.service" ];
      };
    };

    synology-mount-scans = {
      Install.WantedBy = [ "default.target" ];

      Service = {
        ExecStart = "${pkgs.writeShellScript "synology-mount-scans" /* bash */ ''
          #!/usr/bin/env bash
          set -euo pipefail

          # Ensure mount point exists
          ${pkgs.coreutils}/bin/mkdir -p $HOME/Scans || true

          # Unmount stale mount if present
          ${pkgs.utillinux}/bin/umount $HOME/Scans || true

          # Mount rclone in foreground
          ${pkgs.rclone}/bin/rclone \
            --config=${config.sops.templates."synology.conf".path} \
            --ignore-checksum \
            --log-level INFO \
            mount "synology:scans" "$HOME/Scans"
        ''}";

        ExecStop = /* bash */ "${pkgs.fuse}/bin/fusermount -uz %h/Scans";
        Restart = "on-failure";
        RestartSec = "1m";
        StandardError = "journal";
        StandardOutput = "journal";
        Type = "simple";
      };

      Unit = {
        After = [ "tailscaled.service" ];
        Description = "Mount Synology NAS scans with rclone";
        StartLimitBurst = 5;
        StartLimitIntervalSec = "1m";
        Wants = [ "tailscaled.service" ];
      };
    };
  };
}
