{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        AddKeysToAgent = "no";
        Compression = false;
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
        ForwardAgent = false;
        HashKnownHosts = false;
        IdentityFile = "~/.ssh/key";
        ServerAliveCountMax = 3;
        ServerAliveInterval = 0;
        StrictHostKeyChecking = "no";
        UserKnownHostsFile = "~/.ssh/known_hosts";
      };

      "Match final host *.ts.net" = {
        # tailscale connections are end-to-end encrypted
        # https://www.openssh.org/pq.html
        # https://tailscale.com/docs/concepts/tailscale-encryption
        WarnWeakCrypto = "no";
      };

      "alien" = {
        HostName = "alien.taila30609.ts.net";
      };

      "nas" = {
        HostName = "nas.taila30609.ts.net";
      };

      "oracle" = {
        HostName = "vips.taila30609.ts.net";
        User = "ubuntu";
      };

      "ovips.us.to" = {
        HostName = "ovips.us.to";
        Port = 222;
        User = "git";
      };

      "peach" = {
        HostName = "peach.taila30609.ts.net";
      };

      "skmbp" = {
        HostName = "skmbp.taila30609.ts.net";
      };
    };
  };
}
