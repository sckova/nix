{
  inputs,
  ...
}:
{
  imports = with inputs; [
    aerothemeplasma.nixosModules.aerothemeplasma-nix
  ];

  boot.plymouth.enable = true;

  programs.aeroshell = {
    enable = true;

    aerothemeplasma = {
      enable = true;
      plymouth.enable = true;
      sddm.enable = true;
    };

    fonts.segoe.enable = true;
    polkit.enable = true;
  };

  services = {
    desktopManager.plasma6.enable = true;

    displayManager = {
      defaultSession = "aerothemeplasma"; # for x11, append x11
      sddm.enable = true;
    };
  };
}
