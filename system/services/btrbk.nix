{
  config,
  lib,
  pkgs,
  hostname,
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      btrbk = prev.btrbk.override {
        openssh = final.symlinkJoin {
          name = "openssh-btrbk-password-auth";
          paths = [ final.openssh ];

          postBuild = ''
            rm "$out/bin/ssh"
            cat > "$out/bin/ssh" <<EOF
            #!${final.bash}/bin/bash
            exec ${final.sshpass}/bin/sshpass -f "/run/secrets/syno_pass" \
              ${final.openssh}/bin/ssh \
              -o PreferredAuthentications=password \
              -o PubkeyAuthentication=no \
              "\$@"
            EOF
            chmod +x "$out/bin/ssh"
          '';
        };
      };
    })
  ];

  # a tool for creating snapshots and remote backups of btrfs subvolumes
  # https://wiki.nixos.org/wiki/Btrbk
  # creates a weekly incremental backup of a local Btrfs subvolume called nixos
  # and sends it compressed to the remote host myhost. The mount point /btr_pool,
  # as referenced above, contains the subvolume
  services.btrbk.instances."home" = {
    onCalendar = "hourly";

    settings = {
      snapshot_preserve = "2w";
      snapshot_preserve_min = "1w";
      ssh_user = "sckova";

      volume."/" = {
        snapshot_dir = "/snapshots";

        subvolume."home" = {
          snapshot_name = "home-${config.networking.hostName}";
          target = "ssh://nas.taila30609.ts.net/var/services/homes/sckova/btrbks";
        };
      };
    };
  };

  sops.secrets.syno_pass = {
    mode = "0400";
    owner = "btrbk";
  };

  systemd = {
    services."btrbk-home".path = lib.mkBefore [
      (pkgs.writeShellScriptBin "ssh" ''
        exec ${pkgs.sshpass}/bin/sshpass -f "${config.sops.secrets.syno_pass.path}" \
          ${pkgs.openssh}/bin/ssh \
          -o PreferredAuthentications=password \
          -o PubkeyAuthentication=no \
          "$@"
      '')
    ];

    # btrbk does not create snapshot directories automatically, so create one here
    tmpfiles.rules = [
      "d /snapshots 0755 root root"
    ];
  };
}
