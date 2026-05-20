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
