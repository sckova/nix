{
  imports = [
    ./settings.nix
    ./binds.nix
    ./prompt.nix
    ./aliases.nix
  ];

  home.file.".local/share/bin/.keep".text = ""; # Ensure directory exists
  programs.zsh.enable = true;
}
