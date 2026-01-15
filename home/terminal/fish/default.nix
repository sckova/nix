{
  config,
  pkgs,
  lib,
  ...
}: {
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
  programs.man.generateCaches = false;

  home.file.".config/fish/colors.fish" = {
    text = let
      flavor = config.catppuccin.flavor;
      palette = pkgs.catppuccin.bare.${flavor};
      accent = config.catppuccin.accent;
    in
      lib.concatStringsSep "\n" (
        (lib.mapAttrsToList (name: value: "set -g color_${name} ${value}") palette)
        ++ ["set -g color_accent ${palette.${accent}}"]
      );
    force = true;
  };
}
