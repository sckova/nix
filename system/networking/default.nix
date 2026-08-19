{
  config,
  lib,
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

    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];

    networkmanager = {
      enable = true;

      ensureProfiles.profiles =
        lib.mkIf (config.networking.hostName == "alien" || config.networking.hostName == "peach")
          {
            "switch" = {
              connection = {
                id = "switch";
                type = "ethernet";
              };

              ipv4 =
                let
                  base = "192.168.99.";
                  nums = if config.networking.hostName == "alien" then "100" else "200";
                in
                {
                  address1 = base + nums + "/24";
                  method = "manual";
                };
            };
          };

      wifi.backend = "iwd";
    };
  };
}
