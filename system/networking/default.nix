# system/networking/default.nix
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
      ];

      "192.168.1.250" = [
        "peach"
        "peach.local"
        "peach.attlocal.net"
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
      "192.168.1.254" # at&t wifi
    ];

    networkmanager = {
      enable = true;

      ensureProfiles.profiles."switch" = {
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

      wifi.backend = "iwd";
    };
  };

  sops = {
    secrets."kovacs_ssid_pass".sopsFile = ../../lib/secrets/secrets.yaml;

    templates."kovacs_ssid.nmconnection" = {
      content = lib.generators.toINI { mkKeyValue = lib.generators.mkKeyValueDefault { } "="; } {
        connection = {
          id = "kovacs_ssid";
          type = "wifi";
          uuid = "98922beb-9309-4756-89a1-53de63356e35";
        };

        ipv4.method = "auto";

        ipv6 = {
          addr-gen-mode = "default";
          method = "auto";
        };

        wifi = {
          mode = "infrastructure";
          ssid = "kovacs_ssid";
        };

        "wifi-security" = {
          auth-alg = "open";
          key-mgmt = "wpa-psk";
          psk = config.sops.placeholder.kovacs_ssid_pass;
        };
      };

      group = "root";
      mode = "0600";
      owner = "root";
      path = "/etc/NetworkManager/system-connections/kovacs_ssid.nmconnection";
      restartUnits = [ "NetworkManager.service" ];
    };
  };
}
