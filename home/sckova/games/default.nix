# home/sckova/games/default.nix
{
  lib,
  pkgs,
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
    melonds # Nintendo DS emulator
    # shipwright # Ocarina of Time PC port
    # mkxp-z # RPG Maker XP player
    moonlight-qt # game streaming client
  ];
}
