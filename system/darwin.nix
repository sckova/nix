{
  lib,
  hostname,
  inputs,
  users,
  ...
}:
{
  imports = with inputs; [
    sops-nix.darwinModules.sops
    ../lib
    ../hardware
    # ./apps (has nothing relevant)
    # ./services (has nothing relevant, TODO: figure out searxng for user-level?)
    # ./networking (see https://github.com/nix-darwin/nix-darwin/issues/1035)
    ./networking/tailscale.nix
  ];

  networking = {
    computerName = hostname;

    dns = [
      "1.1.1.1"
      "8.8.8.8"
    ];

    hostName = hostname;

    # list obtained from `networksetup -listallnetworkdevices`
    knownNetworkServices = [
      "AX88179A" # my Anker ethernet adapter
      "Thunderbolt Bridge"
      "Wi-Fi"
      "iPhone USB"
      "Tailscale"
    ];
  };

  nix.linux-builder.enable = true; # allow aarch64-linux builds via lightweight VM
  nixpkgs.hostPlatform = "aarch64-darwin";

  security.pam.services.sudo_local = {
    enable = true;
    reattach = true;
    touchIdAuth = true;
  };

  system.stateVersion = 7;

  users.users = lib.genAttrs users (user: {
    home = "/Users/${user}";
  });
}
