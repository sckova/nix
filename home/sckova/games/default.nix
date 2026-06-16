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
    # mkxp-z # RPG Maker XP player
    moonlight-qt # game streaming client
    melonds # Nintendo DS emulator
  ];
}
