{
  config,
  lib,
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

          description = "Write out the prompt";
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
