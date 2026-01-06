source ~/.config/fish/colors.fish
set -l last_status $status
set -l nix_shell_info (
  if test -n "$IN_NIX_SHELL"
    echo -n "<nix-shell> "
  end
)
set -g color_user $color_sky
set -g color_host $color_red
set -g color_cwd $color_green

# Set host color based on hostname
if test (hostname) = peach
    set -g color_host $color_peach
else if test (hostname) = alien
    set -g color_host $color_blue
else if test (hostname) = vm-aarch64
    set -g color_host $color_green
    set -g color_cwd $color_red
else if test (uname) = Darwin
    set -g color_host $color_yellow
end

set -l user_host (set_color $color_user)"$USER"(set_color normal)"@"(set_color $color_host)(prompt_hostname)(set_color normal)
set -l cwd (set_color $color_cwd)(prompt_pwd)(set_color normal)
set -l git_info (fish_git_prompt)
echo -s "$user_host" " " "$cwd" "$git_info $nix_shell_info"
echo -n -s "> "
