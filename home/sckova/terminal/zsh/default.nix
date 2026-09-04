# home/sckova/terminal/zsh/default.nix
{
  imports = [
    ./aliases.nix
    ./binds.nix
    ./prompt.nix
    ./settings.nix
    ./syntax-highlighting.nix
  ];

  programs.zsh.enable = true;
}
