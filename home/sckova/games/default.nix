{
  pkgs,
  lib,
  isLinux,
  ...
}:
{
  imports = [
    ./minecraft.nix
  ]
  ++ lib.optional isLinux [
    ./morrowind.nix
  ];

  home.packages = with pkgs; [
    dolphin-emu
  ];
}
