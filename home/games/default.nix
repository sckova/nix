{ pkgs, ... }:
{
  imports = [
    ./minecraft.nix
    ./morrowind.nix
  ];

  home.packages = with pkgs; [
    dolphin-emu
  ];
}
