{
  pkgs,
  config,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    kdePackages.qttools
    eza
    pigz
  ];

  programs.fish = {
    enable = true;
    shellAliases = {
      ssh = "kitty-ssh";
      cat = "bat";
      gzip = "pigz";
      ls = "eza";
      gl = "git log";
      gd = "git diff";
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

  home.file.".config/fish/colors.fish" = {
    text = lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: value: "set -g color_${name} ${value}") (
        lib.filterAttrs (
          n: v: builtins.isString v && builtins.match "^base[0-9A-Fa-f]{2}$" n != null
        ) config.scheme
      )
      ++ [ "set -g color_accent ${config.scheme.${config.colors.accent}}" ]
    );
    force = true;
  };

  programs.man.generateCaches = false;
}
