{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "ovips.us.to" = {
        HostName = "ovips.us.to";
        User = "git";
        Port = 222;
      };
      "oracle" = {
        HostName = "vips.taila30609.ts.net";
        User = "ubuntu";
      };
      "peach" = {
        HostName = "peach.taila30609.ts.net";
      };
      "alien" = {
        HostName = "alien.taila30609.ts.net";
      };
      "skmbp" = {
        HostName = "skmbp.taila30609.ts.net";
      };
      "nas" = {
        HostName = "nas.taila30609.ts.net";
      };
      "Match final host *.ts.net" = {
        # tailscale connections are end-to-end encrypted
        # https://www.openssh.org/pq.html
        # https://tailscale.com/docs/concepts/tailscale-encryption
        WarnWeakCrypto = "no";
      };
      "*" = {
        StrictHostKeyChecking = "no";
        IdentityFile = "~/.ssh/key";
        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };
    };
  };
}
