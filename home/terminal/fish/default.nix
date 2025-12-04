{ config, pkgs, ... }:
{
  home.packages = with pkgs; [ kdePackages.qttools ];

  programs.fish = {
    enable = true;
    shellAliases = {
      ssh = "kitty-ssh";
    };
    functions = {
      fish_prompt = {
        description = "Write out the prompt";
        body = builtins.readFile ./functions/fish-prompt.fish;
      };
      kitty-ssh = {
        description = "Integrate Kitten SSH with Fish";
        body = builtins.readFile ./functions/kitty-ssh.fish;
      };
      nix-shell = {
        description = "Wrapper for nix-shell that runs fish by default";
        body = builtins.readFile ./functions/nix-shell.fish;
      };
      logout = {
        description = "Log out of KDE Plasma";
        body = builtins.readFile ./functions/logout.fish;
      };
    };
  };
}
