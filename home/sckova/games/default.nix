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
  ++ lib.optionals isLinux [
    ./morrowind.nix
  ];

  home.packages = with pkgs; [
    dolphin-emu
  ];
}
