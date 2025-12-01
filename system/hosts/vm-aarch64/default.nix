{
  config,
  pkgs,
  lib,
  catppuccin,
  ...
}:
{
  networking.hostName = "vm-aarch64";

  boot.binfmt.emulatedSystems = [
    "x86_64-linux"
    "riscv64-linux"
  ];

  catppuccin.accent = "green";

  home-manager.users.sckova = {
    imports = [ catppuccin.homeModules.catppuccin ];
  };

  services.spice-vdagentd.enable = true;

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 8192;
      cores = 6;
    };
  };

  security.sudo.wheelNeedsPassword = false;
}
