{
  config,
  pkgs,
  lib,
  catppuccin,
  ...
}: {
  networking.hostName = "vm";

  # Enable emulation for architectures we're not currently running
  boot.binfmt.emulatedSystems =
    lib.optional (pkgs.stdenv.hostPlatform.system != "x86_64-linux") "x86_64-linux"
    ++ lib.optional (pkgs.stdenv.hostPlatform.system != "aarch64-linux") "aarch64-linux"
    ++ lib.optional (pkgs.stdenv.hostPlatform.system != "riscv64-linux") "riscv64-linux";

  catppuccin.accent = "green";

  home-manager.users.sckova = {
    imports = [catppuccin.homeModules.catppuccin];
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
