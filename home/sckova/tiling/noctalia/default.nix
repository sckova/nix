# home/sckova/tiling/noctalia/default.nix
{ inputs, ... }: {
  imports = with inputs; [
    ./colors.nix
    ./settings.nix
    noctalia.homeModules.default
  ];

  programs.noctalia.enable = true;
}
