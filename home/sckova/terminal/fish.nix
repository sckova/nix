{
  config,
  lib,
  pkgs,
  ...
}:
{
  home = {
    file = {
      ".config/fish/colors.fish" = {
        force = true;

        text = lib.concatStringsSep "\n" (
          lib.mapAttrsToList (name: value: "set -g color_${name} ${value}") (
            lib.filterAttrs (
              n: v: builtins.isString v && builtins.match "^base[0-9A-Fa-f]{2}$" n != null
            ) config.scheme
          )
          ++ [ "set -g color_accent ${config.scheme.${config.colors.accent}}" ]
        );
      };

      ".local/share/bin/.keep".text = ""; # Ensure directory exists
    };

    sessionPath = [
      "${config.xdg.dataHome}/bin"
    ];
  };

  programs = {
    fish = {
      enable = true;

      functions = {
        fish_prompt = {
          body = /* fish */ ''
            source ~/.config/fish/colors.fish
            set -l last_status $status
            set -l nix_shell_info (
              if test -n "$IN_NIX_SHELL"
              echo -n "<nix-shell> "
              end
            )
            set -g color_user $color_base0C
            set -g color_host $color_accent
            set -g color_cwd $color_base0B

            set -l user_host (set_color $color_user)"$USER"(set_color normal)"@"(set_color $color_host)(prompt_hostname)(set_color normal)
            set -l cwd (set_color $color_cwd)(prompt_pwd)(set_color normal)
            set -l git_info (fish_git_prompt)
            echo -s "$user_host" " " "$cwd" "$git_info $nix_shell_info"
            echo -n -s "> "
          '';

          description = "Write out the prompt";
        };

        nix-format = {
          body = /* fish */ ''
            set -l target $argv[1]
            if test -z "$target"
                set target .
            end

            set -l files

            if test -d "$target"
                set files (find "$target" -type f -name '*.nix')
            else if test -f "$target"
                set files "$target"
            else
                echo "nix-format: '$target' is not a file or directory" >&2
                return 1
            end

            if test (count $files) -eq 0
                echo "nix-format: no .nix files found under '$target'" >&2
                return 0
            end

            ${lib.getExe pkgs.nixfmt} $files
            ${lib.getExe pkgs.pedantix} --formatter off $files
            ${lib.getExe pkgs.nixfmt} $files
          '';

          description = "Run neovim's nix formatter chain on file or directory";
        };

        nix-shell = {
          body = /* fish */ ''
            if test (count $argv) -eq 0
                command nix-shell --run fish
            else
                command nix-shell --run fish $argv
            end
          '';

          description = "Wrapper for nix-shell that runs fish by default";
        };
      };

      interactiveShellInit = ''
        set fish_greeting # Disable greeting
        export GPG_TTY=$(tty) # Fix gpg-agent service
      '';

      shellAliases = {
        cat = "bat";
        ga = "git add -v .";
        gac = "git add -v . && git commit";
        gaca = "git add -v . && git commit --amend --no-edit";
        gd = "git diff";
        gl = "git log";
        gp = "git push";
        gpf = "git push --force";
        gzip = "pigz";
        ls = "eza";
      };
    };

    man.generateCaches = false;

    zsh = {
      enable = true; # If in an interactive session, run fish

      initContent = /* zsh */ ''
        if [[ $(ps -o command= -p "$PPID" | awk '{print $1}') != 'fish' ]]
        then
          exec fish -l
        fi
      '';
    };
  };
}
