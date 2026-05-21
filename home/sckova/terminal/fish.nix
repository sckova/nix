{
  config,
  lib,
  ...
}:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    shellAliases = {
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
        body = /* fish */ ''
          source ~/.config/fish/colors.fish
          set -l last_status $status
          set -l nix_shell_info (
            if test -n "$IN_NIX_SHELL"
              echo -n "<nix-shell> "
            end
          )
          set -g color_user $color_base0C
          set -g color_host $color_base08
          set -g color_cwd $color_base0B

          # Set host color based on hostname
          if test (hostname) = peach
              set -g color_host $color_accent
          else if test (hostname) = alien
              set -g color_host $color_accent
          else if test (hostname) = skmbp
              set -g color_host $color_accent
          end

          set -l user_host (set_color $color_user)"$USER"(set_color normal)"@"(set_color $color_host)(prompt_hostname)(set_color normal)
          set -l cwd (set_color $color_cwd)(prompt_pwd)(set_color normal)
          set -l git_info (fish_git_prompt)
          echo -s "$user_host" " " "$cwd" "$git_info $nix_shell_info"
          echo -n -s "> "
        '';
      };
      nix-shell = {
        description = "Wrapper for nix-shell that runs fish by default";
        body = /* fish */ ''
          if test (count $argv) -eq 0
              command nix-shell --run fish
          else
              command nix-shell --run fish $argv
          end
        '';
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
