# hardware/impermanence.nix
{
  pkgs,
  ...
}:
{
  boot.initrd.systemd.services.rollback = {
    after = [ "initrd-root-device.target" ];
    before = [ "sysroot.mount" ];
    description = "Rollback btrfs root subvolume to a pristine state";
    path = [ pkgs.btrfs-progs ];

    script = /* bash */ ''
      mkdir -p /btrfs_tmp
      mount -o subvol=/ /dev/disk/by-label/nixos /btrfs_tmp

      if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
          delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
      }

      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
    '';

    serviceConfig.Type = "oneshot";
    unitConfig.DefaultDependencies = "no";
    wantedBy = [ "initrd-root-device.target" ];
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/NetworkManager"
      "/var/lib/systemd/coredump"
    ];

    files = [
      "/etc/machine-id"
    ];

    hideMounts = true;
  };

  fileSystems = {
    "/home".neededForBoot = true;

    "/persist" = {
      options = [
        "subvol=persist"
        "compress=zstd"
        "relatime"
      ];

      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      neededForBoot = true;
    };
  };

  services.openssh.hostKeys = [
    {
      path = "/persist/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }
    {
      bits = 4096;
      path = "/persist/etc/ssh/ssh_host_rsa_key";
      type = "rsa";
    }
  ];
}
