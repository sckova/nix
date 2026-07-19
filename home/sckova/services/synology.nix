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

  systemd.user.services.synology-mount-home = {
    Unit = {
      Description = "Mount Synology NAS homs with rclone";
      After = [ "tailscaled.service" ];
      Wants = [ "tailscaled.service" ];
      StartLimitBurst = 5;
      StartLimitIntervalSec = "1m";
    };

    Service = {
      Type = "simple";
      Restart = "on-failure";
      RestartSec = "1m";
      ExecStart = "${pkgs.writeShellScript "synology-mount-home" /* bash */ ''
        #!/usr/bin/env bash
        set -euo pipefail

        # Ensure mount point exists
        mkdir -p $HOME/Synology || true

        # Unmount stale mount if present
        /run/wrappers/bin/umount "$HOME/Synology" || true

        # Mount rclone in foreground
        ${pkgs.rclone}/bin/rclone \
          --config=${config.sops.templates."synology.conf".path} \
          --ignore-checksum \
          --log-level INFO \
          mount "synology:home" "$HOME/Synology"
      ''}";
      ExecStop = "/run/wrappers/bin/fusermount -uz %h/Synology/%i";
      StandardOutput = "journal";
      StandardError = "journal";
    };

    Install.WantedBy = [ "default.target" ];
  };

  systemd.user.services.synology-mount-scans = {
    Unit = {
      Description = "Mount Synology NAS scans with rclone";
      After = [ "tailscaled.service" ];
      Wants = [ "tailscaled.service" ];
      StartLimitBurst = 5;
      StartLimitIntervalSec = "1m";
    };

    Service = {
      Type = "simple";
      Restart = "on-failure";
      RestartSec = "1m";
      ExecStart = "${pkgs.writeShellScript "synology-mount-scans" /* bash */ ''
        #!/usr/bin/env bash
        set -euo pipefail

        # Ensure mount point exists
        mkdir -p $HOME/Scans || true

        # Unmount stale mount if present
        /run/wrappers/bin/umount "$HOME/Scans" || true

        # Mount rclone in foreground
        ${pkgs.rclone}/bin/rclone \
          --config=${config.sops.templates."synology.conf".path} \
          --ignore-checksum \
          --log-level INFO \
          mount "synology:scans" "$HOME/Scans"
      ''}";
      ExecStop = "/run/wrappers/bin/fusermount -uz %h/Scans/%i";
      StandardOutput = "journal";
      StandardError = "journal";
    };

    Install.WantedBy = [ "default.target" ];
  };
}
