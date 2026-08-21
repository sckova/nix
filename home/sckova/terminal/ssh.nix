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

      "alien".HostName = "alien.taila30609.ts.net";
      "alien-lan".HostName = "192.168.99.100";

      "github" = {
        HostName = "github.com";
        User = "git";
      };

      "nas".HostName = "nas.taila30609.ts.net";

      "ovips.us.to" = {
        HostName = "ovips.us.to";
        Port = 2468;
        User = "forgejo";
      };

      "peach".HostName = "peach.taila30609.ts.net";
      "peach-lan".HostName = "192.168.99.200";
      "skmbp".HostName = "skmbp.taila30609.ts.net";

      "tea" = {
        HostName = "kube3.taila30609.ts.net";
        Port = 222;
        User = "git";
      };
    };
  };
}
