{catppuccin, ...}: {
  networking.hostName = "vm";

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
