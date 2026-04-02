source ~/.config/fish/colors.fish
set -l last_status $status
set -l nix_shell_info (
  if test -n "$IN_NIX_SHELL"
    echo -n "<nix-shell> "
  end
)
set -g color_user cyan
set -g color_host red
set -g color_cwd green

# Set host color based on hostname
if test (hostname) = peach
    set -g color_host $color_accent
else if test (hostname) = alien
    set -g color_host $color_accent
else if test (hostname) = vm
    set -g color_host $color_accent
    set -g color_cwd normal
else if test (uname) = Darwin
    set -g color_host $color_base0A
end

set -l user_host (set_color $color_user)"$USER"(set_color normal)"@"(set_color $color_host)(prompt_hostname)(set_color normal)
set -l cwd (set_color $color_cwd)(prompt_pwd)(set_color normal)
set -l git_info (fish_git_prompt)
echo -s "$user_host" " " "$cwd" "$git_info $nix_shell_info"
echo -n -s "> "
