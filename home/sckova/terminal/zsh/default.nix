# home/sckova/terminal/zsh/default.nix
{
  imports = [
    ./settings.nix
    ./binds.nix
    ./prompt.nix
    ./aliases.nix
    ./syntax-highlighting.nix
  ];

  programs.zsh.enable = true;
}
