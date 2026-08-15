{
  hostname,
  ...
}:
{
  imports = [
    ./tailscale.nix
  ];

  networking = {
    firewall.enable = false;
    hostName = hostname;

    hosts = {
      "192.168.1.244" = [
        "alien"
        "alien.local"
        "alien.attlocal.net"
        "alien.taila30609.ts.net"
      ];

      "192.168.1.250" = [
        "peach"
        "peach.local"
        "peach.attlocal.net"
        "peach.taila30609.ts.net"
      ];

      "192.168.1.64" = [
        "kube1"
        "kube1.local"
        "kube1.attlocal.net"
      ];

      "192.168.1.65" = [
        "kube2"
        "kube2.local"
        "kube2.attlocal.net"
      ];

      "192.168.1.66" = [
        "kube3"
        "kube3.local"
        "kube3.attlocal.net"
        "kube3.taila30609.ts.net"
      ];

      "192.168.1.67" = [
        "kube4"
        "kube4.local"
        "kube4.attlocal.net"
      ];
    };

    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
  };
}
