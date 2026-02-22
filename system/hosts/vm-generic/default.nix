{ ... }:
{
  home-manager.users.sckova = {
    imports = [ ];
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
