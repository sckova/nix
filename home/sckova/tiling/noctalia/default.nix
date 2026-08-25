# home/sckova/tiling/noctalia/default.nix
{ inputs, ... }: {
  imports = with inputs; [
    noctalia.homeModules.default
    ./colors.nix
    ./settings.nix
  ];

  # TODO: drop when noctalia reaches v5.0.0-beta.10
  disabledModules = [ "programs/noctalia.nix" ];
  programs.noctalia.enable = true;
}
