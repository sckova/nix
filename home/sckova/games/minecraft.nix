# home/sckova/games/minecraft.nix
{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    (prismlauncher.override {
      jdks = [
        jdk21
      ];
    })
  ];
}
