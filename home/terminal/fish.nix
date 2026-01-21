{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    kdePackages.qttools
    eza
  ];

  programs.fish = {
    enable = true;
    shellAliases = {
      ssh = "kitty-ssh";
      cat = "bat";
      ls = "eza";
      gl = "git log";
      ga = "git add -v .";
      gac = "git add -v . && git commit";
      gaca = "git add -v . && git commit --amend --no-edit";
      gp = "git push";
      gpf = "git push --force";
    };
    functions = {
      fish_prompt = {
        description = "Write out the prompt";
        body = builtins.readFile ./fish_functions/fish-prompt.fish;
      };
      kitty-ssh = {
        description = "Integrate Kitten SSH with Fish";
        body = builtins.readFile ./fish_functions/kitty-ssh.fish;
      };
      nix-shell = {
        description = "Wrapper for nix-shell that runs fish by default";
        body = builtins.readFile ./fish_functions/nix-shell.fish;
      };
      logout = {
        description = "Log out of KDE Plasma";
        body = builtins.readFile ./fish_functions/logout.fish;
      };
    };
  };
  programs.man.generateCaches = false;
}
