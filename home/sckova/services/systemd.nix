{
  config,
  pkgs,
  ...
}:
{
  systemd.user.sessionVariables = {
    XCURSOR_THEME = config.userOptions.cursor.name;
    XCURSOR_SIZE = toString config.userOptions.cursor.size;
    XCURSOR_PATH = config.userOptions.cursor.path;
  };

  sops.templates."synology.conf".content = ''
    [synology]
    type = smb
    host = nas.taila30609.ts.net
    pass = ${config.sops.placeholder.rclone_synology}
  '';

  systemd.user.services.synology-mount = {
    Unit = {
      Description = "Mount Synology NAS with Rclone and Home Manager.";
      After = [ "tailscaled.service" ];
      Wants = [ "tailscaled.service" ];
      StartLimitBurst = 5;
      StartLimitIntervalSec = "1m";
    };

    Service = {
      Type = "simple";
      Restart = "on-failure";
      RestartSec = "1m";
      ExecStart = "${pkgs.writeShellScript "synology-mount" ''
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
          --rc --rc-serve \
          mount "synology:home" "$HOME/Synology"
      ''}";
      ExecStop = "/run/wrappers/bin/fusermount -uz %h/Synology/%i";
      StandardOutput = "journal";
      StandardError = "journal";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
