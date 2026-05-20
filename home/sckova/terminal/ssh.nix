{
  programs.ssh.settings = {
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
    };
  };
}
