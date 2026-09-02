# home/sckova/terminal/zsh/default.nix
{
  imports = [
    ./settings.nix
    ./binds.nix
    ./prompt.nix
    ./aliases.nix
  ];

  programs.zsh.enable = true;
}
