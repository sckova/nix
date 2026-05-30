{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false; # this will be gone in the future
    settings = {
      "ovips.us.to" = {
        HostName = "ovips.us.to";
        User = "git";
        Port = 222;
      };
      "oracle" = {
        HostName = "vips.taila30609.ts.net";
        User = "ubuntu";
        RequestTTY = "force";
        RemoteCommand = "/bin/fish";
      };
      "peach" = {
        HostName = "peach.taila30609.ts.net";
        RequestTTY = "force";
        RemoteCommand = "/etc/profiles/per-user/sckova/bin/fish";
      };
      "alien" = {
        HostName = "alien.taila30609.ts.net";
        RequestTTY = "force";
        RemoteCommand = "/etc/profiles/per-user/sckova/bin/fish";
      };
      "skmbp" = {
        HostName = "skmbp.taila30609.ts.net";
        RequestTTY = "force";
        RemoteCommand = "/etc/profiles/per-user/sckova/bin/fish";
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
