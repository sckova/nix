{ inputs, ... }: {
  imports = with inputs; [
    noctalia.homeModules.default
    ./colors.nix
    ./settings.nix
  ];

  programs.noctalia.enable = true;
}
