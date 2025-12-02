{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;

    functions = {
      fish_prompt = {
        description = "Write out the prompt";
        body = ''
          set -l last_status $status

          set -l nix_shell_info (
            if test -n "$IN_NIX_SHELL"
              echo -n "<nix-shell> "
            end
          )

          set -g fish_color_user 89dceb

          # Set host color based on hostname
          if test (hostname) = "peach"
            set -g fish_color_host fab387
          else if test (hostname) = "alien"
            set -g fish_color_host 89b4fa
          else if test (hostname) = "vm-aarch64"
            set -g fish_color_host a6e3a1
          else if test (uname) = "Darwin"
            set -g fish_color_host f9e2af
          end

          set -l user_host (set_color $fish_color_user)"$USER"(set_color normal)"@"(set_color $fish_color_host)(prompt_hostname)(set_color normal)

          set -l cwd (set_color $fish_color_cwd)(prompt_pwd)(set_color normal)

          set -l git_info (fish_git_prompt)

          echo -s "$user_host" " " "$cwd" "$git_info $nix_shell_info"
          echo -n -s "> "
        '';
        # echo -n -s "$user_host" " " "$nix_shell_info" "$cwd" "$git_info" "> "
      };
      nix-shell = {
        description = "Wrapper for nix-shell that runs fish by default";
        body = ''
          if test (count $argv) -eq 0
            command nix-shell --run fish
          else
            command nix-shell --run fish $argv
          end
        '';
      };
    };
  };
}
