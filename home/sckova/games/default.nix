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
    (shipwright.overrideAttrs (
      finalAttrs: previousAttrs: {
        desktopItems = [
          (makeDesktopItem {
            name = "Ship of Harkinian";
            icon = "soh";
            exec = "soh";
            comment = previousAttrs.meta.description;
            genericName = "Ship of Harkinian";
            desktopName = "Ship of Harkinian";
            keywords = [
              "The Legend of Zelda"
              "Ocarina of Time"
              "Shipwright"
            ];
            categories = [ "Game" ];
          })
        ];
      }
    ))
    # Ocarina of Time PC port
    melonds # Nintendo DS emulator
  ];
}
