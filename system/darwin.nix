{
  lib,
  hostname,
  inputs,
  users,
  ...
}:
{
  imports = with inputs; [
    sops-nix.nixosModules.sops
    ../lib
    ../hardware
    # ./apps (has nothing relevant)
    # ./services (has nothing relevant, TODO: figure out searxng for user-level?)
    # ./networking (see https://github.com/nix-darwin/nix-darwin/issues/1035)
  ];

  networking.hostName = hostname;
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
